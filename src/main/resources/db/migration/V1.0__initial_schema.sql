-- Миграция V1.0: Создание базовой структуры таблиц системы LeaseManager

-- Таблица пользователей системы
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'MANAGER',
    full_name VARCHAR(255),
    email VARCHAR(100),
    active BOOLEAN NOT NULL DEFAULT TRUE
);

COMMENT ON TABLE users IS 'Учётные записи сотрудников лизинговой компании';
COMMENT ON COLUMN users.role IS 'Роль пользователя: ADMIN, MANAGER';

-- Таблица категорий оборудования
CREATE TABLE categories (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(1000)
);

COMMENT ON TABLE categories IS 'Классификация типов торгового оборудования';

-- Таблица клиентов
CREATE TABLE clients (
    id BIGSERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    email VARCHAR(100),
    company_name VARCHAR(255),
    inn VARCHAR(20),
    kpp VARCHAR(20),
    legal_address VARCHAR(500),
    bank_account VARCHAR(20),
    bik VARCHAR(9),
    bank_name VARCHAR(255),
    client_type VARCHAR(20) NOT NULL,
    created_date TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_date TIMESTAMP
);

COMMENT ON TABLE clients IS 'Сведения о лизингополучателях';
COMMENT ON COLUMN clients.client_type IS 'Тип клиента: INDIVIDUAL (физическое лицо), LEGAL_ENTITY (юридическое лицо)';

-- Таблица оборудования
CREATE TABLE equipment (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category_id BIGINT NOT NULL,
    price DECIMAL(15, 2) NOT NULL,
    model VARCHAR(100),
    manufacturer VARCHAR(100),
    serial_number VARCHAR(100),
    year_of_manufacture INTEGER,
    status VARCHAR(20) NOT NULL DEFAULT 'AVAILABLE',
    description VARCHAR(1000),
    equipment_type VARCHAR(50),
    dimensions VARCHAR(50),
    weight DECIMAL(8, 2),
    power_consumption DECIMAL(8, 3),
    voltage INTEGER,
    min_temperature INTEGER,
    max_temperature INTEGER,
    volume DECIMAL(8, 2),
    body_material VARCHAR(100),
    installation_address VARCHAR(500),
    installation_date DATE,
    next_maintenance_date DATE,
    last_maintenance_date DATE,
    warranty_months INTEGER,
    service_contract_number VARCHAR(50),
    energy_class VARCHAR(10),
    country_of_origin VARCHAR(100),
    maintenance_notes VARCHAR(1000),
    CONSTRAINT fk_equipment_category FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT
);

COMMENT ON TABLE equipment IS 'Реестр единиц торгового оборудования';
COMMENT ON COLUMN equipment.status IS 'Статус: AVAILABLE (доступно), LEASED (в лизинге), MAINTENANCE (на обслуживании), SOLD (продано), WRITE_OFF (списано)';
COMMENT ON COLUMN equipment.equipment_type IS 'Тип: REFRIGERATOR, FREEZER, SHOWCASE, CASH_REGISTER, SCALE, SHELVING, COOLER, HEAT_DISPLAY, SLICER, PACKAGING_MACHINE, TERMINAL, SCANNER, OTHER';

-- Таблица договоров лизинга
CREATE TABLE contracts (
    id BIGSERIAL PRIMARY KEY,
    contract_number VARCHAR(50) NOT NULL UNIQUE,
    client_id BIGINT NOT NULL,
    equipment_id BIGINT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_amount DECIMAL(15, 2) NOT NULL,
    interest_rate DECIMAL(5, 2),
    payment_period_months INTEGER,
    status VARCHAR(20) NOT NULL DEFAULT 'DRAFT',
    created_date DATE NOT NULL DEFAULT CURRENT_DATE,
    description VARCHAR(1000),
    insurance_policy_number VARCHAR(100),
    insurance_company VARCHAR(255),
    insurance_premium_annual DECIMAL(15, 2),
    insurance_premium_monthly DECIMAL(15, 2),
    insurance_start_date DATE,
    insurance_expiry_date DATE,
    insurance_coverage_amount DECIMAL(15, 2),
    insurance_type VARCHAR(50),
    maintenance_provider VARCHAR(255),
    maintenance_fee_monthly DECIMAL(15, 2),
    maintenance_included BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_contract_client FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE RESTRICT,
    CONSTRAINT fk_contract_equipment FOREIGN KEY (equipment_id) REFERENCES equipment(id) ON DELETE RESTRICT
);

COMMENT ON TABLE contracts IS 'Договоры лизинга';
COMMENT ON COLUMN contracts.status IS 'Статус: DRAFT (черновик), ACTIVE (активен), SUSPENDED (приостановлен), CLOSED (закрыт), CANCELLED (отменён)';

