# ERM

---

**user** (id, name, role_id, password, email, birth_date, guardian_id, created_at, updatedAt, deletedAt); </br>
**role** (id, name); ex: ADMIN, MERCHANT, USER </br>
**wallet** (id, user_id, balance, created_at, updated_at, deleted_at); </br>
**transaction** (id, type, status, created_at); </br>
**ledgerEntry** (id, transaction_id, wallet_id,entry_type, amount, created_at); </br>
**qr_code** (id, wallet_id, code, amount, expires_at); </br>
**kyc_verification** (id, user_id,  document_type, document_number, document_image_front, document_image_back, status, verified_at); </br>
**guardian** (id, name, email, phone, created_at); </br>
**payment** (id, qr_code_id, payer_wallet_id, receiver_wallet_id, amount, status, created_at); </br>

---


