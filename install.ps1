#!/usr/bin/env pwsh
#Requires -Version 5.1
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$RepoDir          = $PSScriptRoot
$SkillsDir        = Join-Path $RepoDir 'skills'
$CommandsDir      = Join-Path $RepoDir 'commands'
$AgentsMd         = Join-Path $RepoDir 'AGENTS.md'
$TargetDir        = Join-Path $HOME '.agents\skills'
$CanonicalRepo    = Join-Path $HOME '.agents\agent-skills'
$ClaudeCommands   = Join-Path $HOME '.claude\commands'

function New-Symlink {
    param([string]$Link, [string]$Target)
    if (Test-Path -LiteralPath $Link) { Remove-Item -LiteralPath $Link -Recurse -Force }
    $parent = Split-Path -Parent $Link
    if (-not (Test-Path -LiteralPath $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
    New-Item -ItemType SymbolicLink -Path $Link -Target $Target | Out-Null
}

function Test-SymlinkCapability {
    $tmp    = Join-Path $env:TEMP "agentskills-$([guid]::NewGuid().ToString('N'))"
    $null   = New-Item -ItemType Directory -Path $tmp
    $target = Join-Path $tmp 'target'; $link = Join-Path $tmp 'link'
    Set-Content -LiteralPath $target -Value '' -NoNewline
    $ok = $false
    try {
        $null = New-Item -ItemType SymbolicLink -Path $link -Target $target -ErrorAction Stop
        $ok = (Get-Item -LiteralPath $link).LinkType -eq 'SymbolicLink'
    } catch { $ok = $false }
    Remove-Item -LiteralPath $tmp -Recurse -Force
    if (-not $ok) {
        Write-Host ""
        Write-Host "X Cannot create symbolic links." -ForegroundColor Red
        Write-Host ""
        Write-Host "Enable one of:"
        Write-Host "  - Developer Mode: Settings -> Privacy & security -> For developers -> Developer Mode"
        Write-Host "  - OR re-run this script from an elevated (Administrator) PowerShell."
        Write-Host ""
        exit 1
    }
}

function Install-Skills {
    if (-not (Test-Path -LiteralPath $TargetDir)) { New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null }
    Get-ChildItem -LiteralPath $SkillsDir -Directory | ForEach-Object {
        New-Symlink -Link (Join-Path $TargetDir $_.Name) -Target $_.FullName
        Write-Host "  linked $($_.Name)"
    }
    Write-Host "OK Skills -> $TargetDir"
}

function Install-AgentsMd {
    # TODO: once ~/.config/agents/AGENTS.md is universally adopted (agentskills.io issue #91),
    # replace all tool-specific paths below with that single XDG path.
    $paths = @(
        (Join-Path $HOME '.config\agents\AGENTS.md'),                  # proposed XDG standard (issue #91)
        (Join-Path $HOME '.codex\AGENTS.md'),                          # Codex CLI
        (Join-Path $HOME '.claude\CLAUDE.md'),                         # Claude Code
        (Join-Path $HOME '.config\AGENTS.md'),                         # Amp
        (Join-Path $HOME '.codeium\windsurf\memories\global_rules.md') # Windsurf global rules
    )
    foreach ($dest in $paths) {
        New-Symlink -Link $dest -Target $AgentsMd
        Write-Host "  linked $(Split-Path -Leaf $dest) -> $dest"
    }
    Write-Host "OK AGENTS.md -> global tool paths"
}

function Install-Commands {
    if (-not (Test-Path -LiteralPath $CommandsDir)) {
        Write-Host "  (no commands/ directory - skipping)"; return
    }
    $files = Get-ChildItem -LiteralPath $CommandsDir -Filter *.md -File -ErrorAction SilentlyContinue
    if (-not $files) { Write-Host "  (no .md files in commands/ - skipping)"; return }
    if (-not (Test-Path -LiteralPath $ClaudeCommands)) { New-Item -ItemType Directory -Path $ClaudeCommands -Force | Out-Null }
    foreach ($f in $files) {
        New-Symlink -Link (Join-Path $ClaudeCommands $f.Name) -Target $f.FullName
        Write-Host "  linked /$($f.BaseName)"
    }
    Write-Host "OK Slash commands -> $ClaudeCommands"
}

function Install-CanonicalLink {
    if ($RepoDir -ieq $CanonicalRepo) {
        Write-Host "  (repo already at canonical path - skipping)"; return
    }
    New-Symlink -Link $CanonicalRepo -Target $RepoDir
    Write-Host "OK Repo -> $CanonicalRepo (canonical path for skills)"
}

function Show-ClaudePluginInstructions {
    # TODO: automate plugin install + userConfig seeding once
    # https://github.com/anthropics/claude-code/issues/39827 is fixed
    # (currently `claude plugin install` cannot pass userConfig values,
    # so the GitHub MCP only wires up via the interactive /plugin flow).
    Write-Host "Claude Code plugin (manual, one-time):"
    Write-Host "  Open Claude Code and run:"
    Write-Host ""
    Write-Host "    /plugin marketplace add InnoVestrum/agent-skills"
    Write-Host "    /plugin install innovestrum-standards@innovestrum"
    Write-Host ""
    Write-Host "  You will be prompted for a GitHub Personal Access Token"
    Write-Host "  (scopes: repo, read:org - create at https://github.com/settings/tokens)."
    Write-Host "  This is the only path that wires up the GitHub MCP correctly."
}

Write-Host "InnoVestrum Agent Skills installer"
Write-Host "Source: $RepoDir"
Write-Host ""

Test-SymlinkCapability
Install-Skills;          Write-Host ""
Install-AgentsMd;        Write-Host ""
Install-Commands;        Write-Host ""
Install-CanonicalLink;   Write-Host ""
Show-ClaudePluginInstructions
Write-Host ""
Write-Host "Done. Restart your agent to pick up new skills and commands."
Write-Host "  Other tools: ask your agent to invoke the 'setup-mcps' skill for guided MCP setup."
Write-Host "Weekly ritual: run /reflect-triage in Claude Code to process captured learnings."
Write-Host ""
Write-Host "To update: git -C `"$RepoDir`" pull; & `"$RepoDir\install.ps1`""