-- Таблица графиков платежей
CREATE TABLE payment_schedules (
    id BIGSERIAL PRIMARY KEY,
    contract_id BIGINT NOT NULL,
    period_number INTEGER NOT NULL,
    payment_date DATE NOT NULL,
    total_amount DECIMAL(15, 2) NOT NULL,
    principal_part DECIMAL(15, 2) NOT NULL,
    interest_part DECIMAL(15, 2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    CONSTRAINT fk_schedule_contract FOREIGN KEY (contract_id) REFERENCES contracts(id) ON DELETE CASCADE
);

COMMENT ON TABLE payment_schedules IS 'Плановые графики платежей по договорам';
COMMENT ON COLUMN payment_schedules.status IS 'Статус: PENDING (ожидается), PAID (оплачен), OVERDUE (просрочен), PARTIAL (частично оплачен), CANCELLED (отменён)';

-- Таблица платежей
CREATE TABLE payments (
    id BIGSERIAL PRIMARY KEY,
    schedule_id BIGINT NOT NULL,
    contract_id BIGINT NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    due_date TIMESTAMP NOT NULL,
    paid_date TIMESTAMP,
    payment_type VARCHAR(20),
    payment_method VARCHAR(20),
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    comment VARCHAR(500),
    CONSTRAINT fk_payment_schedule FOREIGN KEY (schedule_id) REFERENCES payment_schedules(id) ON DELETE CASCADE,
    CONSTRAINT fk_payment_contract FOREIGN KEY (contract_id) REFERENCES contracts(id) ON DELETE CASCADE
);

COMMENT ON TABLE payments IS 'Фактические поступления денежных средств';
COMMENT ON COLUMN payments.payment_type IS 'Тип: PRINCIPAL (основной долг), INTEREST (проценты), PENALTY (штрафы), ADDITIONAL (дополнительные услуги)';
COMMENT ON COLUMN payments.payment_method IS 'Способ: BANK_TRANSFER (безналичный), CASH (наличные), CARD (банковская карта)';

-- Таблица скоринга клиентов
CREATE TABLE client_scoring (
    id BIGSERIAL PRIMARY KEY,
    client_id BIGINT NOT NULL,
    score INTEGER NOT NULL,
    status VARCHAR(20) NOT NULL,
    auto_approved BOOLEAN,
    manual_review_required BOOLEAN,
    checked_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    reviewed_by BIGINT,
    review_date TIMESTAMP,
    review_comment VARCHAR(1000),
    rejection_reason VARCHAR(500),
    CONSTRAINT fk_scoring_client FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE,
    CONSTRAINT fk_scoring_reviewer FOREIGN KEY (reviewed_by) REFERENCES users(id) ON DELETE SET NULL
);

COMMENT ON TABLE client_scoring IS 'Результаты автоматизированной оценки кредитоспособности';
COMMENT ON COLUMN client_scoring.status IS 'Статус: PENDING (ожидает), APPROVED (одобрен), REJECTED (отклонён), MANUAL_REVIEW (на ручной проверке)';

-- Таблица инцидентов с оборудованием
CREATE TABLE equipment_incidents (
    id BIGSERIAL PRIMARY KEY,
    equipment_id BIGINT NOT NULL,
    contract_id BIGINT,
    incident_type VARCHAR(30) NOT NULL,
    incident_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    description TEXT,
    responsible_party VARCHAR(30),
    estimated_cost DECIMAL(15, 2),
    actual_cost DECIMAL(15, 2),
    status VARCHAR(30) NOT NULL DEFAULT 'REPORTED',
    resolution_notes TEXT,
    resolved_date TIMESTAMP,
    police_report_number VARCHAR(100),
    insurance_claim_number VARCHAR(100),
    compensation_amount DECIMAL(15, 2),
    reported_by BIGINT,
    resolved_by BIGINT,
    CONSTRAINT fk_incident_equipment FOREIGN KEY (equipment_id) REFERENCES equipment(id) ON DELETE CASCADE,
    CONSTRAINT fk_incident_contract FOREIGN KEY (contract_id) REFERENCES contracts(id) ON DELETE SET NULL,
    CONSTRAINT fk_incident_reporter FOREIGN KEY (reported_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_incident_resolver FOREIGN KEY (resolved_by) REFERENCES users(id) ON DELETE SET NULL
);

COMMENT ON TABLE equipment_incidents IS 'Учёт нештатных ситуаций с оборудованием';
COMMENT ON COLUMN equipment_incidents.incident_type IS 'Тип: BREAKDOWN (поломка), DAMAGE (повреждение), THEFT (кража), FORCE_MAJEURE (форс-мажор), LOSS (утрата)';
COMMENT ON COLUMN equipment_incidents.responsible_party IS 'Ответственная сторона: LESSOR (лизингодатель), LESSEE (лизингополучатель), INSURANCE (страховая), FORCE_MAJEURE, UNDER_INVESTIGATION';
COMMENT ON COLUMN equipment_incidents.status IS 'Статус: REPORTED, UNDER_INVESTIGATION, REPAIR_SCHEDULED, IN_REPAIR, RESOLVED, CLOSED, CANCELLED';

-- Таблица журнала аудита
CREATE TABLE audit_log (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT,
    username VARCHAR(100),
    action VARCHAR(50) NOT NULL,
    entity_type VARCHAR(100),
    entity_id BIGINT,
    description VARCHAR(1000),
    old_value TEXT,
    new_value TEXT,
    ip_address VARCHAR(45),
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_audit_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

COMMENT ON TABLE audit_log IS 'Журналирование действий пользователей системы';
COMMENT ON COLUMN audit_log.action IS 'Тип действия: CREATE, UPDATE, DELETE, LOGIN, LOGOUT, STATUS_CHANGE, APPROVE, REJECT';
