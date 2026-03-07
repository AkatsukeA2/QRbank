# ADR 0009: QR Payment Architecture

## Status 

Accepted

---

## Context

QRbank is a digital wallet platform that enables users 
to perform payments using QR codes.
QR payments are widely used in digital payment 
systems because they allow fast, contactless transactions
between users and merchants.

The system must support:

- generating QR codes for payments
- scanning QR codes using the mobile application
- validating payments requests
- executing secure financial transactions
- recording transaction in the database


The architecture must guarantee transaction integrity, security, traceability and follow the KYC norm.

---

## Decision

QRbank will implement a dynamic QR payment architecture.

The flow is defined as follows:

- A merchant or user generates a QR code containing a payment reference.
- The mobile app scans the QR code.
- The app sends the payment request to the backend API.
- The backend validates:
  - the QR reference
  - wallet balance
  - transaction rules
- If validation succeeds, the system performs the transaction:
  - debit from payer wallet
  - credit to merchant wallet

- The transaction is stored in the MySQL database.

All operations will be executed inside a database transaction to guarantee atomicity.

---

## Consequence

### Positive

- Fast and simple payment experience
- Contactless transaction
- Clear audit of payments
- Secure execution through database transactions

### Negative

- Requires strong validation to prevent **duplicate payment**
- QR references must expire to prevent reuse
- Additional backend logic is needed for QR generation and validation

---

## Decision summary

QRbank will implement dynamic QR-based payments, 
where QR codes represent payment references validated by
the backend.
Transactions will be executed atomically and stored
in MySQL to ensure consistency and traceability of
all financial operations.