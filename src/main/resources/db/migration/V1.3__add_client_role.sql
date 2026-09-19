ALTER TABLE users ADD COLUMN client_id BIGINT;
ALTER TABLE users ADD CONSTRAINT fk_user_client FOREIGN KEY (client_id) REFERENCES clients(id);
ALTER TABLE users ADD CONSTRAINT uq_user_client UNIQUE (client_id);