# QRbank QR Payment Flow

This document explains how QR payments work in QRbank.

------------------------------------------------------------------------

# 1. Payment Creation

Merchant or user generates a QR code.

Request:

POST /api/v1/qrcodes/generate

Data:

walletId\
amount

Backend:

-   creates QR code record
-   generates unique token
-   returns QR image or payload

------------------------------------------------------------------------

# 2. QR Scan

User opens mobile app and scans QR.

App sends:

POST /api/v1/payments/scan

Data:

qrToken\
walletId

------------------------------------------------------------------------

# 3. Validation

Backend performs checks:

-   QR code exists
-   QR code not expired
-   wallet balance sufficient
-   user authenticated

------------------------------------------------------------------------

# 4. Transaction Execution

Backend creates transaction.

Steps:

1.  debit payer wallet
2.  credit receiver wallet
3.  create ledger entries

------------------------------------------------------------------------

# 5. Confirmation

Response returned:

payment status\
transaction id\
updated balance

------------------------------------------------------------------------

# 6. Security Checks

The payment flow includes:

JWT authentication\
wallet ownership validation\
transaction logging\
fraud detection

------------------------------------------------------------------------

# 7. Result

User receives confirmation in mobile app.

Transaction is stored for:

-   history
-   financial auditing
-   analytics