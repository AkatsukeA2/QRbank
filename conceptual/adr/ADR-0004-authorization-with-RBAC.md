# ADR 0004: Authorization with RBAC

---
## Status

---
Accepted

## Context

---
The **QRbank platform** is a digital wallet system 
that manages financial transactions, user accounts,
QR payments, and administrative operations.

Different  types of users require different permission within system.

Type roles include:

- **Admin** - manages the platform, users, and system configuration
- **Agent** - manages merchant operations and assists users
- **Merchant** - receives payments through QR codes
- **User** - performs payments, transfers, and manages their wallet

----

## Decision

---

Authorization in **QRbank** is implemented using **Role-Based Access Control** (RBAC).

The authorization model follows these principles:

- Each **account is assigned one or more roles**
- Roles define the **permissions** allowed in the system
- Access control is enforced at multiple levels:

    - **API endpoints**
    - **Service layer**
    - **Business rules for financial operations**

Exemple:

| Role     | permission |
|----------|------------|
| Admin    | Business rules for financial operations           |
| Agent    | Assist account operations           |
| Merchant | Receive payments via QR           |
| User     | Send/receive money, manage wallet           |

---
## Consequences

### Positive

- Clear and understandable permission structure
- Easy to implement using **Spring Security**
- Suitable for financial systems with defined user roles
- Reduces risk of unauthorized access to sensitive operations

### Negative

- Less flexible than **Attribute-Based Access Control** (ABAC)
- New permission requirements may require creating additional roles

---

## Decision Summary

**Role-Based Access Control** (RBAC) is used in the 
**QRbank platform** to manage authorization and enforce access restrictions across APIs and services.

This model ensures that **financial operations and 
administrative actions are restricted to authorized roles only**.