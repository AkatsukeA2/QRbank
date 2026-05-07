CREATE TABLE kyc(

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    account_id BIGINT NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    document_type VARCHAR(100) NOT NULL,
    document_number VARCHAR(100) NOT NULL,
    birth_date DATE NOT NULL,
    nationality VARCHAR(50),
    document_front_url Text,
    document_back_url Text,
    status ENUM('PENDING','SUBMITTED','VERIFIED','REJECTED') NOT NULL,
    rejection_reason Text,
    submitted_at DATETIME,
    verified_at DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_kyc_account FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE
);