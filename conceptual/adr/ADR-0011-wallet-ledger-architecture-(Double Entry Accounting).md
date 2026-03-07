# ADR 0011: Wallet Ledger Architecture (Double Entry Accounting)

## Status

Proposed

---

## Context

QRbank is a digital wallet platform that manages financial operations such as:

- wallet deposits
- QR payments
- transfers between users
- merchant payments

In financial systems, storing only a **wallet balance
field** can lead to inconsistencies, data corruption, or fraud if updates fail or concurrent transactions occur.

To guarantee **auditability, traceability, and financial correctness**,
the system must record every financial movement as part of a structured ledger.

Financial platforms commonly use **double-entry** accounting,
where each transaction generates two entries:

- A **debt**
- a **credit**

The database used in QRbank is **MySQL**, which supports transactional consistency required for ledger systems.

---
## Decision

QRbank will implement a **wallet ledger architecture using double-entry** accounting.

Instead of relying only on a `balance` column, the system will store all financial movements in a ledger table.

Each transaction will generate two ledger entries:

- debit from the payer wallet

- credit to the receiver wallet

---

## Consequences
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
### Positive

- Full audit trail of all financial operations

- Prevents silent balance corruption

- Easier fraud detection

- Standard model used in financial systems

### Negative

- More complex database structure

- More tables and records per transaction

- Slightly higher storage usage

---

## Decision summary

QRbank will use a double-entry ledger architecture where each financial transaction generates corresponding debit and credit entries stored in the database. This approach ensures **financial accuracy,
traceability, and consistency in the MySQL database**.

