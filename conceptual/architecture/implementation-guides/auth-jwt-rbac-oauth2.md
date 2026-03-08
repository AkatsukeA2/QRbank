# QRbank Implementation Guide: Authentication and Authorization (JWT + RBAC + Google OAuth2)

**Status:** Proposed for implementation

Secure authentication and authorization system for **QRbank**, using
**JWT (JSON Web Tokens)**, **RBAC (Role‑Based Access Control)** and
**Google OAuth2 login**.

QRbank is a **digital wallet and QR payment platform**, therefore
authentication must guarantee:

-   secure user identity
-   controlled access to financial operations
-   role-based permissions for administrators, guardians, and users
-   compatibility with mobile clients (Flutter)

------------------------------------------------------------------------

# 1. Overview

QRbank supports **two authentication methods**:

### Traditional Login

    POST /api/v1/auth/login

User logs in using:

-   username **or**
-   email
-   password

Credentials are validated against the **Account** entity using
**BCrypt**.

After authentication:

1.  Roles are loaded from `AccountRole`
2.  A **JWT token** is generated
3.  Token is returned to the mobile client

------------------------------------------------------------------------

### Google Login (OAuth2)

Users may authenticate using their **Google account**.

Flow:

1.  User is redirected to Google
2.  Google authenticates the user
3.  Backend receives `code`
4.  Backend retrieves user information
5.  Account is created if necessary
6.  JWT token is generated for QRbank

------------------------------------------------------------------------

# 2. Authentication Flows

## 2.1 Traditional Login

### Step-by-step

1.  Client sends:

```{=html}
<!-- -->
```
    POST /api/v1/auth/login

Body:

``` json
{
  "usernameOrEmail": "user@email.com",
  "password": "password123"
}
```

2.  Backend:

-   resolves account using username OR email
-   verifies password using **BCrypt**
-   checks if account is active

3.  Backend loads roles using:

```{=html}
<!-- -->
```
    AccountRole → Role

4.  Backend generates JWT containing:

Claim   Description
  ------- ----------------------
sub     accountId
roles   list of roles
exp     expiration timestamp

Example roles in QRbank:

-   USER
-   GUARDIAN
-   ADMIN
-   SUPPORT

5.  Backend returns:

``` json
{
  "accessToken": "...",
  "tokenType": "Bearer",
  "expiresAt": "...",
  "accountId": 1,
  "roles": ["USER"]
}
```

------------------------------------------------------------------------

## 2.2 Google OAuth2 Login

### Step-by-step

1.  Client calls:

```{=html}
<!-- -->
```
    GET /api/v1/auth/google

Backend redirects to Google authorization endpoint.

Parameters include:

-   client_id
-   redirect_uri
-   scope: `openid email profile`

------------------------------------------------------------------------

2.  User authenticates with Google

Google redirects to:

    GET /api/v1/auth/google/callback?code=...

------------------------------------------------------------------------

3.  Backend exchanges `code` for an **access token** using Google Token
    API.

Request includes:

-   client_id
-   client_secret
-   redirect_uri
-   authorization code

------------------------------------------------------------------------

4.  Backend requests **Google User Info**.

Returned information:

-   email
-   name
-   profile picture

------------------------------------------------------------------------

5.  Backend searches for an account with that email.

### If account does NOT exist

Backend creates:

**Account** - email - username (derived from email) - random password or
null

**User profile** - firstName - lastName - photo

Default role assigned:

    USER

------------------------------------------------------------------------

### If account exists

Backend:

-   loads roles
-   ensures account is active

------------------------------------------------------------------------

6.  Backend generates **QRbank JWT token**.

Response may be:

-   JSON body
-   redirect to frontend with token
-   cookie (optional)

------------------------------------------------------------------------

# 3. Core Components

  -----------------------------------------------------------------------
Component                    Responsibility
  ---------------------------- ------------------------------------------
**JwtService**               Generate JWT tokens, validate tokens,
extract claims

**AuthController**           Authentication endpoints

**AuthService**              Credential validation and login
orchestration

**SecurityWebFilterChain**   Security configuration

**JWT Filter**               Reads Authorization header and validates
token

**RBAC Layer**               Role-based authorization
-----------------------------------------------------------------------

------------------------------------------------------------------------

# 4. Entities Involved

Authentication integrates with the **QRbank domain model**.

