-- Добавление полей для физических лиц
ALTER TABLE clients ADD COLUMN passport_series VARCHAR(10);
ALTER TABLE clients ADD COLUMN passport_number VARCHAR(20);
ALTER TABLE clients ADD COLUMN passport_issued_by VARCHAR(500);
ALTER TABLE clients ADD COLUMN passport_issue_date DATE;
ALTER TABLE clients ADD COLUMN passport_department_code VARCHAR(10);
ALTER TABLE clients ADD COLUMN registration_address VARCHAR(500);
ALTER TABLE clients ADD COLUMN birth_date DATE;

-- Добавление полей для юридических лиц
ALTER TABLE clients ADD COLUMN ogrn VARCHAR(20);
ALTER TABLE clients ADD COLUMN actual_address VARCHAR(500);
ALTER TABLE clients ADD COLUMN contact_person_position VARCHAR(100);

-- Переименование колонки client_type для соответствия entity
ALTER TABLE clients RENAME COLUMN client_type TO client_type_old;
ALTER TABLE clients ADD COLUMN client_type VARCHAR(20);
UPDATE clients SET client_type = client_type_old;
ALTER TABLE clients DROP COLUMN client_type_old;

-- Комментарии к новым полям
COMMENT ON COLUMN clients.passport_series IS 'Серия паспорта (для физических лиц)';
COMMENT ON COLUMN clients.passport_number IS 'Номер паспорта (для физических лиц)';
COMMENT ON COLUMN clients.passport_issued_by IS 'Кем выдан паспорт (для физических лиц)';
COMMENT ON COLUMN clients.passport_issue_date IS 'Дата выдачи паспорта (для физических лиц)';
COMMENT ON COLUMN clients.passport_department_code IS 'Код подразделения (для физических лиц)';
COMMENT ON COLUMN clients.registration_address IS 'Адрес регистрации (для физических лиц)';
COMMENT ON COLUMN clients.birth_date IS 'Дата рождения (для физических лиц)';
COMMENT ON COLUMN clients.ogrn IS 'ОГРН/ОГРНИП (для юридических лиц)';
COMMENT ON COLUMN clients.actual_address IS 'Фактический адрес (для юридических лиц)';
COMMENT ON COLUMN clients.contact_person_position IS 'Должность контактного лица (для юридических лиц)';
