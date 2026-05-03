CREATE TABLE ledgers(

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    account_id BIGINT UNSIGNED NOT NULL,
    transaction_id BIGINT UNSIGNED NOT NULL,
    type ENUM('DEBIT','CREDIT') NOT NULL,
    amount DECIMAL(14,9) NOT NULL,
    balance_after DECIMAL(14,9) NOT NULL,
    description VARCHAR(200),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_amount_positive CHECK (amount > 0),

    INDEX idx_wallet_created (account_id, created_at DESC),
    INDEX idx_transaction_id (transaction_id)
) ENGINE=InnoDB;