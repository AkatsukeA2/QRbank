# Reactive CRUD Implementation Guide for QRbank

This guide defines the **standard architecture and development pattern**
for implementing reactive CRUD operations in the **QRbank backend**,
located at:

    services/backend-api

The architecture follows **Spring WebFlux + Reactive Programming +
R2DBC**, ensuring **scalability, non-blocking operations, and high
performance**, which are essential for **digital payment systems**.

To implement a new CRUD, replace **\[EntityName\]** with the desired
entity name and follow the same structure used in existing modules.

Examples of entities in **QRbank** include:

-   User
-   Guardian
-   Wallet
-   Transaction
-   QRCode
-   LedgerEntry
-   KYCVerification
-   PaymentRequest
-   Notification

------------------------------------------------------------------------

# System Architecture Overview

In QRbank, CRUD operations support critical financial features such as:

-   User and guardian registration
-   Digital wallet management
-   QR code payment transactions
-   Financial history (ledger)
-   KYC identity verification
-   Allowance transfers from parents to minors
-   Transaction monitoring and analytics

The backend is organized into layers:

    Controller → Service → Repository → Database
                    ↑
                   DTO

Each layer has a clear responsibility to maintain **clean architecture
and maintainability**.

------------------------------------------------------------------------

# File Structure and Purpose

## 1. Controller Layer

**Path**

    src/main/java/ao/creativemode/qrbank/controller/[EntityName]Controller.java

**Purpose**

Defines the **REST API endpoints** used by the **mobile application
(Flutter)** and other clients.

Examples in QRbank:

-   Create wallet
-   Generate QR payment
-   Transfer money
-   View transaction history
-   Register user

**Responsibilities**

-   Receive HTTP requests
-   Validate request data
-   Call service methods
-   Return standardized responses

**Best Practices**

Use:

``` java
@RestController
@RequestMapping("/api/[entity]")
```

Use reactive types:

    Mono<ResponseEntity<T>>
    Flux<T>

Validate input using:

``` java
@Valid
```

Example endpoints in QRbank:

    POST /api/users
    GET /api/wallets/{id}
    POST /api/transactions
    GET /api/transactions/history
    POST /api/qrcodes/generate

------------------------------------------------------------------------

# 2. Service Layer

**Path**

    src/main/java/ao/creativemode/qrbank/service/[EntityName]Service.java

**Purpose**

Contains the **business logic of QRbank**.

Examples of business logic:

-   Verify if user passed **KYC verification**
-   Check wallet balance before payment
-   Generate QR payment tokens
-   Record transaction ledger entries
-   Apply transaction limits for minors

**Integration**

-   Uses **Repository**
-   Converts **DTO ↔ Entity**
-   Orchestrates operations across multiple repositories

**Best Practices**

Annotate with:

``` java
@Service
```

Use reactive return types:

    Mono<T>
    Flux<T>

Example service methods:

    createWallet()
    transferMoney()
    generateQRCode()
    verifyKYC()
    getTransactionHistory()

------------------------------------------------------------------------

# 3. Repository Layer

**Path**

    src/main/java/ao/creativemode/qrbank/repository/[EntityName]Repository.java

**Purpose**

Handles **database access** using **Spring Data R2DBC**.

Repositories provide reactive database operations.

Example repositories in QRbank:

-   UserRepository
-   WalletRepository
-   TransactionRepository
-   QRCodeRepository
-   KYCRepository

**Best Practices**

Extend:

``` java
ReactiveCrudRepository<Entity, ID>
```

Example:

``` java
public interface WalletRepository
extends ReactiveCrudRepository<Wallet, Long>
```

Add custom queries when necessary:

    findByUserId()
    findAllByDeletedFalse()
    findByWalletIdAndStatus()

------------------------------------------------------------------------

# 4. Model (Entity)

**Path**

    src/main/java/ao/creativemode/qrbank/model/[EntityName].java

**Purpose**

Represents **database tables**.

Example entities in QRbank:

-   User
-   Guardian
-   Wallet
-   Transaction
-   QRCode
-   LedgerEntry
-   KYCVerification

**Best Practices**

Use Spring Data annotations:

``` java
@Table("wallets")
@Id
@Column
```

Include helper methods for:

-   soft delete
-   restore

Example:

    markDeleted()
    restore()

------------------------------------------------------------------------

# 5. DTO Layer

**Path**

    src/main/java/ao/creativemode/qrbank/dto/[entityName]/

**Purpose**

DTOs define **API contracts** and ensure entities are **not exposed
directly**.

