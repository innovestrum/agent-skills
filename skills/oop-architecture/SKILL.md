---
name: oop-architecture
description: Apply OOP principles, SOLID design, GRASP patterns, dependency injection, and inversion of control when designing classes, modules, or service layers. Use when creating new classes or interfaces, refactoring to OOP, structuring a new module, or when the user asks about architecture, design patterns, or code structure.
license: MIT
metadata:
  author: InnoVestrum
  version: "1.0"
  repo: https://github.com/InnoVestrum/agent-skills
---

## OOP Architecture Standards

### OOP Principles

- **Encapsulation**: Hide internal state. Expose behaviour through well-defined interfaces, not raw fields.
- **Inheritance**: Use for genuine IS-A relationships only. Prefer shallow hierarchies (max 2–3 levels).
- **Composition over inheritance**: Prefer HAS-A relationships for code reuse. Favour composing small, focused objects.
- **Polymorphism**: Program to abstractions (interfaces/abstract classes), not concrete implementations.

### SOLID

- **S — Single Responsibility**: One class = one reason to change. Split classes that serve multiple concerns.
- **O — Open/Closed**: Open for extension, closed for modification. Use interfaces, strategy pattern, or plugins.
- **L — Liskov Substitution**: Subtypes must be substitutable for their base types without breaking behaviour.
- **I — Interface Segregation**: Many focused interfaces over one fat interface. Clients should not depend on methods they don't use.
- **D — Dependency Inversion**: High-level modules depend on abstractions, not concretions. Inject dependencies via constructor.

### GRASP

- **Controller**: Assign responsibility for handling system events to a controller class, not to UI or data objects.
- **Creator**: Assign object creation to the class that aggregates, contains, or closely uses the created object.
- **High Cohesion**: Keep related responsibilities together. Low cohesion is a sign a class needs splitting.
- **Low Coupling**: Minimize dependencies between classes. Favour dependency injection over `new` inside business logic.
- **Information Expert**: Assign a responsibility to the class that has the information needed to fulfil it.

### Dependency Injection & Inversion of Control

- Inject all external dependencies (services, repositories, config, loggers) via constructor parameters.
- Never use `new ConcreteClass()` inside business logic — resolve dependencies at the composition root.
- Use an IoC container or factory where the language/framework supports it.
- Interfaces define contracts between layers; implementations are swappable.

### Project Structure Pattern

```
src/
  domain/          # Pure business logic — no framework dependencies
    models/
    services/
    interfaces/
  application/     # Use cases / orchestration — depends on domain interfaces
  infrastructure/  # Implementations: DB, HTTP, external APIs
  presentation/    # Controllers, CLI, API handlers
```

### Workflow

1. Start with interfaces in `domain/interfaces/` before writing implementations.
2. Write domain logic first — it must not import infrastructure code.
3. Wire dependencies at the composition root (main entry point or DI container config).
4. Keep each class focused: if you can't describe it in one sentence, split it.

## Gotchas

- Do not inject the IoC container itself into business classes — that is Service Locator, an anti-pattern.
- Inheritance hierarchies deeper than 3 levels almost always indicate a design smell.
- Abstract base classes with many methods are a sign of Interface Segregation violation.
- Circular dependencies between modules indicate a missing abstraction or wrong layer assignment.
