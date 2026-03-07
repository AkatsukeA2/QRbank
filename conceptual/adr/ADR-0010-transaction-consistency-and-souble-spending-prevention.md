# ADR 0010: Transaction Consistency and Double Spending Prevention

## status

proposed

---

## Context

**QRbank** is a digital wallet platform that manages financial operations such as payments, transfers, and QR transactions.

Because the system handles **monetary balances**, it must guarantee that a wallet cannot spend the same funds more than once.

This problem is known as **double spending**, and it can occur when:

QRbank is a digital wallet platform that manages financial operations such as payments, transfers, and QR transactions.

Because the system handles monetary balances, it must guarantee that a wallet cannot spend the same funds more than once.

This problem is known as double spending, and it can occur when:

- two transactions are processed simultaneously
- concurrent requests try to use the same wallet balance
- database update are not properly synchronized 

To ensure **financial integrity**, the system must guarantee that every
transaction is **atomic, consistent, and isolated**.

The database used in QRbank is **MySQL**, which supports **ACID transactions**.

---

## Decision

All financial operations in QRbank will be executed inside database transactions using MySQL transactional guarantees.

The system will enforce the following rules:

- Every payment or transfer runs inside a single database transaction.
- The wallet balance is **checked and update automically.
- Wallet rows involved in a transaction are locked during the operation.
- If any step fail, the entire transaction is rolled back.

This ensures that **no two transactions can modify the same wallet balance simultaneously**.

---

## Consequences

### Positive

- Prevents double spending
- Guarantees financial consistency
- Ensures atomic wallet operations
- Maintains a reliable audit trail

### Negative

- Slightly higher database contention during heavy load
- Requires careful transaction design

---

## Decision Summary

QRbank will prevent **double spending** by executing all wallet operations inside **ACID database 
transactions in MySQL**, using row locking and atomic updates to guarantee financial consistency.

---