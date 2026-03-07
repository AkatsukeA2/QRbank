classDiagram
%% ENTIDADES PRINCIPAIS QRbank

    class User {
        +Long id
        +Long accountId
        +String firstName
        +String lastName
        +String email
        +String password
        +LocalDate birthDate
        +Role role
        +Guardian guardian
        +Wallet wallet
        +Date createdAt
        +Date updatedAt
        +Date deletedAt
    }

    class Role {
        +Long id
        +String name
    }

    class Guardian {
        +Long id
        +String name
        +String email
        +String phone
        +List<User> users
        +Date createdAt
        +Date updatedAt
        +Date deletedAt
    }

    class Wallet {
        +Long id
        +String grade
        +Double balance
        +User user
        +Date createdAt
        +Date updatedAt
        +Date deletedAt
    }

    class Transaction {
        +Long id
        +String type
        +String status
        +Payment payment
        +Date createdAt
        +Date updatedAt
        +Date deletedAt
    }

    class Payment {
        +Long id
        +Double amount
        +String status
        +QRCode qrcode
        +Date createdAt
        +Date updatedAt
        +Date deletedAt
    }

    class QRCode {
        +Long id
        +Double amount
        +String name
        +Wallet wallet
        +Date createdAt
        +Date updatedAt
        +Date deletedAt
    }

    class LedgerEntry {
        +Long id
        +Double amount
        +String entryType
        +Date createdAt
        +Date updatedAt
        +Date deletedAt
        +Wallet wallet
        +Transaction transaction
    }

    class KYCVerification {
        +Long id
        +String documentType
        +String documentNumber
        +String status
        +Date verifiedAt
        +Date deletedAt
        +User user
    }

    class Device {
        +Long id
        +String deviceInfo
        +Date lastAccess
        +User user
        +Date createdAt
        +Date updatedAt
        +Date deletedAt
    }

    %% RELACIONAMENTOS

    User "1" -- "1" Role : has
    User "0..1" -- "1" Wallet : owns
    User "0..1" -- "0..1" Guardian : protectedBy
    User "0..*" -- "0..*" Device : uses
    User "0..*" -- "0..*" KYCVerification : verifiedBy

    Wallet "1" -- "0..*" LedgerEntry : contains
    Wallet "0..*" -- "0..*" QRCode : linkedTo

    Transaction "1" -- "1" Payment : processes
    Transaction "0..*" -- "0..*" LedgerEntry : generates

    QRCode "0..1" -- "1" Payment : usedIn

    Guardian "1" -- "0..*" User : guardianOf