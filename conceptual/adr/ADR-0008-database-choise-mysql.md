# ADR 0008: Database Choice (MySQL)

---
## status

Accepted

---

## Context

The QRbank platform is a digital wallet system that manages users, wallets, QR payments, and financial transactions.

The backend is built using Java Spring Boot, and the system requires a reliable relational database capable of handling:

- transactional consistency

- secure financial records

- relational data between entities (`User`, `Wallet`, `Transaction`, `Payment`)

- high query performance

Several database options were considered:

- **MySQL**

- **PostgreSQL**

- **MongoDB**

---

## Decision

The system will use **MySQL* as the primary relational database.

MySQL provides:

strong **ACID** compliance for financial transactions

high performance for **read and write** operations

strong support in the **Spring Boot** ecosystem

mature tooling and wide community support

It integrates well with `JPA/Hibernate`, which is used in the backend.

---

## Consequences

## Positive

- Reliable transaction handling

- Efficient relational queries

- Strong integration with Spring Boot and Hibernate
- Mature ecosystem and tooling

## Negative

Less flexibility for schema changes compared to NoSQL databases

Some advanced analytical features are more limited compared to PostgreSQL

---

## Decision Summary

MySQL is adopted as the primary database for the QRbank platform to ensure reliable relational data management and strong transactional integrity for financial operations.