-- Миграция V1.1: Создание индексов для оптимизации производительности запросов

-- Индексы для таблицы clients
CREATE INDEX idx_clients_inn ON clients(inn);
CREATE INDEX idx_clients_type ON clients(client_type);
CREATE INDEX idx_clients_email ON clients(email);

-- Индексы для таблицы equipment
CREATE INDEX idx_equipment_category ON equipment(category_id);
CREATE INDEX idx_equipment_status ON equipment(status);
CREATE INDEX idx_equipment_serial ON equipment(serial_number);
CREATE INDEX idx_equipment_type ON equipment(equipment_type);
CREATE INDEX idx_equipment_energy_class ON equipment(energy_class);

-- Индексы для таблицы contracts
CREATE INDEX idx_contracts_client ON contracts(client_id);
CREATE INDEX idx_contracts_equipment ON contracts(equipment_id);
CREATE INDEX idx_contracts_status ON contracts(status);
CREATE INDEX idx_contracts_number ON contracts(contract_number);
CREATE INDEX idx_contracts_dates ON contracts(start_date, end_date);
CREATE INDEX idx_contract_insurance_expiry ON contracts(insurance_expiry_date);
CREATE INDEX idx_contract_insurance_policy ON contracts(insurance_policy_number);

-- Индексы для таблицы payment_schedules
CREATE INDEX idx_payment_schedules_contract ON payment_schedules(contract_id);
CREATE INDEX idx_payment_schedules_status ON payment_schedules(status);
CREATE INDEX idx_payment_schedules_date ON payment_schedules(payment_date);

-- Индексы для таблицы payments
CREATE INDEX idx_payments_schedule ON payments(schedule_id);
CREATE INDEX idx_payments_contract ON payments(contract_id);
CREATE INDEX idx_payments_status ON payments(status);
CREATE INDEX idx_payments_paid_date ON payments(paid_date);

-- Индексы для таблицы client_scoring
CREATE INDEX idx_client_scoring_client_id ON client_scoring(client_id);
CREATE INDEX idx_client_scoring_status ON client_scoring(status);
CREATE INDEX idx_client_scoring_date ON client_scoring(checked_date);

-- Индексы для таблицы equipment_incidents
CREATE INDEX idx_incident_equipment ON equipment_incidents(equipment_id);
CREATE INDEX idx_incident_contract ON equipment_incidents(contract_id);
CREATE INDEX idx_incident_status ON equipment_incidents(status);
CREATE INDEX idx_incident_type ON equipment_incidents(incident_type);
CREATE INDEX idx_incident_date ON equipment_incidents(incident_date);
CREATE INDEX idx_incident_responsible ON equipment_incidents(responsible_party);

-- Индексы для таблицы audit_log
CREATE INDEX idx_audit_log_user_id ON audit_log(user_id);
CREATE INDEX idx_audit_log_action ON audit_log(action);
CREATE INDEX idx_audit_log_entity ON audit_log(entity_type, entity_id);
CREATE INDEX idx_audit_log_timestamp ON audit_log(timestamp DESC);
