# Full Implementation Guide

**KYC OCR Pipeline with PaddleOCR-VL**

**Project**: QRbank Digital Wallet
**Status**: Proposed for Review and Acceptance via ADR

This document defines the architecture and implementation of the **OCR microservice used in the QRbank KYC pipeline**,
responsible for extracting structured identity information 
from images of official documents (such as the **Angolan Bilhete de Identidade – BI**).

The service operates as an isolated stateless microservice,
transforming document images into structured JSON that mirrors the main
attributes of the `User`, `Guardian`, and `IdentityDocument`
entities defined in the QRbank ERM model.

The JSON structure contains **raw extracted values with confidence
scores**, without enforcing business validation.
All domain validation (duplicate users, document authenticity,
age verification, guardian relationship, etc.)
is performed exclusively by the **QRbank Backend API**.

The OCR service **never**:

- accesses the database

- persists data

- applies KYC rules

- performs identity validation

It functions strictly as an:

**Document Image → Structured JSON Transformer**

---

## 0 System Flow (QRbank KYC)

Mobile App (Flutter)

↓ multipart/form-data (BI images front/back + selfie)

Backend API (Spring Boot WebFlux)
POST /api/kyc/scan-document

↓ HTTP POST (Reactive WebClient + Resilience4j)

OCR Service (Python FastAPI + PaddleOCR-VL)
POST /ocr/v1/extract-identity

↓ structured JSON

Backend API (KYCService)

↓ validation + age verification

↓ determine if guardian required (<18)

↓ build User + IdentityDocument + Guardian (if needed)

↓ persistence (MySQL / R2DBC)

↓ asynchronous event
UserKYCSubmittedEvent → Kafka topic "kyc.submitted"

Compliance / AI Service
↓ fraud detection
↓ identity verification

---

## 1. Goals and Architectural Principles

### Separation of Responsibilities



| Component        | Responsibilities               |
|------------------|--------------------------------|
| OCR Server       | Separation of Responsibilities |
| Backend API      | Validate, map and persist      |
| KYC Server       | Apply compliance rules         |
| AI/ Fraud Server | Risk analysis                  |

---

### Key Architectural Principles

#### Stateless OCR Service

No session or storage.

#### Clear Data Contract

JSON Schema located in:

``libs/contracts/kyc-ocr-response.json``

### High Scalability

Supports large volumes of KYC verification requests.

#### Observability

Integrated with:

- Prometheus

- Jaeger tracing

- Structured logging

### Idempotency

Image hashing prevents duplicate processing.

---

## 2. OCR Microservice Internal Architecture

The service is built using:

- FastAPI (Python 3.11+)

- PaddleOCR-VL

- OpenCV

- NumPy

Purpose: Extract identity data from BI images and other KYC documents.

---

### Architecture Layers
#### API Layer

`app/api/endpoints.py`

Endpoint:

`POST /ocr/extract-identity`

Responsibilities:

- Accept multipart images

- Validate JWT token

- Forward request to OCR engine
---
### OCR Engine

`app/ocr/engine.py`

Responsibilities:

- Load OCR models at startup

- Run inference on document images

- Execute layout analysis

Processing includes:

- image deskew

- noise reduction

- binarization

- document segmentation

PaddleOCR performs:

- text detection

- text recognition

- layout analysis

---

### Post-Processing

`app/ocr/postprocessing.py`

Extracts identity attributes such as:

- Full name

- Date of birth

- BI number

- Nationality

- Sex

- Expiration date

- Place of issue

Also reconstructs the document structure.

---

## 3. HTTP Contract
  ## Endpoint
   
`POST /ocr/extract-identity`

## Headers

`Authorization: Bearer <JWT>`

## Fields:

| field      | Description |
|------------|-------------|
| `images[]` |Document images (BI front/back)             |
| `selfie`   |Optional selfie for face verification             |
| `context`   |Optional JSON metadata             |

Example context:

```
{
"country": "AO",
"documentType": "BI",
"languageHint": "pt"
}
```

---

## 4. JSON Response Structure

Defined in:

`libs/contracts/kyc-ocr-response.json`

---

### General Structure

```
{
  "status": "success | partial | error",
  "requestId": "string",
  "processingTimeMs": number,
  "overallConfidence": number,
  "document": {
    "documentType": "BI",
    "country": "AO",
    "pageCount": number
  },
  "identity": {},
  "guardianCandidate": {},
  "warnings": []
}
```

---

## 5. Example Response (Angolan BI)

```
{
  "status": "success",
  "requestId": "kyc-req-2026-001",
  "processingTimeMs": 3421,
  "overallConfidence": 0.91,
  "document": {
    "documentType": "BI",
    "country": "AO",
    "pageCount": 2
  },
  "identity": {
    "fullName": {
      "value": "Carlos Manuel Gomes",
      "confidence": 0.97
    },
    "biNumber": {
      "value": "005874321LA042",
      "confidence": 0.95
    },
    "dateOfBirth": {
      "value": "2008-03-14",
      "confidence": 0.94
    },
    "sex": {
      "value": "M",
      "confidence": 0.96
    },
    "nationality": {
      "value": "Angolan",
      "confidence": 0.93
    },
    "expirationDate": {
      "value": "2030-08-20",
      "confidence": 0.92
    }
  },
  "warnings": []
}
```

---

## 6. Backend Mapping (Spring Boot WebFlux)

In the **KYCService**.

## Step 1 — Receive OCR Result

Using **WebClient**.

### Step 2 — Validate Confidence

Example threshold:

`0.80`

Fields below this value require manual review.

---

### Step 3 — Determine User Age

```
int age = Period.between(dob, LocalDate.now()).getYears();

if(age < 18){
   requireGuardian = true;
}
```
---

### Step 4 — Create Entities

#### IdentityDocument

```
IdentityDocument doc = new IdentityDocument();
doc.setDocumentNumber(identity.biNumber.value);
doc.setType("BI");
doc.setExpirationDate(identity.expirationDate.value);
```

---

#### User

```
User user = new User();
user.setFullName(identity.fullName.value);
user.setDateOfBirth(identity.dateOfBirth.value);
user.setNationality(identity.nationality.value);
user.setSex(identity.sex.value);
```

---

### Step 5 — Guardian Flow (Minor Users)

If user age < 18:

**1.** App requests **guardian BI scan**

**2.** OCR runs again

**3.** Guardian entity created

```
Guardian guardian = new Guardian();
guardian.setFullName(guardianIdentity.fullName.value);

user.setGuardian(guardian);
```

---

### Step 6 — Persistence

Stored in MySQL:

Tables involved:

- `users`

- `identity_documents`

- `guardians`

- `kyc_requests`

---

### Step 7 — Event Publishing

```UserKYCSubmittedEvent```

Kafka Topic:

```kyc.submitted```

Consumers:

- Fraud detection

- Compliance verification

- Notification service
---

## 7. Scalability Strategy
   
### Model Warm Loading

Load PaddleOCR at startup to reduce latency.

---

### GPU Nodes

OCR services deployed on ***GPU-enabled containers**.

---

### Task Queue

Optional queue:

`Celery + Redis`

Used when traffic spikes.

---

### Cache

Redis caching:

`key = sha256(image)`

Prevents reprocessing the same document.

---

## 8. Observability

Metrics exposed:

- OCR latency

- success rate

- confidence averages

- failure rate

Stack:

- Prometheus

- Grafana

- Jaeger tracing
---