Examples in QRbank:

    CreateUserRequest
    UserResponse

    CreateWalletRequest
    WalletResponse

    CreateTransactionRequest
    TransactionResponse

**Best Practices**

Use immutable records:

``` java
public record CreateWalletRequest(
    Long userId,
    String currency
) {}
```

Add validations:

``` java
@NotNull
@Positive
@Email
```

------------------------------------------------------------------------

# 6. Database Migration

**Path**

    src/main/resources/db/migration/Vx__create_[table_name]_table.sql

**Purpose**

Creates database tables automatically during startup using **Flyway
migrations**.

Example tables in QRbank:

    users
    guardians
    wallets
    transactions
    qr_codes
    ledger_entries
    kyc_verifications

Example migration:

``` sql
CREATE TABLE wallets (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    balance DECIMAL(15,2),
    currency VARCHAR(10),
    created_at TIMESTAMP
);
```

**Best Practices**

Add:

-   indexes
-   foreign keys
-   constraints

------------------------------------------------------------------------

# 7. Configuration

**Path**

    src/main/resources/application.properties

**Purpose**

Defines application settings.

Example configuration:

    spring.r2dbc.url=r2dbc:mysql://localhost:3306/qrbank
    spring.r2dbc.username=root
    spring.r2dbc.password=******

Never commit real credentials.

Use:

    application-example.properties

------------------------------------------------------------------------

# 8. Exceptions and Global Handler

**Path**

    src/main/java/ao/creativemode/qrbank/common/exception/

**Purpose**

Centralized error handling.

Example errors in QRbank:

-   WalletNotFoundException
-   InsufficientBalanceException
-   UserNotVerifiedException
-   QRCodeExpiredException

Example response format:

``` json
{
  "type": "wallet-not-found",
  "title": "Wallet not found",
  "status": 404,
  "detail": "The requested wallet does not exist"
}
```

------------------------------------------------------------------------

# CRUD Operation Flow in QRbank

## Create

Example: Create Wallet

**Controller**

    POST /api/wallets

**Service**

-   Validate user exists
-   Create wallet
-   Save via repository

------------------------------------------------------------------------

## Read

Example: Transaction History

    GET /api/transactions/user/{userId}

Returns:

    Flux<TransactionResponse>

------------------------------------------------------------------------

## Update

Examples:

-   Update user profile
-   Update KYC status

Flow:

    Controller → Service → Repository → Database

------------------------------------------------------------------------

## Soft Delete

Used when entities should remain in history but be disabled.

Examples:

-   deactivate wallet
-   archive QR codes

------------------------------------------------------------------------

## Restore

Allows recovery of soft deleted entities.

------------------------------------------------------------------------

## Hard Delete

Used only when data must be permanently removed.

Examples:

-   remove test data
-   cleanup expired tokens

------------------------------------------------------------------------

# General Best Practices for QRbank

1.  Always use **Reactive Programming**

```{=html}
<!-- -->
```
    Mono
    Flux

2.  Never call:

```{=html}
<!-- -->
```
    .block()
    .subscribe()

in production code.

3.  Separate layers:

```{=html}
<!-- -->
```
    controller
    service
    repository
    dto
    model

4.  Always validate inputs.

5.  Never expose **entities directly** in APIs.

6.  Implement **soft delete** where necessary.

7.  Centralize DTO conversions.

8.  Keep business logic in **services**, not controllers.

9.  Document endpoints.

------------------------------------------------------------------------

# Special Notes for QRbank

## KYC Integration

When users register:

1.  Upload ID document
2.  AI module verifies identity
3.  KYC status stored in:

```{=html}
<!-- -->
```
    kyc_verifications

------------------------------------------------------------------------

## Minor Users and Guardians

If the user is a **minor**:

-   must be linked to a **guardian**
-   guardian authorizes transactions

Relationship example:

    Guardian 1 —— N Users

------------------------------------------------------------------------

## QR Code Payments

Typical payment flow:

    User scans QR
    → backend validates QR
    → wallet balance checked
    → transaction executed
    → ledger entry created
    → confirmation returned

------------------------------------------------------------------------

# Entities in QRbank

Main entities include:

-   User
-   Guardian
-   Wallet
-   Transaction
-   QRCode
-   LedgerEntry
-   KYCVerification
-   PaymentRequest
-   Notification

------------------------------------------------------------------------

# Conclusion

This guide defines the **standard architecture for all backend CRUD
modules in QRbank**.

By following these conventions, the system ensures:

-   scalability
-   maintainability
-   security for financial operations
-   clean separation of concerns
-   reactive performance

All new features should respect this architecture to maintain
**consistency across the platform**.