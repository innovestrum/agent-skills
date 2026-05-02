---
name: cloud-native
description: Apply 12-factor app methodology, cloud-native patterns, and container best practices when building services, writing Dockerfiles, configuring CI/CD, or deploying applications. Use when creating a new service, writing infrastructure code, Dockerfiles, environment configuration, or when the user asks about deployment, scalability, or production readiness.
license: MIT
metadata:
  author: InnoVestrum
  version: "1.0"
  repo: https://github.com/InnoVestrum/agent-skills
compatibility: Applies to any containerised service. Docker must be available for container tasks.
---

## Cloud-Native & 12-Factor Standards

### 12-Factor Checklist

Apply all 12 factors. Critical ones to check first:

- [ ] **Config**: All configuration in environment variables — never hardcoded, never committed.
- [ ] **Codebase**: One codebase tracked in version control, many deploys.
- [ ] **Dependencies**: Explicitly declare all dependencies (e.g. `requirements.txt`, `package.json`). Never rely on system-installed packages.
- [ ] **Backing services**: Treat DBs, queues, caches as attached resources configured via URL env vars.
- [ ] **Build/release/run**: Strictly separate build, release, and run stages.
- [ ] **Processes**: Execute as stateless processes. No sticky sessions. State lives in backing services.
- [ ] **Port binding**: Export services via port binding — app is self-contained, not injected into a server.
- [ ] **Concurrency**: Scale out via process model. Horizontally scalable by default.
- [ ] **Disposability**: Fast startup, graceful shutdown. Handle SIGTERM correctly.
- [ ] **Dev/prod parity**: Keep dev, staging, prod as similar as possible.
- [ ] **Logs**: Treat logs as event streams. Write to stdout/stderr only — never manage log files.
- [ ] **Admin processes**: Run admin/management tasks as one-off processes in the same environment.

### Dockerfile Standards

- **Base image**: Always use Alpine variants (`-alpine`) unless a hard requirement prevents it. Example: `node:20-alpine`, `python:3.13-alpine`.
- **Multi-stage builds**: Use multi-stage builds to keep production images minimal.
- **Non-root user**: Run the app as a non-root user in the final stage.
- **Layer caching**: Copy dependency manifests first, install deps, then copy source — maximises cache hits.
- **No secrets in image**: Never `COPY` `.env` files or embed credentials. Use runtime env vars or secrets managers.
- **Pin versions**: Pin base image versions and package versions for reproducible builds.

### Dockerfile Template

```dockerfile
# --- build stage ---
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

# --- runtime stage ---
FROM node:20-alpine
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY . .
USER appuser
EXPOSE 3000
CMD ["node", "src/index.js"]
```

### Environment Configuration

- All config values come from environment variables.
- Provide a `.env.example` file with all required keys documented — never the actual `.env`.
- Add `.env` to `.gitignore`.
- Use a config module that validates required env vars at startup and fails fast with a clear error if any are missing.

### Health & Observability

- Expose a `/health` (liveness) and `/ready` (readiness) endpoint.
- `/ready` checks that all backing services (DB, cache, etc.) are reachable.
- Emit structured JSON logs with at minimum: `timestamp`, `level`, `message`, `traceId`.

### Workflow

1. Start with `docker-compose.yml` for local dev with all backing services.
2. Write `.env.example` before writing any code that reads config.
3. Validate env vars in a single config module at app startup.
4. Write Dockerfile using multi-stage + Alpine base.
5. Verify `docker build` produces a working image before committing.

## Gotchas

- Alpine uses `musl` libc — some native Node/Python packages require `glibc`. If build fails, use `-slim` (Debian) as fallback and document why.
- Never use `CMD` with shell form (`CMD node app.js`) — use exec form (`CMD ["node", "app.js"]`) so SIGTERM reaches the process.
- `HEALTHCHECK` in Dockerfile is useful but not a substitute for orchestrator-level health probes (Kubernetes liveness/readiness).
