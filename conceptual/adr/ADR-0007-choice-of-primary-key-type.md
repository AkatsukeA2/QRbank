# ADR 007: Choice of Primary Key Type for QRbank Core Entities

## Status
Accepted

---

## Context

QRbank is a digital wallet platform designed to support financial operations such as wallet management, QR payments, transfers, and transaction history.

The backend is built using Java Spring Boot with a Mysql database.

Core entities of the system include:

- **User**
- **Wallet**
- **Transaction**
- **QRCode**
- **Merchant**
- **Payment**

Choosing the correct primary key (PK) type affects:

- database performance

- join efficiency

- referential integrity

- future scalability

The following options were evaluated:

- **BIGINT** auto-increment

- **UUID**

- **ULID**

- **String**
---

## Decision

QRbank will use BIGINT AUTO_INCREMENT as the primary key for all core entities.

Advantages:

- optimal performance in **MySQL**

- smaller indexes

- faster joins

- simple implementation
---

## Why not UUID

Although UUIDs provide global uniqueness, they present several disadvantages for QRbank. Their larger size results in larger indexes and reduced performance in joins and queries. UUID v4 is not sortable, potentially causing index fragmentation in Mysql, while UUID v1 includes timestamp and hardware information, making debugging more complex. Furthermore, their long textual representation reduces readability in logs and manual testing. For a centralized system like QRbank, the global uniqueness offered by UUID is unnecessary.

---

## Why not ULID

ULID offers global uniqueness and lexicographic ordering, representing a modern alternative to UUID. However, its generation requires external libraries in the application, increasing complexity. Although more compact than UUID (26 characters), it is still significantly larger than a `BIGINT` (8 bytes), affecting index size and storage. Its readability is lower, making debugging and manual data handling more cumbersome. Since QRbank is currently a centralized system, the need for globally unique and sortable IDs is not critical, making ULID unnecessary at this stage.

---

## Why not Strings

Using strings as primary keys increases index size and reduces performance for joins and queries. Strings also require additional validation and can introduce inconsistencies if not carefully managed. While they provide readability and flexibility, for QRbank, the efficiency and simplicity of `BIGINT` outweigh these advantages.

---

## Consequences

All QRbank primary keys will use `BIGINT`, mapped to Java `Long`, ensuring maximum performance, simplicity, and readability. Foreign keys will follow the same pattern, maintaining referential integrity and efficient joins. This decision keeps the system robust and easy to maintain, while allowing future migration to ULID or UUID if distributed architecture or system integration becomes necessary.