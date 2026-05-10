CREATE TABLE outbox_event (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    aggregate_id BIGINT,
    type VARCHAR(100),
    payload JSON,
    status VARCHAR(20),
    created_at TIMESTAMP
);
