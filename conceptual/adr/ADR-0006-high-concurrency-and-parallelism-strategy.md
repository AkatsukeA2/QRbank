# ADR 0006: High Concurrency and Parallelism Strategy

## Status
Accepted

## Context

The platform must handle a high volume of concurrent users interactions.

---

## Decision

The system adopts:
- Non-blocking I/O (WebFlux)
- Stateless services
- Horizontal scaling

---

## Consequences

- High throughput
- Cloud-native readiness

---

## Decision Summary

QRbank is designed for high concurrency from the start.