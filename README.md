# QRbank

---
QRBank is a modern digital wallet application built with Flutter, it was developed as a collaborative academic project. The app enables users to manage virtual funds, view transaction history, simulate transfers, and explore core concepts of digital financial systems in a secure and scalable architecture.

---

##  Project Overview

QRBank aims to provide a **hands-on academic project** experience:

- Manage virtual balances
-  Simulate peer-to-peer transactions
-  Track transaction history
-  User authentication
-  QR code payment simulation

This project introduces students to **digital finance concepts**, **mobile app development**, and **team-based Git workflow**.

---

##  Technologies

- **Frontend:** Flutter & Dart
- **Backend:** Spring Boot & java
- **Version control:** Git & GitHub
- **Collaboration:** Branch strategy, pull requests, code review

---
## Services

Each service has its own repository and README:

- `services/backend-api` – Main Spring Boot backend
- `services/ocr-service` – PaddleOCR-VL service for text extraction


##  Team Members

| Role                  | Name / GitHub |
|----------------------|-----------|
| Tech Lead             | Obed Jorge/ Obedjorge22 |
| Frontend Developer    | Francisco Neto / talentoso04 |
| Backend Developer     | Obed Jorge / Obedjorge22 |
| Documentation         | Chongolola|



---

##  Branch Strategy

- `main` → Stable production-ready version
- `dev` → Integration branch for features
- `feature/*` → Branches for individual features

> **Rule:** Never push directly to `main`. Always create a branch, make a pull request, and merge after review.

---

##  How to Run

1. Clone the repository:
```bash
git clone https://github.com/AkatsukeA2/QRbank.git
cd QRBank
```

2. **Backend Setup:**
   - Navigate to `services/backend-api`.
   - Ensure you have JDK 17+ and Maven installed.
   - Run `./mvnw spring-boot:run`.

3. **Frontend Setup:**
   - Ensure Flutter SDK is installed.
   - Run `flutter pub get` to install dependencies.
   - Run `flutter run` with a connected emulator or device.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.