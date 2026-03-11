# ADR-006 — Identity Document Handling for User and Guardian (KYC)

**Status:** Proposed  
**Date:** 2026-03-11  
**Project:** QRbank Digital Wallet

---

# Context

The QRbank system supports digital wallets for both **adults and minors**.  
Due to financial compliance requirements, the system must implement **KYC (Know Your Customer)** verification.

In Angola, identity verification is normally performed using the **Bilhete de Identidade (BI)**. Therefore, the system must support:

- Identity verification of **adult users**
- Identity verification of **minor users**
- Identity verification of the **legal guardian responsible for minors**

Additionally, the system will implement an **OCR pipeline (PaddleOCR)** to extract structured information from identity document images.

This raises an architectural design question:

**Where should BI information be stored in the data model?**

Possible approaches considered:

1. Store BI fields directly in the `users` table
2. Store BI fields directly in the `guardians` table
3. Create a dedicated entity for identity documents

---

# Decision

The system **will not store BI information directly in the `users` or `guardians` tables**.

Instead, a dedicated entity will be introduced:

`IdentityDocument`

This entity will store all identity verification documents associated with either a **User** or a **Guardian**.

Structure:

## IdentityDocument

id </br>
documentNumber</br>
documentType</br>
frontImagePath</br>
backImagePath</br>
ownerType (USER | GUARDIAN)</br>
ownerId</br>
verified</br>
createdAt</br>


The document will be associated with either a **User** or a **Guardian** through the `ownerType` and `ownerId` fields.

---

# Business Rules

The system must follow the KYC rules below.

## Adult User

If the user is **18 years or older**:

- The user must provide their **own BI**
- A guardian is **not required**

## Minor User

If the user is **under 18**:

- The user may provide their **own BI if available**
- A **Guardian is mandatory**
- The **Guardian must provide their BI**

---

# Resulting Domain Model

User</br>
├── Role</br>
├── Wallet</br>
├── Account</br>
├── Guardian (only if minor)</br>
└── IdentityDocument</br>

Guardian</br>
└── IdentityDocument


---

# Benefits

This design provides several advantages.

## 1. KYC extensibility

The system will support multiple document types in the future:

- National ID (BI)
- Passport
- Driver's license

## 2. OCR pipeline compatibility

Document images can be processed by the OCR service to extract structured data such as:

- Name
- Document number
- Birth date
- Expiration date

## 3. Reduced schema duplication

Instead of duplicating document fields in both `User` and `Guardian`, the document data is centralized.

## 4. Future compliance flexibility

Financial systems often require storing multiple identity documents over time.  
This design allows multiple documents per entity if required.

---

# Consequences

## Positive

- Clean separation between **identity verification** and **core user data**
- Flexible support for additional document types
- Compatible with the OCR microservice architecture
- Avoids schema duplication

## Negative

- Requires an additional table
- Queries involving identity verification require joins

---

# Implementation Notes

The OCR pipeline will follow this process:

1. User uploads identity document images
2. Images are sent to the **OCR microservice**
3. OCR extracts structured information
4. Extracted data is stored with the document
5. Verification status is updated

Example flow:

Upload BI Image</br>
↓</br>
OCR Processing (PaddleOCR)</br>
↓</br>
Extracted Data</br>
↓</br>
IdentityDocument Record</br>
↓</br>
KYC Verification</br>


---

# Summary

To properly support **KYC verification for both users and guardians**, QRbank introduces a dedicated **IdentityDocument entity**.

This approach improves:

- data normalization
- extensibility
- OCR integration
- compliance readiness

The **User** and **Guardian** entities remain focused on identity relationships, while document management is handled by a specialized component.