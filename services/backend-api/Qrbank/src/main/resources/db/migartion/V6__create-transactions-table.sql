CREATE TABLE transactions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    sender_account_id BIGINT NULL,
    receiver_account_id BIGINT NULL,
    amount DECIMAL(15,2) NOT NULL,
    type ENUM('TRANSFER','DEPOSIT','WITHDRAW') NOT NULL,
    status ENUM('PENDING','COMPLETED','FAILED') NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    deleted_at DATETIME DEFAULT NULL,

    CONSTRAINT fk_sender_account_id
        FOREIGN KEY (sender_account_id)
        REFERENCES accounts(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_receiver_account_id
        FOREIGN KEY (receiver_account_id)
        REFERENCES accounts(id)
        ON DELETE RESTRICT
);