### Account

Represents login credentials.

Fields:

-   id
-   username
-   email
-   passwordHash
-   emailVerified
-   active
-   lastLogin

------------------------------------------------------------------------

### User

Represents the **user profile** linked to the wallet.

Fields:

-   accountId
-   firstName
-   lastName
-   photo

In QRbank, this user may own:

-   wallets
-   QR codes
-   transactions

------------------------------------------------------------------------

### Guardian

If the user is a **minor**, the account is linked to a guardian.

Relationship:

    Guardian 1 → N Users

Guardians may approve or monitor transactions.

------------------------------------------------------------------------

### Role

Defines permissions.

Examples:

-   USER
-   GUARDIAN
-   ADMIN
-   SUPPORT

------------------------------------------------------------------------

### AccountRole

Many-to-many relationship.

    Account N ↔ N Role

Used to populate **JWT role claims**.

------------------------------------------------------------------------

# 5. Security Configuration

Configuration variables stored in:

    application.properties

Example:

    jwt.secret=your-secret-key
    jwt.expiration-ms=86400000

------------------------------------------------------------------------

### Google OAuth Configuration

    google.client-id=xxxxx
    google.client-secret=xxxxx
    app.auth.google.redirect-uri=http://localhost:8080/api/v1/auth/google/callback

Credentials are created in:

**Google Cloud Console → OAuth 2.0 Client**

Type:

    Web Application

------------------------------------------------------------------------

# 6. Public vs Private Routes

### Public Routes

These endpoints do NOT require JWT.

    POST /api/v1/auth/login
    GET /api/v1/auth/google
    GET /api/v1/auth/google/callback

Optional public endpoints:

-   health check
-   actuator
-   API documentation

------------------------------------------------------------------------

### Private Routes

All other endpoints require authentication.

Example:

    /api/v1/wallets/**
    /api/v1/transactions/**
    /api/v1/qrcodes/**

Requests must include:

    Authorization: Bearer <token>

------------------------------------------------------------------------

# 7. Authorization (RBAC)

Role-Based Access Control protects critical operations.

Example rules:

Role       Permission
  ---------- --------------------------
USER       Basic wallet operations
GUARDIAN   Monitor minor accounts
ADMIN      Manage system
SUPPORT    Investigate transactions

Example annotation:

    @PreAuthorize("hasRole('ADMIN')")

Example endpoint:

    DELETE /api/v1/users/{id}

Accessible only to **ADMIN**.

------------------------------------------------------------------------

# 8. Error Handling

Authentication errors must return **standard HTTP responses**.

### 401 Unauthorized

Returned when:

-   token missing
-   token invalid
-   token expired

Example:

``` json
{
  "title": "Unauthorized",
  "status": 401,
  "detail": "Invalid or expired authentication token"
}
```

------------------------------------------------------------------------

### 403 Forbidden

Returned when:

-   user authenticated
-   role insufficient

Example:

``` json
{
  "title": "Forbidden",
  "status": 403,
  "detail": "Insufficient permissions"
}
```

------------------------------------------------------------------------

# 9. Testing

Authentication system must be tested thoroughly.

### Unit Tests

Components:

-   JwtService
-   AuthService

Test cases:

-   token generation
-   token validation
-   password verification

------------------------------------------------------------------------

### Integration Tests

Scenarios:

-   traditional login success
-   login with wrong password
-   login with inactive account
-   Google OAuth callback
-   access protected endpoint with valid token
-   access protected endpoint without token

------------------------------------------------------------------------

### Security Scenarios

Scenario            Expected Result
  ------------------- -----------------
Expired token       401
Invalid token       401
Missing token       401
Insufficient role   403

------------------------------------------------------------------------

# 10. Security Considerations for QRbank

Because QRbank manages **financial transactions**, additional measures
are recommended:

-   Short JWT expiration
-   Refresh tokens (future implementation)
-   Rate limiting for login endpoints
-   Account lock after multiple failed attempts
-   Logging of authentication events

------------------------------------------------------------------------

# Conclusion

This authentication system provides **secure, scalable identity
management for QRbank**, enabling:

-   traditional authentication
-   social login via Google
-   role-based access control
-   secure API access using JWT

By combining **JWT + RBAC + OAuth2**, QRbank ensures a modern
authentication architecture suitable for **digital wallets and fintech
platforms**.