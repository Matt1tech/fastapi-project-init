# Architecture choices

## Modular layered (default)
`api`, `services`, `repositories`, `models`, `schemas`, `core`, `integrations`.
Best for most apps: simple, familiar, easy to test.

## Clean Architecture
```
app/
├── domain/          # entities, value objects, ports - no FastAPI/DB imports
├── application/     # use cases, DTOs
├── infrastructure/  # DB, external clients, repository implementations
└── presentation/    # FastAPI routes, schemas, dependencies
```
Dependencies point inward. Domain must not depend on FastAPI or database implementations.

## Hexagonal
```
app/
├── domain/                # core logic + ports (Protocol/ABC interfaces)
├── adapters/inbound/      # HTTP routes
└── adapters/outbound/     # DB, cache, external APIs implementing ports
```
External systems are always accessed through interfaces.

## Minimal
```
app/
├── routes/
├── schemas/
├── services/
├── core/
└── main.py
```
No empty abstraction layers. Recommend for small APIs and prototypes.

## Microservices
Independently deployable services with explicit boundaries (own `pyproject.toml`,
`uv.lock`, Dockerfile, and contract). Warn the user that microservices add
operational cost and are rarely justified for a small application; confirm the reason
before proceeding, and suggest a modular monolith otherwise.
