--
-- PostgreSQL database dump
--

\restrict ZTQ2QgKXzDVJd4v477MH40w4mJRuynWsWudcXSzQHFZiwpghT3DSxMEfGkS8zSh

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audit_log (
    id bigint NOT NULL,
    user_id bigint,
    username character varying(100),
    action character varying(50) NOT NULL,
    entity_type character varying(100),
    entity_id bigint,
    description character varying(1000),
    old_value text,
    new_value text,
    ip_address character varying(45),
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.audit_log OWNER TO postgres;

--
-- Name: TABLE audit_log; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.audit_log IS 'Журналирование действий пользователей системы';


--
-- Name: COLUMN audit_log.action; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.audit_log.action IS 'Тип действия: CREATE, UPDATE, DELETE, LOGIN, LOGOUT, STATUS_CHANGE, APPROVE, REJECT';


--
-- Name: audit_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.audit_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.audit_log_id_seq OWNER TO postgres;

--
-- Name: audit_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.audit_log_id_seq OWNED BY public.audit_log.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(1000)
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- Name: TABLE categories; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.categories IS 'Классификация типов торгового оборудования';


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categories_id_seq OWNER TO postgres;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: client_scoring; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client_scoring (
    id bigint NOT NULL,
    client_id bigint NOT NULL,
    score integer NOT NULL,
    status character varying(20) NOT NULL,
    auto_approved boolean,
    manual_review_required boolean,
    checked_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    reviewed_by bigint,
    review_date timestamp without time zone,
    review_comment character varying(1000),
    rejection_reason character varying(500)
);


ALTER TABLE public.client_scoring OWNER TO postgres;

--
-- Name: TABLE client_scoring; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.client_scoring IS 'Результаты автоматизированной оценки кредитоспособности';


--
-- Name: COLUMN client_scoring.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.client_scoring.status IS 'Статус: PENDING (ожидает), APPROVED (одобрен), REJECTED (отклонён), MANUAL_REVIEW (на ручной проверке)';


--
-- Name: client_scoring_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.client_scoring_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.client_scoring_id_seq OWNER TO postgres;

--
-- Name: client_scoring_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.client_scoring_id_seq OWNED BY public.client_scoring.id;


--
-- Name: clients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clients (
    id bigint NOT NULL,
    full_name character varying(255) NOT NULL,
    phone_number character varying(20),
    email character varying(100),
    company_name character varying(255),
    inn character varying(20),
    kpp character varying(20),
    legal_address character varying(500),
    bank_account character varying(20),
    bik character varying(9),
    bank_name character varying(255),
    created_date timestamp without time zone DEFAULT now() NOT NULL,
    updated_date timestamp without time zone,
    passport_series character varying(10),
    passport_number character varying(20),
    passport_issued_by character varying(500),
    passport_issue_date date,
    passport_department_code character varying(10),
    registration_address character varying(500),
    birth_date date,
    ogrn character varying(20),
    actual_address character varying(500),
    contact_person_position character varying(100),
    client_type character varying(20)
);


ALTER TABLE public.clients OWNER TO postgres;

--
-- Name: TABLE clients; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.clients IS 'Сведения о лизингополучателях';


--
-- Name: COLUMN clients.passport_series; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.clients.passport_series IS 'Серия паспорта (для физических лиц)';


--
-- Name: COLUMN clients.passport_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.clients.passport_number IS 'Номер паспорта (для физических лиц)';


--
-- Name: COLUMN clients.passport_issued_by; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.clients.passport_issued_by IS 'Кем выдан паспорт (для физических лиц)';


--
-- Name: COLUMN clients.passport_issue_date; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.clients.passport_issue_date IS 'Дата выдачи паспорта (для физических лиц)';


--
-- Name: COLUMN clients.passport_department_code; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.clients.passport_department_code IS 'Код подразделения (для физических лиц)';


--
-- Name: COLUMN clients.registration_address; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.clients.registration_address IS 'Адрес регистрации (для физических лиц)';


--
-- Name: COLUMN clients.birth_date; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.clients.birth_date IS 'Дата рождения (для физических лиц)';


--
-- Name: COLUMN clients.ogrn; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.clients.ogrn IS 'ОГРН/ОГРНИП (для юридических лиц)';


--
-- Name: COLUMN clients.actual_address; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.clients.actual_address IS 'Фактический адрес (для юридических лиц)';


--
-- Name: COLUMN clients.contact_person_position; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.clients.contact_person_position IS 'Должность контактного лица (для юридических лиц)';


--
-- Name: clients_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.clients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.clients_id_seq OWNER TO postgres;

--
-- Name: clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.clients_id_seq OWNED BY public.clients.id;


--
-- Name: contracts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contracts (
    id bigint NOT NULL,
    contract_number character varying(50) NOT NULL,
    client_id bigint NOT NULL,
    equipment_id bigint NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    total_amount numeric(15,2) NOT NULL,
    interest_rate numeric(5,2),
    payment_period_months integer,
    status character varying(20) DEFAULT 'DRAFT'::character varying NOT NULL,
    created_date date DEFAULT CURRENT_DATE NOT NULL,
    description character varying(1000),
    insurance_policy_number character varying(100),
    insurance_company character varying(255),
    insurance_premium_annual numeric(15,2),
    insurance_premium_monthly numeric(15,2),
    insurance_start_date date,
    insurance_expiry_date date,
    insurance_coverage_amount numeric(15,2),
    insurance_type character varying(50),
    maintenance_provider character varying(255),
    maintenance_fee_monthly numeric(15,2),
    maintenance_included boolean DEFAULT false
);


ALTER TABLE public.contracts OWNER TO postgres;

--
-- Name: TABLE contracts; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.contracts IS 'Договоры лизинга';


--
-- Name: COLUMN contracts.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.contracts.status IS 'Статус: DRAFT (черновик), ACTIVE (активен), SUSPENDED (приостановлен), CLOSED (закрыт), CANCELLED (отменён)';


--
-- Name: contracts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.contracts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.contracts_id_seq OWNER TO postgres;

--
-- Name: contracts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.contracts_id_seq OWNED BY public.contracts.id;


--
-- Name: equipment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.equipment (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    category_id bigint NOT NULL,
    price numeric(15,2) NOT NULL,
    model character varying(100),
    manufacturer character varying(100),
    serial_number character varying(100),
    year_of_manufacture integer,
    status character varying(20) DEFAULT 'AVAILABLE'::character varying NOT NULL,
    description character varying(1000),
    equipment_type character varying(50),
    dimensions character varying(50),
    weight numeric(8,2),
    power_consumption numeric(8,3),
    voltage integer,
    min_temperature integer,
    max_temperature integer,
    volume numeric(8,2),
    body_material character varying(100),
    installation_address character varying(500),
    installation_date date,
    next_maintenance_date date,
    last_maintenance_date date,
    warranty_months integer,
    service_contract_number character varying(50),
    energy_class character varying(10),
    country_of_origin character varying(100),
    maintenance_notes character varying(1000)
);


ALTER TABLE public.equipment OWNER TO postgres;

--
-- Name: TABLE equipment; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.equipment IS 'Реестр единиц торгового оборудования';


--
-- Name: COLUMN equipment.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.equipment.status IS 'Статус: AVAILABLE (доступно), LEASED (в лизинге), MAINTENANCE (на обслуживании), SOLD (продано), WRITE_OFF (списано)';


--
-- Name: COLUMN equipment.equipment_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.equipment.equipment_type IS 'Тип: REFRIGERATOR, FREEZER, SHOWCASE, CASH_REGISTER, SCALE, SHELVING, COOLER, HEAT_DISPLAY, SLICER, PACKAGING_MACHINE, TERMINAL, SCANNER, OTHER';


--
-- Name: equipment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.equipment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.equipment_id_seq OWNER TO postgres;

--
-- Name: equipment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.equipment_id_seq OWNED BY public.equipment.id;


--
-- Name: equipment_incidents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.equipment_incidents (
    id bigint NOT NULL,
    equipment_id bigint NOT NULL,
    contract_id bigint,
    incident_type character varying(30) NOT NULL,
    incident_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    description text,
    responsible_party character varying(30),
    estimated_cost numeric(15,2),
    actual_cost numeric(15,2),
    status character varying(30) DEFAULT 'REPORTED'::character varying NOT NULL,
    resolution_notes text,
    resolved_date timestamp without time zone,
    police_report_number character varying(100),
    insurance_claim_number character varying(100),
    compensation_amount numeric(15,2),
    reported_by bigint,
    resolved_by bigint
);


ALTER TABLE public.equipment_incidents OWNER TO postgres;

--
-- Name: TABLE equipment_incidents; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.equipment_incidents IS 'Учёт нештатных ситуаций с оборудованием';


--
-- Name: COLUMN equipment_incidents.incident_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.equipment_incidents.incident_type IS 'Тип: BREAKDOWN (поломка), DAMAGE (повреждение), THEFT (кража), FORCE_MAJEURE (форс-мажор), LOSS (утрата)';


--
-- Name: COLUMN equipment_incidents.responsible_party; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.equipment_incidents.responsible_party IS 'Ответственная сторона: LESSOR (лизингодатель), LESSEE (лизингополучатель), INSURANCE (страховая), FORCE_MAJEURE, UNDER_INVESTIGATION';


--
-- Name: COLUMN equipment_incidents.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.equipment_incidents.status IS 'Статус: REPORTED, UNDER_INVESTIGATION, REPAIR_SCHEDULED, IN_REPAIR, RESOLVED, CLOSED, CANCELLED';


--
-- Name: equipment_incidents_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.equipment_incidents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.equipment_incidents_id_seq OWNER TO postgres;

--
-- Name: equipment_incidents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.equipment_incidents_id_seq OWNED BY public.equipment_incidents.id;


--
-- Name: flyway_schema_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.flyway_schema_history (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


ALTER TABLE public.flyway_schema_history OWNER TO postgres;

--
-- Name: payment_schedules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_schedules (
    id bigint NOT NULL,
    contract_id bigint NOT NULL,
    period_number integer NOT NULL,
    payment_date date NOT NULL,
    total_amount numeric(15,2) NOT NULL,
    principal_part numeric(15,2) NOT NULL,
    interest_part numeric(15,2) NOT NULL,
    status character varying(20) DEFAULT 'PENDING'::character varying NOT NULL
);


ALTER TABLE public.payment_schedules OWNER TO postgres;

--
-- Name: TABLE payment_schedules; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.payment_schedules IS 'Плановые графики платежей по договорам';


--
-- Name: COLUMN payment_schedules.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.payment_schedules.status IS 'Статус: PENDING (ожидается), PAID (оплачен), OVERDUE (просрочен), PARTIAL (частично оплачен), CANCELLED (отменён)';


--
-- Name: payment_schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payment_schedules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payment_schedules_id_seq OWNER TO postgres;

--
-- Name: payment_schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payment_schedules_id_seq OWNED BY public.payment_schedules.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payments (
    id bigint NOT NULL,
    schedule_id bigint NOT NULL,
    contract_id bigint NOT NULL,
    amount numeric(15,2) NOT NULL,
    due_date timestamp without time zone NOT NULL,
    paid_date timestamp without time zone,
    payment_type character varying(20),
    payment_method character varying(20),
    status character varying(20) DEFAULT 'PENDING'::character varying NOT NULL,
    comment character varying(500)
);


ALTER TABLE public.payments OWNER TO postgres;

--
-- Name: TABLE payments; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.payments IS 'Фактические поступления денежных средств';


--
-- Name: COLUMN payments.payment_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.payments.payment_type IS 'Тип: PRINCIPAL (основной долг), INTEREST (проценты), PENALTY (штрафы), ADDITIONAL (дополнительные услуги)';


--
-- Name: COLUMN payments.payment_method; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.payments.payment_method IS 'Способ: BANK_TRANSFER (безналичный), CASH (наличные), CARD (банковская карта)';


--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payments_id_seq OWNER TO postgres;

--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    username character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    role character varying(20) DEFAULT 'MANAGER'::character varying NOT NULL,
    full_name character varying(255),
    email character varying(100),
    active boolean DEFAULT true NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: TABLE users; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.users IS 'Учётные записи сотрудников лизинговой компании';


--
-- Name: COLUMN users.role; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.role IS 'Роль пользователя: ADMIN, MANAGER';


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: audit_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_log ALTER COLUMN id SET DEFAULT nextval('public.audit_log_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: client_scoring id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_scoring ALTER COLUMN id SET DEFAULT nextval('public.client_scoring_id_seq'::regclass);


--
-- Name: clients id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clients ALTER COLUMN id SET DEFAULT nextval('public.clients_id_seq'::regclass);


--
-- Name: contracts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contracts ALTER COLUMN id SET DEFAULT nextval('public.contracts_id_seq'::regclass);


--
-- Name: equipment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment ALTER COLUMN id SET DEFAULT nextval('public.equipment_id_seq'::regclass);


--
-- Name: equipment_incidents id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment_incidents ALTER COLUMN id SET DEFAULT nextval('public.equipment_incidents_id_seq'::regclass);


--
-- Name: payment_schedules id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_schedules ALTER COLUMN id SET DEFAULT nextval('public.payment_schedules_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: audit_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.audit_log (id, user_id, username, action, entity_type, entity_id, description, old_value, new_value, ip_address, "timestamp") VALUES (1, 1, 'admin', 'LOGIN', NULL, NULL, 'Вход в систему', NULL, NULL, '192.168.1.100', '2026-01-15 09:00:00');
INSERT INTO public.audit_log (id, user_id, username, action, entity_type, entity_id, description, old_value, new_value, ip_address, "timestamp") VALUES (2, 2, 'manager1', 'LOGIN', NULL, NULL, 'Вход в систему', NULL, NULL, '192.168.1.101', '2026-01-15 09:15:00');
INSERT INTO public.audit_log (id, user_id, username, action, entity_type, entity_id, description, old_value, new_value, ip_address, "timestamp") VALUES (3, 3, 'manager2', 'LOGIN', NULL, NULL, 'Вход в систему', NULL, NULL, '192.168.1.102', '2026-01-15 09:30:00');
INSERT INTO public.audit_log (id, user_id, username, action, entity_type, entity_id, description, old_value, new_value, ip_address, "timestamp") VALUES (4, 2, 'manager1', 'CREATE', 'Client', 1, 'Создан клиент: ООО "Продукты 24"', NULL, NULL, '192.168.1.101', '2026-01-15 10:35:00');
INSERT INTO public.audit_log (id, user_id, username, action, entity_type, entity_id, description, old_value, new_value, ip_address, "timestamp") VALUES (5, 2, 'manager1', 'CREATE', 'Client', 2, 'Создан клиент: ИП Соколов Д.В.', NULL, NULL, '192.168.1.101', '2026-01-20 14:20:00');
INSERT INTO public.audit_log (id, user_id, username, action, entity_type, entity_id, description, old_value, new_value, ip_address, "timestamp") VALUES (6, 3, 'manager2', 'CREATE', 'Client', 3, 'Создан клиент: ООО "Магнит Плюс"', NULL, NULL, '192.168.1.102', '2026-02-01 09:10:00');
INSERT INTO public.audit_log (id, user_id, username, action, entity_type, entity_id, description, old_value, new_value, ip_address, "timestamp") VALUES (7, 2, 'manager1', 'CREATE', 'ClientScoring', 1, 'Проведен скоринг клиента, оценка: 750', NULL, NULL, '192.168.1.101', '2026-01-15 11:00:00');
INSERT INTO public.audit_log (id, user_id, username, action, entity_type, entity_id, description, old_value, new_value, ip_address, "timestamp") VALUES (8, 2, 'manager1', 'UPDATE', 'ClientScoring', 2, 'Скоринг одобрен после проверки', NULL, NULL, '192.168.1.101', '2026-01-20 16:00:00');
INSERT INTO public.audit_log (id, user_id, username, action, entity_type, entity_id, description, old_value, new_value, ip_address, "timestamp") VALUES (9, 2, 'manager1', 'CREATE', 'Contract', 1, 'Создан договор ЛД-2026-001 на сумму 102000.00', NULL, NULL, '192.168.1.101', '2026-01-25 14:00:00');
INSERT INTO public.audit_log (id, user_id, username, action, entity_type, entity_id, description, old_value, new_value, ip_address, "timestamp") VALUES (10, 2, 'manager1', 'CREATE', 'Contract', 2, 'Создан договор ЛД-2026-002 на сумму 54000.00', NULL, NULL, '192.168.1.101', '2026-02-10 10:30:00');
INSERT INTO public.audit_log (id, user_id, username, action, entity_type, entity_id, description, old_value, new_value, ip_address, "timestamp") VALUES (11, 3, 'manager2', 'CREATE', 'Contract', 3, 'Создан договор ЛД-2026-003 на сумму 134400.00', NULL, NULL, '192.168.1.102', '2026-02-25 16:00:00');
INSERT INTO public.audit_log (id, user_id, username, action, entity_type, entity_id, description, old_value, new_value, ip_address, "timestamp") VALUES (12, 2, 'manager1', 'UPDATE', 'Contract', 1, 'Договор активирован', NULL, NULL, '192.168.1.101', '2026-02-01 10:00:00');
INSERT INTO public.audit_log (id, user_id, username, action, entity_type, entity_id, description, old_value, new_value, ip_address, "timestamp") VALUES (13, 2, 'manager1', 'UPDATE', 'Contract', 2, 'Договор активирован', NULL, NULL, '192.168.1.101', '2026-02-15 11:00:00');
INSERT INTO public.audit_log (id, user_id, username, action, entity_type, entity_id, description, old_value, new_value, ip_address, "timestamp") VALUES (14, 2, 'manager1', 'CREATE', 'Payment', 1, 'Зарегистрирован платеж по договору ЛД-2026-001, период 1', NULL, NULL, '192.168.1.101', '2026-02-01 15:00:00');
INSERT INTO public.audit_log (id, user_id, username, action, entity_type, entity_id, description, old_value, new_value, ip_address, "timestamp") VALUES (15, 2, 'manager1', 'CREATE', 'Payment', 2, 'Зарегистрирован платеж по договору ЛД-2026-001, период 2', NULL, NULL, '192.168.1.101', '2026-03-01 14:30:00');
INSERT INTO public.audit_log (id, user_id, username, action, entity_type, entity_id, description, old_value, new_value, ip_address, "timestamp") VALUES (16, 2, 'manager1', 'CREATE', 'Payment', 3, 'Зарегистрирован платеж по договору ЛД-2026-001, период 3', NULL, NULL, '192.168.1.101', '2026-04-01 15:15:00');
INSERT INTO public.audit_log (id, user_id, username, action, entity_type, entity_id, description, old_value, new_value, ip_address, "timestamp") VALUES (17, 2, 'manager1', 'UPDATE', 'PaymentSchedule', 4, 'Платеж просрочен', NULL, NULL, '192.168.1.101', '2026-05-02 10:00:00');
INSERT INTO public.audit_log (id, user_id, username, action, entity_type, entity_id, description, old_value, new_value, ip_address, "timestamp") VALUES (18, 3, 'manager2', 'CREATE', 'Equipment', 1, 'Добавлено оборудование: Холодильная витрина Carboma R750', NULL, NULL, '192.168.1.102', '2026-01-10 10:00:00');
INSERT INTO public.audit_log (id, user_id, username, action, entity_type, entity_id, description, old_value, new_value, ip_address, "timestamp") VALUES (19, 3, 'manager2', 'CREATE', 'Equipment', 2, 'Добавлено оборудование: Морозильный ларь Pozis СФ-250', NULL, NULL, '192.168.1.102', '2026-01-10 10:15:00');
INSERT INTO public.audit_log (id, user_id, username, action, entity_type, entity_id, description, old_value, new_value, ip_address, "timestamp") VALUES (20, 2, 'manager1', 'UPDATE', 'Equipment', 1, 'Статус изменен: AVAILABLE -> LEASED', NULL, NULL, '192.168.1.101', '2026-02-01 10:05:00');
INSERT INTO public.audit_log (id, user_id, username, action, entity_type, entity_id, description, old_value, new_value, ip_address, "timestamp") VALUES (21, 2, 'manager1', 'UPDATE', 'Equipment', 2, 'Статус изменен: AVAILABLE -> LEASED', NULL, NULL, '192.168.1.101', '2026-02-15 11:05:00');
INSERT INTO public.audit_log (id, user_id, username, action, entity_type, entity_id, description, old_value, new_value, ip_address, "timestamp") VALUES (22, 1, 'admin', 'LOGIN', NULL, NULL, 'Вход в систему', NULL, NULL, '192.168.1.100', '2026-05-05 08:30:00');
INSERT INTO public.audit_log (id, user_id, username, action, entity_type, entity_id, description, old_value, new_value, ip_address, "timestamp") VALUES (23, 2, 'manager1', 'LOGIN', NULL, NULL, 'Вход в систему', NULL, NULL, '192.168.1.101', '2026-05-05 09:00:00');
INSERT INTO public.audit_log (id, user_id, username, action, entity_type, entity_id, description, old_value, new_value, ip_address, "timestamp") VALUES (24, 3, 'manager2', 'LOGIN', NULL, NULL, 'Вход в систему', NULL, NULL, '192.168.1.102', '2026-05-05 09:15:00');
INSERT INTO public.audit_log (id, user_id, username, action, entity_type, entity_id, description, old_value, new_value, ip_address, "timestamp") VALUES (25, 2, 'manager1', 'CREATE', 'EquipmentIncident', 1, 'Зарегистрирован инцидент: поломка компрессора', NULL, NULL, '192.168.1.101', '2026-03-15 14:35:00');
INSERT INTO public.audit_log (id, user_id, username, action, entity_type, entity_id, description, old_value, new_value, ip_address, "timestamp") VALUES (26, 3, 'manager2', 'UPDATE', 'EquipmentIncident', 1, 'Инцидент закрыт, ремонт завершен', NULL, NULL, '192.168.1.102', '2026-03-18 16:05:00');
INSERT INTO public.audit_log (id, user_id, username, action, entity_type, entity_id, description, old_value, new_value, ip_address, "timestamp") VALUES (27, 3, 'manager2', 'CREATE', 'EquipmentIncident', 2, 'Зарегистрирован инцидент: повреждение стекла витрины', NULL, NULL, '192.168.1.102', '2026-04-20 10:20:00');
INSERT INTO public.audit_log (id, user_id, username, action, entity_type, entity_id, description, old_value, new_value, ip_address, "timestamp") VALUES (28, 2, 'manager1', 'CREATE', 'EquipmentIncident', 3, 'Зарегистрирован инцидент: кража кассового аппарата', NULL, NULL, '192.168.1.101', '2026-04-25 22:30:00');
INSERT INTO public.audit_log (id, user_id, username, action, entity_type, entity_id, description, old_value, new_value, ip_address, "timestamp") VALUES (29, 4, 'manager3', 'CREATE', 'EquipmentIncident', 4, 'Зарегистрирован инцидент: поломка весов', NULL, NULL, '192.168.1.103', '2026-04-10 11:05:00');
INSERT INTO public.audit_log (id, user_id, username, action, entity_type, entity_id, description, old_value, new_value, ip_address, "timestamp") VALUES (30, 2, 'manager1', 'UPDATE', 'EquipmentIncident', 4, 'Инцидент закрыт, весы отремонтированы', NULL, NULL, '192.168.1.101', '2026-04-12 15:10:00');
INSERT INTO public.audit_log (id, user_id, username, action, entity_type, entity_id, description, old_value, new_value, ip_address, "timestamp") VALUES (31, 3, 'manager2', 'CREATE', 'EquipmentIncident', 6, 'Зарегистрирован инцидент: затопление POS-системы', NULL, NULL, '192.168.1.102', '2026-04-28 08:00:00');
INSERT INTO public.audit_log (id, user_id, username, action, entity_type, entity_id, description, old_value, new_value, ip_address, "timestamp") VALUES (32, 2, 'manager1', 'CREATE', 'EquipmentIncident', 7, 'Зарегистрирован инцидент: шумная работа компрессора', NULL, NULL, '192.168.1.101', '2026-05-01 09:35:00');


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.categories (id, name, description) VALUES (1, 'Холодильное оборудование', 'Холодильники, морозильники, холодильные витрины и шкафы для хранения продуктов');
INSERT INTO public.categories (id, name, description) VALUES (2, 'Торговые витрины', 'Витрины для выкладки товаров: холодильные, обычные, горки');
INSERT INTO public.categories (id, name, description) VALUES (3, 'Кассовое оборудование', 'Кассовые аппараты, фискальные регистраторы, POS-системы');
INSERT INTO public.categories (id, name, description) VALUES (4, 'Весовое оборудование', 'Торговые весы: настольные, напольные, этикетировочные');


--
-- Data for Name: client_scoring; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.client_scoring (id, client_id, score, status, auto_approved, manual_review_required, checked_date, reviewed_by, review_date, review_comment, rejection_reason) VALUES (27, 26, 58, 'PENDING', false, true, '2026-05-05 15:00:00', NULL, NULL, NULL, NULL);
INSERT INTO public.client_scoring (id, client_id, score, status, auto_approved, manual_review_required, checked_date, reviewed_by, review_date, review_comment, rejection_reason) VALUES (28, 27, 29, 'REJECTED', false, true, '2026-05-01 10:00:00', NULL, NULL, NULL, NULL);
INSERT INTO public.client_scoring (id, client_id, score, status, auto_approved, manual_review_required, checked_date, reviewed_by, review_date, review_comment, rejection_reason) VALUES (1, 1, 75, 'APPROVED', true, false, '2026-01-15 11:00:00', 2, '2026-01-15 11:30:00', 'Клиент с хорошей кредитной историей', NULL);
INSERT INTO public.client_scoring (id, client_id, score, status, auto_approved, manual_review_required, checked_date, reviewed_by, review_date, review_comment, rejection_reason) VALUES (2, 2, 68, 'APPROVED', false, true, '2026-01-20 15:00:00', 2, '2026-01-20 16:00:00', 'Одобрено после проверки документов', NULL);
INSERT INTO public.client_scoring (id, client_id, score, status, auto_approved, manual_review_required, checked_date, reviewed_by, review_date, review_comment, rejection_reason) VALUES (3, 3, 82, 'APPROVED', true, false, '2026-02-01 10:00:00', 3, '2026-02-01 10:15:00', 'Отличная кредитная история', NULL);
INSERT INTO public.client_scoring (id, client_id, score, status, auto_approved, manual_review_required, checked_date, reviewed_by, review_date, review_comment, rejection_reason) VALUES (4, 4, 71, 'APPROVED', true, false, '2026-02-10 12:00:00', 2, '2026-02-10 12:20:00', 'Стабильный клиент', NULL);
INSERT INTO public.client_scoring (id, client_id, score, status, auto_approved, manual_review_required, checked_date, reviewed_by, review_date, review_comment, rejection_reason) VALUES (5, 5, 65, 'APPROVED', false, true, '2026-02-15 17:00:00', 3, '2026-02-15 18:00:00', 'Одобрено с условиями', NULL);
INSERT INTO public.client_scoring (id, client_id, score, status, auto_approved, manual_review_required, checked_date, reviewed_by, review_date, review_comment, rejection_reason) VALUES (6, 6, 78, 'APPROVED', true, false, '2026-02-20 11:00:00', 2, '2026-02-20 11:15:00', 'Надежный клиент', NULL);
INSERT INTO public.client_scoring (id, client_id, score, status, auto_approved, manual_review_required, checked_date, reviewed_by, review_date, review_comment, rejection_reason) VALUES (7, 7, 69, 'APPROVED', false, true, '2026-03-01 14:00:00', 3, '2026-03-01 15:00:00', 'Одобрено после дополнительной проверки', NULL);
INSERT INTO public.client_scoring (id, client_id, score, status, auto_approved, manual_review_required, checked_date, reviewed_by, review_date, review_comment, rejection_reason) VALUES (8, 8, 72, 'APPROVED', true, false, '2026-03-05 16:00:00', 2, '2026-03-05 16:20:00', 'Хорошая платежная дисциплина', NULL);
INSERT INTO public.client_scoring (id, client_id, score, status, auto_approved, manual_review_required, checked_date, reviewed_by, review_date, review_comment, rejection_reason) VALUES (9, 9, 80, 'APPROVED', true, false, '2026-03-10 10:30:00', 3, '2026-03-10 10:45:00', 'Премиальный клиент', NULL);
INSERT INTO public.client_scoring (id, client_id, score, status, auto_approved, manual_review_required, checked_date, reviewed_by, review_date, review_comment, rejection_reason) VALUES (10, 10, 74, 'APPROVED', true, false, '2026-03-15 13:00:00', 2, '2026-03-15 13:15:00', 'Положительная история', NULL);
INSERT INTO public.client_scoring (id, client_id, score, status, auto_approved, manual_review_required, checked_date, reviewed_by, review_date, review_comment, rejection_reason) VALUES (11, 11, 76, 'APPROVED', true, false, '2026-03-20 11:00:00', 3, '2026-03-20 11:20:00', 'Стабильная компания', NULL);
INSERT INTO public.client_scoring (id, client_id, score, status, auto_approved, manual_review_required, checked_date, reviewed_by, review_date, review_comment, rejection_reason) VALUES (12, 12, 85, 'APPROVED', true, false, '2026-03-25 14:30:00', 2, '2026-03-25 14:45:00', 'Хорошие показатели', NULL);
INSERT INTO public.client_scoring (id, client_id, score, status, auto_approved, manual_review_required, checked_date, reviewed_by, review_date, review_comment, rejection_reason) VALUES (13, 13, 73, 'APPROVED', false, true, '2026-04-01 11:30:00', 3, '2026-04-01 12:30:00', 'Одобрено с ограничениями', NULL);
INSERT INTO public.client_scoring (id, client_id, score, status, auto_approved, manual_review_required, checked_date, reviewed_by, review_date, review_comment, rejection_reason) VALUES (14, 14, 67, 'APPROVED', true, false, '2026-04-05 17:00:00', 2, '2026-04-05 17:15:00', 'Отличный клиент', NULL);
INSERT INTO public.client_scoring (id, client_id, score, status, auto_approved, manual_review_required, checked_date, reviewed_by, review_date, review_comment, rejection_reason) VALUES (15, 15, 79, 'APPROVED', true, false, '2026-04-10 09:30:00', 3, '2026-04-10 09:45:00', 'Надежный партнер', NULL);
INSERT INTO public.client_scoring (id, client_id, score, status, auto_approved, manual_review_required, checked_date, reviewed_by, review_date, review_comment, rejection_reason) VALUES (16, 16, 70, 'APPROVED', false, true, '2026-01-25 10:30:00', 2, '2026-01-25 11:30:00', 'Физлицо, одобрено после проверки', NULL);
INSERT INTO public.client_scoring (id, client_id, score, status, auto_approved, manual_review_required, checked_date, reviewed_by, review_date, review_comment, rejection_reason) VALUES (17, 17, 81, 'APPROVED', true, false, '2026-02-05 15:00:00', 3, '2026-02-05 15:15:00', 'Хорошая кредитная история', NULL);
INSERT INTO public.client_scoring (id, client_id, score, status, auto_approved, manual_review_required, checked_date, reviewed_by, review_date, review_comment, rejection_reason) VALUES (18, 18, 77, 'APPROVED', false, true, '2026-02-25 16:30:00', 2, '2026-02-25 17:00:00', 'Одобрено с условиями', NULL);
INSERT INTO public.client_scoring (id, client_id, score, status, auto_approved, manual_review_required, checked_date, reviewed_by, review_date, review_comment, rejection_reason) VALUES (19, 19, 66, 'APPROVED', true, false, '2026-03-08 09:45:00', 3, '2026-03-08 10:00:00', 'Стабильный клиент', NULL);
INSERT INTO public.client_scoring (id, client_id, score, status, auto_approved, manual_review_required, checked_date, reviewed_by, review_date, review_comment, rejection_reason) VALUES (20, 20, 83, 'APPROVED', true, false, '2026-03-18 13:30:00', 2, '2026-03-18 13:45:00', 'Положительная оценка', NULL);
INSERT INTO public.client_scoring (id, client_id, score, status, auto_approved, manual_review_required, checked_date, reviewed_by, review_date, review_comment, rejection_reason) VALUES (22, 21, 60, 'MANUAL_REVIEW', false, true, '2026-05-03 10:00:00', NULL, NULL, NULL, NULL);
INSERT INTO public.client_scoring (id, client_id, score, status, auto_approved, manual_review_required, checked_date, reviewed_by, review_date, review_comment, rejection_reason) VALUES (23, 22, 65, 'MANUAL_REVIEW', false, true, '2026-05-04 14:30:00', NULL, NULL, NULL, NULL);
INSERT INTO public.client_scoring (id, client_id, score, status, auto_approved, manual_review_required, checked_date, reviewed_by, review_date, review_comment, rejection_reason) VALUES (24, 23, 50, 'MANUAL_REVIEW', false, true, '2026-05-05 09:15:00', NULL, NULL, NULL, NULL);
INSERT INTO public.client_scoring (id, client_id, score, status, auto_approved, manual_review_required, checked_date, reviewed_by, review_date, review_comment, rejection_reason) VALUES (25, 24, 65, 'MANUAL_REVIEW', false, true, '2026-05-05 11:00:00', NULL, NULL, NULL, NULL);
INSERT INTO public.client_scoring (id, client_id, score, status, auto_approved, manual_review_required, checked_date, reviewed_by, review_date, review_comment, rejection_reason) VALUES (26, 25, 55, 'MANUAL_REVIEW', false, true, '2026-05-02 16:00:00', NULL, NULL, NULL, NULL);


--
-- Data for Name: clients; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.clients (id, full_name, phone_number, email, company_name, inn, kpp, legal_address, bank_account, bik, bank_name, created_date, updated_date, passport_series, passport_number, passport_issued_by, passport_issue_date, passport_department_code, registration_address, birth_date, ogrn, actual_address, contact_person_position, client_type) VALUES (1, 'Иванов Иван Иванович', '+79161234567', 'info@produkty24.ru', 'ООО "Продукты 24"', '7707083893', '774301001', 'г. Москва, ул. Ленина, д. 10', '40702810100000012345', '044525225', 'ПАО Сбербанк', '2026-01-15 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1027700132195', 'г. Москва, ул. Ленина, д. 10', 'Генеральный директор', 'LEGAL_ENTITY');
INSERT INTO public.clients (id, full_name, phone_number, email, company_name, inn, kpp, legal_address, bank_account, bik, bank_name, created_date, updated_date, passport_series, passport_number, passport_issued_by, passport_issue_date, passport_department_code, registration_address, birth_date, ogrn, actual_address, contact_person_position, client_type) VALUES (2, 'Соколов Дмитрий Владимирович', '+79162345678', 'sokolov@mail.ru', 'ИП Соколов Д.В.', '773401234567', NULL, 'г. Москва, ул. Пушкина, д. 5', '40802810200000023456', '044525225', 'ПАО Сбербанк', '2026-01-20 14:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '304773401234567', NULL, NULL, 'LEGAL_ENTITY');
INSERT INTO public.clients (id, full_name, phone_number, email, company_name, inn, kpp, legal_address, bank_account, bik, bank_name, created_date, updated_date, passport_series, passport_number, passport_issued_by, passport_issue_date, passport_department_code, registration_address, birth_date, ogrn, actual_address, contact_person_position, client_type) VALUES (3, 'Петров Петр Петрович', '+79163456789', 'magnit@example.ru', 'ООО "Магнит Плюс"', '7736207543', '774502001', 'г. Москва, пр-т Мира, д. 25', '40702810300000034567', '044525593', 'ВТБ', '2026-02-01 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1027739876543', 'г. Москва, пр-т Мира, д. 25, офис 301', 'Директор', 'LEGAL_ENTITY');
INSERT INTO public.clients (id, full_name, phone_number, email, company_name, inn, kpp, legal_address, bank_account, bik, bank_name, created_date, updated_date, passport_series, passport_number, passport_issued_by, passport_issue_date, passport_department_code, registration_address, birth_date, ogrn, actual_address, contact_person_position, client_type) VALUES (4, 'Сидорова Анна Сергеевна', '+79164567890', 'svezhest@mail.ru', 'ООО "Свежесть"', '5004000476', '774603001', 'г. Москва, ул. Садовая, д. 15', '40702810400000045678', '044525225', 'ПАО Сбербанк', '2026-02-10 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1027746034567', NULL, 'Генеральный директор', 'LEGAL_ENTITY');
INSERT INTO public.clients (id, full_name, phone_number, email, company_name, inn, kpp, legal_address, bank_account, bik, bank_name, created_date, updated_date, passport_series, passport_number, passport_issued_by, passport_issue_date, passport_department_code, registration_address, birth_date, ogrn, actual_address, contact_person_position, client_type) VALUES (5, 'Морозова Елена Игоревна', '+79165678901', 'morozova@gmail.com', 'ИП Морозова Е.И.', '774501234568', NULL, 'г. Москва, ул. Чехова, д. 8', '40802810500000056789', '044525593', 'ВТБ', '2026-02-15 16:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '304774501234568', NULL, NULL, 'LEGAL_ENTITY');
INSERT INTO public.clients (id, full_name, phone_number, email, company_name, inn, kpp, legal_address, bank_account, bik, bank_name, created_date, updated_date, passport_series, passport_number, passport_issued_by, passport_issue_date, passport_department_code, registration_address, birth_date, ogrn, actual_address, contact_person_position, client_type) VALUES (6, 'Кузнецов Алексей Викторович', '+79166789012', 'gastronom@example.ru', 'ООО "Гастроном"', '7707083894', '774704001', 'г. Москва, ул. Тверская, д. 30', '40702810600000067890', '044525225', 'ПАО Сбербанк', '2026-02-20 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1027747045678', 'г. Москва, ул. Тверская, д. 30', 'Управляющий', 'LEGAL_ENTITY');
INSERT INTO public.clients (id, full_name, phone_number, email, company_name, inn, kpp, legal_address, bank_account, bik, bank_name, created_date, updated_date, passport_series, passport_number, passport_issued_by, passport_issue_date, passport_department_code, registration_address, birth_date, ogrn, actual_address, contact_person_position, client_type) VALUES (7, 'Волков Сергей Александрович', '+79167890123', 'pyaterochka@mail.ru', 'ООО "Пятерочка Юг"', '7736207544', '774805001', 'г. Москва, ул. Южная, д. 12', '40702810700000078901', '044525593', 'ВТБ', '2026-03-01 13:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1027748056789', NULL, 'Директор магазина', 'LEGAL_ENTITY');
INSERT INTO public.clients (id, full_name, phone_number, email, company_name, inn, kpp, legal_address, bank_account, bik, bank_name, created_date, updated_date, passport_series, passport_number, passport_issued_by, passport_issue_date, passport_department_code, registration_address, birth_date, ogrn, actual_address, contact_person_position, client_type) VALUES (8, 'Новиков Игорь Павлович', '+79168901234', 'kuznetsov@yandex.ru', 'ИП Кузнецов И.П.', '774601234569', NULL, 'г. Москва, ул. Новая, д. 7', '40802810800000089012', '044525225', 'ПАО Сбербанк', '2026-03-05 15:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '304774601234569', NULL, NULL, 'LEGAL_ENTITY');
INSERT INTO public.clients (id, full_name, phone_number, email, company_name, inn, kpp, legal_address, bank_account, bik, bank_name, created_date, updated_date, passport_series, passport_number, passport_issued_by, passport_issue_date, passport_department_code, registration_address, birth_date, ogrn, actual_address, contact_person_position, client_type) VALUES (9, 'Федорова Мария Дмитриевна', '+79169012345', 'delikatesy@example.ru', 'ООО "Деликатесы"', '5004000477', '774906001', 'г. Москва, ул. Арбат, д. 20', '40702810900000090123', '044525593', 'ВТБ', '2026-03-10 09:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1027749067890', 'г. Москва, ул. Арбат, д. 20, пом. 1', 'Генеральный директор', 'LEGAL_ENTITY');
INSERT INTO public.clients (id, full_name, phone_number, email, company_name, inn, kpp, legal_address, bank_account, bik, bank_name, created_date, updated_date, passport_series, passport_number, passport_issued_by, passport_issue_date, passport_department_code, registration_address, birth_date, ogrn, actual_address, contact_person_position, client_type) VALUES (10, 'Павлов Олег Николаевич', '+79160123456', 'fresh@mail.ru', 'ООО "Фреш Маркет"', '7707083895', '775007001', 'г. Москва, ул. Кутузовская, д. 18', '40702811000000001234', '044525225', 'ПАО Сбербанк', '2026-03-15 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1027750078901', NULL, 'Директор', 'LEGAL_ENTITY');
INSERT INTO public.clients (id, full_name, phone_number, email, company_name, inn, kpp, legal_address, bank_account, bik, bank_name, created_date, updated_date, passport_series, passport_number, passport_issued_by, passport_issue_date, passport_department_code, registration_address, birth_date, ogrn, actual_address, contact_person_position, client_type) VALUES (11, 'Смирнова Ирина Петровна', '+79161234570', 'azbuka@example.ru', 'ООО "Азбука Вкуса"', '7707083896', '775108001', 'г. Москва, ул. Ленинградская, д. 45', '40702811100000002345', '044525225', 'ПАО Сбербанк', '2026-03-20 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1027751089012', NULL, 'Генеральный директор', 'LEGAL_ENTITY');
INSERT INTO public.clients (id, full_name, phone_number, email, company_name, inn, kpp, legal_address, bank_account, bik, bank_name, created_date, updated_date, passport_series, passport_number, passport_issued_by, passport_issue_date, passport_department_code, registration_address, birth_date, ogrn, actual_address, contact_person_position, client_type) VALUES (12, 'Козлов Андрей Викторович', '+79162345679', 'perekrestok@mail.ru', 'ООО "Перекресток Плюс"', '7736207545', '775209001', 'г. Москва, пр-т Ленина, д. 100', '40702811200000003456', '044525593', 'ВТБ', '2026-03-25 14:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1027752090123', 'г. Москва, пр-т Ленина, д. 100, офис 5', 'Директор', 'LEGAL_ENTITY');
INSERT INTO public.clients (id, full_name, phone_number, email, company_name, inn, kpp, legal_address, bank_account, bik, bank_name, created_date, updated_date, passport_series, passport_number, passport_issued_by, passport_issue_date, passport_department_code, registration_address, birth_date, ogrn, actual_address, contact_person_position, client_type) VALUES (13, 'Белова Светлана Игоревна', '+79163456790', 'belova@yandex.ru', 'ИП Белова С.И.', '774601234570', NULL, 'г. Москва, ул. Садовая, д. 22', '40802811300000004567', '044525225', 'ПАО Сбербанк', '2026-04-01 11:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '304774601234570', NULL, NULL, 'LEGAL_ENTITY');
INSERT INTO public.clients (id, full_name, phone_number, email, company_name, inn, kpp, legal_address, bank_account, bik, bank_name, created_date, updated_date, passport_series, passport_number, passport_issued_by, passport_issue_date, passport_department_code, registration_address, birth_date, ogrn, actual_address, contact_person_position, client_type) VALUES (14, 'Орлов Максим Александрович', '+79164567891', 'vkusville@example.ru', 'ООО "ВкусВилл"', '5004000478', '775310001', 'г. Москва, ул. Тверская, д. 55', '40702811400000005678', '044525593', 'ВТБ', '2026-04-05 16:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1027753100234', NULL, 'Управляющий', 'LEGAL_ENTITY');
INSERT INTO public.clients (id, full_name, phone_number, email, company_name, inn, kpp, legal_address, bank_account, bik, bank_name, created_date, updated_date, passport_series, passport_number, passport_issued_by, passport_issue_date, passport_department_code, registration_address, birth_date, ogrn, actual_address, contact_person_position, client_type) VALUES (15, 'Лебедев Сергей Николаевич', '+79165678902', 'lebedev@gmail.com', 'ИП Лебедев С.Н.', '774701234571', NULL, 'г. Москва, ул. Новослободская, д. 12', '40802811500000006789', '044525225', 'ПАО Сбербанк', '2026-04-10 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '304774701234571', NULL, NULL, 'LEGAL_ENTITY');
INSERT INTO public.clients (id, full_name, phone_number, email, company_name, inn, kpp, legal_address, bank_account, bik, bank_name, created_date, updated_date, passport_series, passport_number, passport_issued_by, passport_issue_date, passport_department_code, registration_address, birth_date, ogrn, actual_address, contact_person_position, client_type) VALUES (16, 'Алексеев Владимир Петрович', '+79161234569', 'alekseev@mail.ru', NULL, '500100732259', NULL, NULL, '40817810100000011111', '044525225', 'ПАО Сбербанк', '2026-01-25 10:00:00', NULL, '4509', '123456', 'ОУФМС России по Московской области', '2010-05-15', '500-015', 'г. Москва, ул. Ленинская, д. 25, кв. 10', '1985-03-20', NULL, NULL, NULL, 'INDIVIDUAL');
INSERT INTO public.clients (id, full_name, phone_number, email, company_name, inn, kpp, legal_address, bank_account, bik, bank_name, created_date, updated_date, passport_series, passport_number, passport_issued_by, passport_issue_date, passport_department_code, registration_address, birth_date, ogrn, actual_address, contact_person_position, client_type) VALUES (17, 'Борисова Ольга Ивановна', '+79162345680', 'borisova@gmail.com', NULL, '500100732260', NULL, NULL, '40817810200000022222', '044525225', 'ПАО Сбербанк', '2026-02-05 14:30:00', NULL, '4510', '234567', 'ОУФМС России по г. Москве', '2012-08-20', '770-020', 'г. Москва, пр-т Мира, д. 50, кв. 25', '1990-07-15', NULL, NULL, NULL, 'INDIVIDUAL');
INSERT INTO public.clients (id, full_name, phone_number, email, company_name, inn, kpp, legal_address, bank_account, bik, bank_name, created_date, updated_date, passport_series, passport_number, passport_issued_by, passport_issue_date, passport_department_code, registration_address, birth_date, ogrn, actual_address, contact_person_position, client_type) VALUES (18, 'Васильев Николай Сергеевич', '+79163456781', 'vasiliev@yandex.ru', NULL, '500100732261', NULL, NULL, '40817810300000033333', '044525593', 'ВТБ', '2026-02-25 16:00:00', NULL, '4511', '345678', 'ОУФМС России по Московской области', '2011-03-10', '500-010', 'г. Москва, ул. Садовая, д. 12, кв. 5', '1988-11-30', NULL, NULL, NULL, 'INDIVIDUAL');
INSERT INTO public.clients (id, full_name, phone_number, email, company_name, inn, kpp, legal_address, bank_account, bik, bank_name, created_date, updated_date, passport_series, passport_number, passport_issued_by, passport_issue_date, passport_department_code, registration_address, birth_date, ogrn, actual_address, contact_person_position, client_type) VALUES (19, 'Григорьева Татьяна Александровна', '+79164567892', 'grigorieva@mail.ru', NULL, '500100732262', NULL, NULL, '40817810400000044444', '044525225', 'ПАО Сбербанк', '2026-03-08 09:15:00', NULL, '4512', '456789', 'ОУФМС России по г. Москве', '2013-06-25', '770-025', 'г. Москва, ул. Тверская, д. 8, кв. 15', '1992-04-10', NULL, NULL, NULL, 'INDIVIDUAL');
INSERT INTO public.clients (id, full_name, phone_number, email, company_name, inn, kpp, legal_address, bank_account, bik, bank_name, created_date, updated_date, passport_series, passport_number, passport_issued_by, passport_issue_date, passport_department_code, registration_address, birth_date, ogrn, actual_address, contact_person_position, client_type) VALUES (20, 'Дмитриев Артем Викторович', '+79165678903', 'dmitriev@gmail.com', NULL, '500100732263', NULL, NULL, '40817810500000055555', '044525593', 'ВТБ', '2026-03-18 13:00:00', NULL, '4513', '567890', 'ОУФМС России по Московской области', '2014-09-15', '500-018', 'г. Москва, ул. Новая, д. 30, кв. 42', '1987-12-05', NULL, NULL, NULL, 'INDIVIDUAL');
INSERT INTO public.clients (id, full_name, phone_number, email, company_name, inn, kpp, legal_address, bank_account, bik, bank_name, created_date, updated_date, passport_series, passport_number, passport_issued_by, passport_issue_date, passport_department_code, registration_address, birth_date, ogrn, actual_address, contact_person_position, client_type) VALUES (22, 'Жуков Константин Михайлович', '+79167890125', 'zhukov@mail.ru', NULL, '500100732265', NULL, NULL, '40817810700000077777', '044525593', 'ВТБ', '2026-04-03 10:30:00', NULL, '4515', '789012', 'ОУФМС России по Московской области', '2016-07-20', '500-022', 'г. Москва, ул. Профсоюзная, д. 45, кв. 120', '1989-05-18', NULL, NULL, NULL, 'INDIVIDUAL');
INSERT INTO public.clients (id, full_name, phone_number, email, company_name, inn, kpp, legal_address, bank_account, bik, bank_name, created_date, updated_date, passport_series, passport_number, passport_issued_by, passport_issue_date, passport_department_code, registration_address, birth_date, ogrn, actual_address, contact_person_position, client_type) VALUES (23, 'Зайцева Наталья Павловна', '+79168901236', 'zaitseva@gmail.com', NULL, NULL, NULL, NULL, NULL, '044525225', 'ПАО Сбербанк', '2026-04-08 12:00:00', NULL, '4516', '890123', 'ОУФМС России по г. Москве', '2017-11-05', '770-035', 'г. Москва, ул. Ломоносова, д. 22, кв. 33', '1993-01-25', NULL, NULL, NULL, 'INDIVIDUAL');
INSERT INTO public.clients (id, full_name, phone_number, email, company_name, inn, kpp, legal_address, bank_account, bik, bank_name, created_date, updated_date, passport_series, passport_number, passport_issued_by, passport_issue_date, passport_department_code, registration_address, birth_date, ogrn, actual_address, contact_person_position, client_type) VALUES (24, 'Иванова Екатерина Андреевна', '+79169012347', 'ivanova.e@yandex.ru', NULL, '500100732267', NULL, NULL, '40817810900000099999', '044525593', 'ВТБ', '2026-04-14 14:15:00', NULL, '4517', '901234', 'ОУФМС России по Московской области', '2018-04-12', '500-028', 'г. Москва, ул. Гагарина, д. 10, кв. 55', '1994-09-30', NULL, NULL, NULL, 'INDIVIDUAL');
INSERT INTO public.clients (id, full_name, phone_number, email, company_name, inn, kpp, legal_address, bank_account, bik, bank_name, created_date, updated_date, passport_series, passport_number, passport_issued_by, passport_issue_date, passport_department_code, registration_address, birth_date, ogrn, actual_address, contact_person_position, client_type) VALUES (26, 'Романов Игорь Сергеевич', '+79161234571', 'romanov@mail.ru', NULL, '500100732269', NULL, NULL, '40817811100000001111', '044525225', 'ПАО Сбербанк', '2026-04-22 10:00:00', NULL, '4519', '123457', 'ОУФМС России по Московской области', '2020-01-15', '500-025', 'г. Москва, ул. Пушкина, д. 33, кв. 77', '1990-02-14', NULL, NULL, NULL, 'INDIVIDUAL');
INSERT INTO public.clients (id, full_name, phone_number, email, company_name, inn, kpp, legal_address, bank_account, bik, bank_name, created_date, updated_date, passport_series, passport_number, passport_issued_by, passport_issue_date, passport_department_code, registration_address, birth_date, ogrn, actual_address, contact_person_position, client_type) VALUES (27, 'Соколова Марина Викторовна', '+79162345681', 'sokolova.m@gmail.com', NULL, '500100732270', NULL, NULL, '40817811200000002222', '044525593', 'ВТБ', '2026-04-25 13:30:00', NULL, '4520', '234568', 'ОУФМС России по г. Москве', '2020-05-20', '770-045', 'г. Москва, пр-т Вернадского, д. 88, кв. 12', '1993-11-08', NULL, NULL, NULL, 'INDIVIDUAL');
INSERT INTO public.clients (id, full_name, phone_number, email, company_name, inn, kpp, legal_address, bank_account, bik, bank_name, created_date, updated_date, passport_series, passport_number, passport_issued_by, passport_issue_date, passport_department_code, registration_address, birth_date, ogrn, actual_address, contact_person_position, client_type) VALUES (28, 'Михайлов Павел Андреевич', '+79163456792', 'mikhailov@yandex.ru', NULL, '500100732271', NULL, NULL, '40817811300000003333', '044525225', 'ПАО Сбербанк', '2026-04-28 15:00:00', NULL, '4521', '345679', 'ОУФМС России по Московской области', '2021-03-10', '500-030', 'г. Москва, ул. Ленина, д. 15, кв. 45', '1988-07-22', NULL, NULL, NULL, 'INDIVIDUAL');
INSERT INTO public.clients (id, full_name, phone_number, email, company_name, inn, kpp, legal_address, bank_account, bik, bank_name, created_date, updated_date, passport_series, passport_number, passport_issued_by, passport_issue_date, passport_department_code, registration_address, birth_date, ogrn, actual_address, contact_person_position, client_type) VALUES (29, 'Николаева Анна Дмитриевна', '+79164567893', 'nikolaeva@mail.ru', NULL, '500100732272', NULL, NULL, '40817811400000004444', '044525593', 'ВТБ', '2026-05-01 11:45:00', NULL, '4522', '456790', 'ОУФМС России по г. Москве', '2021-09-25', '770-050', 'г. Москва, ул. Чехова, д. 20, кв. 8', '1995-04-17', NULL, NULL, NULL, 'INDIVIDUAL');
INSERT INTO public.clients (id, full_name, phone_number, email, company_name, inn, kpp, legal_address, bank_account, bik, bank_name, created_date, updated_date, passport_series, passport_number, passport_issued_by, passport_issue_date, passport_department_code, registration_address, birth_date, ogrn, actual_address, contact_person_position, client_type) VALUES (30, 'Попов Александр Игоревич', '+79165678904', 'popov@gmail.com', NULL, '500100732273', NULL, NULL, '40817811500000005555', '044525225', 'ПАО Сбербанк', '2026-05-04 09:30:00', NULL, '4523', '567901', 'ОУФМС России по Московской области', '2022-02-14', '500-035', 'г. Москва, ул. Горького, д. 42, кв. 101', '1991-12-30', NULL, NULL, NULL, 'INDIVIDUAL');
INSERT INTO public.clients (id, full_name, phone_number, email, company_name, inn, kpp, legal_address, bank_account, bik, bank_name, created_date, updated_date, passport_series, passport_number, passport_issued_by, passport_issue_date, passport_department_code, registration_address, birth_date, ogrn, actual_address, contact_person_position, client_type) VALUES (21, 'Егорова Светлана Дмитриевна', '+79166789014', 'egorova@yandex.ru', NULL, '500100732264', NULL, NULL, NULL, '044525225', 'ПАО Сбербанк', '2026-03-28 15:45:00', NULL, '4514', '678901', 'ОУФМС России по г. Москве', '2015-02-10', '770-030', 'г. Москва, ул. Арбат, д. 15, кв. 8', '1991-08-22', NULL, NULL, NULL, 'INDIVIDUAL');
INSERT INTO public.clients (id, full_name, phone_number, email, company_name, inn, kpp, legal_address, bank_account, bik, bank_name, created_date, updated_date, passport_series, passport_number, passport_issued_by, passport_issue_date, passport_department_code, registration_address, birth_date, ogrn, actual_address, contact_person_position, client_type) VALUES (25, 'Киселев Денис Олегович', '+79160123458', 'kiselev@mail.ru', NULL, NULL, NULL, NULL, '40817811000000000000', '044525225', 'ПАО Сбербанк', '2026-04-19 16:30:00', NULL, '4518', '012345', 'ОУФМС России по г. Москве', '2019-08-30', '770-040', 'г. Москва, ул. Космонавтов, д. 5, кв. 18', '1986-06-12', NULL, NULL, NULL, 'INDIVIDUAL');


--
-- Data for Name: contracts; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.contracts (id, contract_number, client_id, equipment_id, start_date, end_date, total_amount, interest_rate, payment_period_months, status, created_date, description, insurance_policy_number, insurance_company, insurance_premium_annual, insurance_premium_monthly, insurance_start_date, insurance_expiry_date, insurance_coverage_amount, insurance_type, maintenance_provider, maintenance_fee_monthly, maintenance_included) VALUES (1, 'ЛД-2026-001', 1, 1, '2026-02-01', '2029-02-01', 102000.00, 8.50, 36, 'ACTIVE', '2026-05-06', NULL, 'INS-2026-001', 'АО "СОГАЗ"', 8500.00, 708.33, '2026-02-01', '2027-02-01', 102000.00, 'FULL', NULL, NULL, false);
INSERT INTO public.contracts (id, contract_number, client_id, equipment_id, start_date, end_date, total_amount, interest_rate, payment_period_months, status, created_date, description, insurance_policy_number, insurance_company, insurance_premium_annual, insurance_premium_monthly, insurance_start_date, insurance_expiry_date, insurance_coverage_amount, insurance_type, maintenance_provider, maintenance_fee_monthly, maintenance_included) VALUES (2, 'ЛД-2026-002', 2, 2, '2026-02-15', '2029-02-15', 54000.00, 9.00, 36, 'ACTIVE', '2026-05-06', NULL, 'INS-2026-002', 'ООО "Ингосстрах"', 4500.00, 375.00, '2026-02-15', '2027-02-15', 54000.00, 'FULL', NULL, NULL, false);
INSERT INTO public.contracts (id, contract_number, client_id, equipment_id, start_date, end_date, total_amount, interest_rate, payment_period_months, status, created_date, description, insurance_policy_number, insurance_company, insurance_premium_annual, insurance_premium_monthly, insurance_start_date, insurance_expiry_date, insurance_coverage_amount, insurance_type, maintenance_provider, maintenance_fee_monthly, maintenance_included) VALUES (3, 'ЛД-2026-003', 3, 3, '2026-03-01', '2028-03-01', 134400.00, 7.50, 24, 'ACTIVE', '2026-05-06', NULL, 'INS-2026-003', 'АО "Альфастрахование"', 10750.00, 895.83, '2026-03-01', '2027-03-01', 134400.00, 'FULL', NULL, NULL, false);
INSERT INTO public.contracts (id, contract_number, client_id, equipment_id, start_date, end_date, total_amount, interest_rate, payment_period_months, status, created_date, description, insurance_policy_number, insurance_company, insurance_premium_annual, insurance_premium_monthly, insurance_start_date, insurance_expiry_date, insurance_coverage_amount, insurance_type, maintenance_provider, maintenance_fee_monthly, maintenance_included) VALUES (4, 'ЛД-2026-004', 4, 10, '2026-03-15', '2029-03-15', 180000.00, 8.00, 36, 'ACTIVE', '2026-05-06', NULL, 'INS-2026-004', 'АО "СОГАЗ"', 14400.00, 1200.00, '2026-03-15', '2027-03-15', 180000.00, 'FULL', NULL, NULL, false);
INSERT INTO public.contracts (id, contract_number, client_id, equipment_id, start_date, end_date, total_amount, interest_rate, payment_period_months, status, created_date, description, insurance_policy_number, insurance_company, insurance_premium_annual, insurance_premium_monthly, insurance_start_date, insurance_expiry_date, insurance_coverage_amount, insurance_type, maintenance_provider, maintenance_fee_monthly, maintenance_included) VALUES (5, 'ЛД-2026-005', 5, 25, '2026-03-20', '2028-03-20', 50400.00, 9.50, 24, 'ACTIVE', '2026-05-06', NULL, 'INS-2026-005', 'ООО "Ингосстрах"', 4030.00, 335.83, '2026-03-20', '2027-03-20', 50400.00, 'FULL', NULL, NULL, false);
INSERT INTO public.contracts (id, contract_number, client_id, equipment_id, start_date, end_date, total_amount, interest_rate, payment_period_months, status, created_date, description, insurance_policy_number, insurance_company, insurance_premium_annual, insurance_premium_monthly, insurance_start_date, insurance_expiry_date, insurance_coverage_amount, insurance_type, maintenance_provider, maintenance_fee_monthly, maintenance_included) VALUES (6, 'ЛД-2026-006', 6, 18, '2026-04-01', '2028-04-01', 72800.00, 8.50, 24, 'ACTIVE', '2026-05-06', NULL, 'INS-2026-006', 'АО "Альфастрахование"', 5820.00, 485.00, '2026-04-01', '2027-04-01', 72800.00, 'FULL', NULL, NULL, false);
INSERT INTO public.contracts (id, contract_number, client_id, equipment_id, start_date, end_date, total_amount, interest_rate, payment_period_months, status, created_date, description, insurance_policy_number, insurance_company, insurance_premium_annual, insurance_premium_monthly, insurance_start_date, insurance_expiry_date, insurance_coverage_amount, insurance_type, maintenance_provider, maintenance_fee_monthly, maintenance_included) VALUES (7, 'ЛД-2026-007', 16, 17, '2026-04-10', '2027-04-10', 29400.00, 10.00, 12, 'ACTIVE', '2026-05-06', NULL, 'INS-2026-007', 'АО "СОГАЗ"', 2350.00, 195.83, '2026-04-10', '2027-04-10', 29400.00, 'FULL', NULL, NULL, false);
INSERT INTO public.contracts (id, contract_number, client_id, equipment_id, start_date, end_date, total_amount, interest_rate, payment_period_months, status, created_date, description, insurance_policy_number, insurance_company, insurance_premium_annual, insurance_premium_monthly, insurance_start_date, insurance_expiry_date, insurance_coverage_amount, insurance_type, maintenance_provider, maintenance_fee_monthly, maintenance_included) VALUES (8, 'ЛД-2026-008', 7, 12, '2026-04-15', '2029-04-15', 210000.00, 7.50, 36, 'ACTIVE', '2026-05-06', NULL, 'INS-2026-008', 'ООО "Ингосстрах"', 16800.00, 1400.00, '2026-04-15', '2027-04-15', 210000.00, 'FULL', NULL, NULL, false);
INSERT INTO public.contracts (id, contract_number, client_id, equipment_id, start_date, end_date, total_amount, interest_rate, payment_period_months, status, created_date, description, insurance_policy_number, insurance_company, insurance_premium_annual, insurance_premium_monthly, insurance_start_date, insurance_expiry_date, insurance_coverage_amount, insurance_type, maintenance_provider, maintenance_fee_monthly, maintenance_included) VALUES (9, 'ЛД-2026-009', 17, 24, '2026-04-20', '2027-04-20', 12600.00, 10.50, 12, 'ACTIVE', '2026-05-06', NULL, 'INS-2026-009', 'АО "Альфастрахование"', 1010.00, 84.17, '2026-04-20', '2027-04-20', 12600.00, 'FULL', NULL, NULL, false);
INSERT INTO public.contracts (id, contract_number, client_id, equipment_id, start_date, end_date, total_amount, interest_rate, payment_period_months, status, created_date, description, insurance_policy_number, insurance_company, insurance_premium_annual, insurance_premium_monthly, insurance_start_date, insurance_expiry_date, insurance_coverage_amount, insurance_type, maintenance_provider, maintenance_fee_monthly, maintenance_included) VALUES (10, 'ЛД-2026-010', 9, 9, '2026-04-25', '2028-04-25', 106400.00, 8.00, 24, 'ACTIVE', '2026-05-06', NULL, 'INS-2026-010', 'АО "СОГАЗ"', 8510.00, 709.17, '2026-04-25', '2027-04-25', 106400.00, 'FULL', NULL, NULL, false);
INSERT INTO public.contracts (id, contract_number, client_id, equipment_id, start_date, end_date, total_amount, interest_rate, payment_period_months, status, created_date, description, insurance_policy_number, insurance_company, insurance_premium_annual, insurance_premium_monthly, insurance_start_date, insurance_expiry_date, insurance_coverage_amount, insurance_type, maintenance_provider, maintenance_fee_monthly, maintenance_included) VALUES (11, 'ЛД-2026-011', 21, 1, '2026-05-01', '2028-05-01', 102000.00, 8.00, 24, 'ACTIVE', '2026-05-06', NULL, 'INS-2026-011', 'АО "СОГАЗ"', 8160.00, 680.00, '2026-05-01', '2027-05-01', 102000.00, 'FULL', NULL, NULL, false);
INSERT INTO public.contracts (id, contract_number, client_id, equipment_id, start_date, end_date, total_amount, interest_rate, payment_period_months, status, created_date, description, insurance_policy_number, insurance_company, insurance_premium_annual, insurance_premium_monthly, insurance_start_date, insurance_expiry_date, insurance_coverage_amount, insurance_type, maintenance_provider, maintenance_fee_monthly, maintenance_included) VALUES (12, 'ЛД-2026-012', 22, 2, '2026-04-25', '2028-04-25', 54000.00, 9.00, 24, 'ACTIVE', '2026-05-06', NULL, 'INS-2026-012', 'ООО "Ингосстрах"', 4320.00, 360.00, '2026-04-25', '2027-04-25', 54000.00, 'FULL', NULL, NULL, false);
INSERT INTO public.contracts (id, contract_number, client_id, equipment_id, start_date, end_date, total_amount, interest_rate, payment_period_months, status, created_date, description, insurance_policy_number, insurance_company, insurance_premium_annual, insurance_premium_monthly, insurance_start_date, insurance_expiry_date, insurance_coverage_amount, insurance_type, maintenance_provider, maintenance_fee_monthly, maintenance_included) VALUES (13, 'ЛД-2026-013', 23, 3, '2026-04-20', '2027-04-20', 134400.00, 10.00, 12, 'ACTIVE', '2026-05-06', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false);
INSERT INTO public.contracts (id, contract_number, client_id, equipment_id, start_date, end_date, total_amount, interest_rate, payment_period_months, status, created_date, description, insurance_policy_number, insurance_company, insurance_premium_annual, insurance_premium_monthly, insurance_start_date, insurance_expiry_date, insurance_coverage_amount, insurance_type, maintenance_provider, maintenance_fee_monthly, maintenance_included) VALUES (14, 'ЛД-2026-014', 24, 4, '2026-04-15', '2029-04-15', 168000.00, 7.50, 36, 'ACTIVE', '2026-05-06', NULL, 'INS-2026-014', 'АО "Альфастрахование"', 13440.00, 1120.00, '2026-04-15', '2027-04-15', 168000.00, 'FULL', NULL, NULL, false);
INSERT INTO public.contracts (id, contract_number, client_id, equipment_id, start_date, end_date, total_amount, interest_rate, payment_period_months, status, created_date, description, insurance_policy_number, insurance_company, insurance_premium_annual, insurance_premium_monthly, insurance_start_date, insurance_expiry_date, insurance_coverage_amount, insurance_type, maintenance_provider, maintenance_fee_monthly, maintenance_included) VALUES (15, 'ЛД-2026-015', 25, 5, '2026-04-10', '2027-04-10', 210000.00, 9.50, 12, 'ACTIVE', '2026-05-06', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false);
INSERT INTO public.contracts (id, contract_number, client_id, equipment_id, start_date, end_date, total_amount, interest_rate, payment_period_months, status, created_date, description, insurance_policy_number, insurance_company, insurance_premium_annual, insurance_premium_monthly, insurance_start_date, insurance_expiry_date, insurance_coverage_amount, insurance_type, maintenance_provider, maintenance_fee_monthly, maintenance_included) VALUES (16, 'ЛД-2026-016', 26, 6, '2026-04-05', '2028-04-05', 117600.00, 8.50, 24, 'ACTIVE', '2026-05-06', NULL, 'INS-2026-016', 'АО "СОГАЗ"', 9408.00, 784.00, '2026-04-05', '2027-04-05', 117600.00, 'FULL', NULL, NULL, false);
INSERT INTO public.contracts (id, contract_number, client_id, equipment_id, start_date, end_date, total_amount, interest_rate, payment_period_months, status, created_date, description, insurance_policy_number, insurance_company, insurance_premium_annual, insurance_premium_monthly, insurance_start_date, insurance_expiry_date, insurance_coverage_amount, insurance_type, maintenance_provider, maintenance_fee_monthly, maintenance_included) VALUES (17, 'ЛД-2026-017', 27, 7, '2026-05-10', '2029-05-10', 1260000.00, 7.00, 36, 'DRAFT', '2026-05-06', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false);
INSERT INTO public.contracts (id, contract_number, client_id, equipment_id, start_date, end_date, total_amount, interest_rate, payment_period_months, status, created_date, description, insurance_policy_number, insurance_company, insurance_premium_annual, insurance_premium_monthly, insurance_start_date, insurance_expiry_date, insurance_coverage_amount, insurance_type, maintenance_provider, maintenance_fee_monthly, maintenance_included) VALUES (18, 'ЛД-2026-018', 28, 8, '2026-03-25', '2028-03-25', 84000.00, 8.50, 24, 'ACTIVE', '2026-05-06', NULL, 'INS-2026-018', 'ООО "Ингосстрах"', 6720.00, 560.00, '2026-03-25', '2027-03-25', 84000.00, 'FULL', NULL, NULL, false);
INSERT INTO public.contracts (id, contract_number, client_id, equipment_id, start_date, end_date, total_amount, interest_rate, payment_period_months, status, created_date, description, insurance_policy_number, insurance_company, insurance_premium_annual, insurance_premium_monthly, insurance_start_date, insurance_expiry_date, insurance_coverage_amount, insurance_type, maintenance_provider, maintenance_fee_monthly, maintenance_included) VALUES (19, 'ЛД-2026-019', 29, 9, '2026-03-20', '2027-03-20', 168000.00, 10.00, 12, 'ACTIVE', '2026-05-06', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false);
INSERT INTO public.contracts (id, contract_number, client_id, equipment_id, start_date, end_date, total_amount, interest_rate, payment_period_months, status, created_date, description, insurance_policy_number, insurance_company, insurance_premium_annual, insurance_premium_monthly, insurance_start_date, insurance_expiry_date, insurance_coverage_amount, insurance_type, maintenance_provider, maintenance_fee_monthly, maintenance_included) VALUES (20, 'ЛД-2026-020', 30, 10, '2026-03-15', '2028-03-15', 126000.00, 9.00, 24, 'SUSPENDED', '2026-05-06', NULL, 'INS-2026-020', 'АО "Альфастрахование"', 10080.00, 840.00, '2026-03-15', '2027-03-15', 126000.00, 'FULL', NULL, NULL, false);


--
-- Data for Name: equipment; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.equipment (id, name, category_id, price, model, manufacturer, serial_number, year_of_manufacture, status, description, equipment_type, dimensions, weight, power_consumption, voltage, min_temperature, max_temperature, volume, body_material, installation_address, installation_date, next_maintenance_date, last_maintenance_date, warranty_months, service_contract_number, energy_class, country_of_origin, maintenance_notes) VALUES (11, 'Витрина холодильная Cryspi Gamma', 2, 105000.00, 'Gamma', 'Cryspi', 'CR-GAM-018', 2026, 'AVAILABLE', 'Витрина холодильная настольная', 'SHOWCASE', '1200x700x1100', 145.00, 1.500, 220, 1, 7, 250.00, 'стекло/металл', NULL, NULL, NULL, NULL, 18, NULL, 'A', 'Россия', NULL);
INSERT INTO public.equipment (id, name, category_id, price, model, manufacturer, serial_number, year_of_manufacture, status, description, equipment_type, dimensions, weight, power_consumption, voltage, min_temperature, max_temperature, volume, body_material, installation_address, installation_date, next_maintenance_date, last_maintenance_date, warranty_months, service_contract_number, energy_class, country_of_origin, maintenance_notes) VALUES (12, 'Горка холодильная Ариада Виолетта', 2, 175000.00, 'Виолетта', 'Ариада', 'AR-VIO-019', 2026, 'AVAILABLE', 'Холодильная горка премиум-класса', 'COOLER', '1300x1000x2000', 295.00, 3.000, 220, 0, 6, 1000.00, 'нержавеющая сталь', NULL, NULL, NULL, NULL, 24, NULL, 'A++', 'Россия', NULL);
INSERT INTO public.equipment (id, name, category_id, price, model, manufacturer, serial_number, year_of_manufacture, status, description, equipment_type, dimensions, weight, power_consumption, voltage, min_temperature, max_temperature, volume, body_material, installation_address, installation_date, next_maintenance_date, last_maintenance_date, warranty_months, service_contract_number, energy_class, country_of_origin, maintenance_notes) VALUES (13, 'Витрина тепловая Abat ВТ-1', 2, 68000.00, 'ВТ-1', 'Abat', 'AB-VT1-020', 2025, 'AVAILABLE', 'Тепловая витрина для готовой продукции', 'HEAT_DISPLAY', '1000x500x600', 35.00, 1.500, 220, 30, 80, NULL, 'нержавеющая сталь', NULL, NULL, NULL, NULL, 12, NULL, 'A', 'Россия', NULL);
INSERT INTO public.equipment (id, name, category_id, price, model, manufacturer, serial_number, year_of_manufacture, status, description, equipment_type, dimensions, weight, power_consumption, voltage, min_temperature, max_temperature, volume, body_material, installation_address, installation_date, next_maintenance_date, last_maintenance_date, warranty_months, service_contract_number, energy_class, country_of_origin, maintenance_notes) VALUES (14, 'Горка холодильная Polair Cube 190', 2, 165000.00, 'Cube 190', 'Polair', 'PL-CB190-021', 2026, 'AVAILABLE', 'Холодильная горка с боковыми панелями', 'COOLER', '1200x950x1980', 270.00, 2.800, 220, 0, 6, 900.00, 'нержавеющая сталь', NULL, NULL, NULL, NULL, 24, NULL, 'A+', 'Россия', NULL);
INSERT INTO public.equipment (id, name, category_id, price, model, manufacturer, serial_number, year_of_manufacture, status, description, equipment_type, dimensions, weight, power_consumption, voltage, min_temperature, max_temperature, volume, body_material, installation_address, installation_date, next_maintenance_date, last_maintenance_date, warranty_months, service_contract_number, energy_class, country_of_origin, maintenance_notes) VALUES (15, 'Витрина кондитерская Carboma KC70', 2, 88000.00, 'KC70', 'Carboma', 'CB-KC70-022', 2026, 'AVAILABLE', 'Кондитерская витрина с подсветкой', 'SHOWCASE', '1400x750x1150', 165.00, 1.600, 220, 2, 8, 280.00, 'стекло/металл', NULL, NULL, NULL, NULL, 12, NULL, 'A', 'Россия', NULL);
INSERT INTO public.equipment (id, name, category_id, price, model, manufacturer, serial_number, year_of_manufacture, status, description, equipment_type, dimensions, weight, power_consumption, voltage, min_temperature, max_temperature, volume, body_material, installation_address, installation_date, next_maintenance_date, last_maintenance_date, warranty_months, service_contract_number, energy_class, country_of_origin, maintenance_notes) VALUES (16, 'Горка холодильная Arneg Berlin', 2, 220000.00, 'Berlin 2', 'Arneg', 'AR-BER2-023', 2026, 'AVAILABLE', 'Премиальная холодильная горка', 'COOLER', '1500x1100x2050', 320.00, 3.500, 220, 0, 6, 1200.00, 'нержавеющая сталь', NULL, NULL, NULL, NULL, 36, NULL, 'A++', 'Италия', NULL);
INSERT INTO public.equipment (id, name, category_id, price, model, manufacturer, serial_number, year_of_manufacture, status, description, equipment_type, dimensions, weight, power_consumption, voltage, min_temperature, max_temperature, volume, body_material, installation_address, installation_date, next_maintenance_date, last_maintenance_date, warranty_months, service_contract_number, energy_class, country_of_origin, maintenance_notes) VALUES (17, 'Касса Атол 55Ф', 3, 28000.00, '55Ф', 'Атол', 'AT-55F-026', 2026, 'AVAILABLE', 'Фискальный регистратор для торговли', 'CASH_REGISTER', '200x150x150', 1.50, 0.050, 220, NULL, NULL, NULL, 'пластик', NULL, NULL, NULL, NULL, 12, NULL, 'A', 'Россия', NULL);
INSERT INTO public.equipment (id, name, category_id, price, model, manufacturer, serial_number, year_of_manufacture, status, description, equipment_type, dimensions, weight, power_consumption, voltage, min_temperature, max_temperature, volume, body_material, installation_address, installation_date, next_maintenance_date, last_maintenance_date, warranty_months, service_contract_number, energy_class, country_of_origin, maintenance_notes) VALUES (18, 'POS-система Штрих-М', 3, 65000.00, 'POS-007', 'Штрих-М', 'SH-POS-027', 2026, 'AVAILABLE', 'POS-система для автоматизации торговли', 'TERMINAL', '400x300x350', 5.00, 0.150, 220, NULL, NULL, NULL, 'металл/пластик', NULL, NULL, NULL, NULL, 24, NULL, 'A+', 'Россия', NULL);
INSERT INTO public.equipment (id, name, category_id, price, model, manufacturer, serial_number, year_of_manufacture, status, description, equipment_type, dimensions, weight, power_consumption, voltage, min_temperature, max_temperature, volume, body_material, installation_address, installation_date, next_maintenance_date, last_maintenance_date, warranty_months, service_contract_number, energy_class, country_of_origin, maintenance_notes) VALUES (19, 'Касса Атол 91Ф', 3, 35000.00, '91Ф', 'Атол', 'AT-91F-028', 2026, 'AVAILABLE', 'Фискальный регистратор с автоотрезом', 'CASH_REGISTER', '220x180x160', 1.80, 0.060, 220, NULL, NULL, NULL, 'пластик', NULL, NULL, NULL, NULL, 12, NULL, 'A', 'Россия', NULL);
INSERT INTO public.equipment (id, name, category_id, price, model, manufacturer, serial_number, year_of_manufacture, status, description, equipment_type, dimensions, weight, power_consumption, voltage, min_temperature, max_temperature, volume, body_material, installation_address, installation_date, next_maintenance_date, last_maintenance_date, warranty_months, service_contract_number, energy_class, country_of_origin, maintenance_notes) VALUES (20, 'POS-система Эвотор 7.3', 3, 42000.00, '7.3', 'Эвотор', 'EV-73-029', 2026, 'AVAILABLE', 'Смарт-терминал с эквайрингом', 'TERMINAL', '250x200x180', 2.50, 0.080, 220, NULL, NULL, NULL, 'пластик', NULL, NULL, NULL, NULL, 24, NULL, 'A', 'Россия', NULL);
INSERT INTO public.equipment (id, name, category_id, price, model, manufacturer, serial_number, year_of_manufacture, status, description, equipment_type, dimensions, weight, power_consumption, voltage, min_temperature, max_temperature, volume, body_material, installation_address, installation_date, next_maintenance_date, last_maintenance_date, warranty_months, service_contract_number, energy_class, country_of_origin, maintenance_notes) VALUES (21, 'Касса Меркурий 185Ф', 3, 32000.00, '185Ф', 'Меркурий', 'MR-185F-030', 2025, 'AVAILABLE', 'Фискальный регистратор компактный', 'CASH_REGISTER', '210x160x155', 1.60, 0.050, 220, NULL, NULL, NULL, 'пластик', NULL, NULL, NULL, NULL, 12, NULL, 'A', 'Россия', NULL);
INSERT INTO public.equipment (id, name, category_id, price, model, manufacturer, serial_number, year_of_manufacture, status, description, equipment_type, dimensions, weight, power_consumption, voltage, min_temperature, max_temperature, volume, body_material, installation_address, installation_date, next_maintenance_date, last_maintenance_date, warranty_months, service_contract_number, energy_class, country_of_origin, maintenance_notes) VALUES (22, 'POS-система MSPOS-K', 3, 58000.00, 'MSPOS-K', 'MSPOS', 'MS-POSK-031', 2026, 'AVAILABLE', 'POS-терминал с сенсорным экраном', 'TERMINAL', '380x320x340', 4.80, 0.140, 220, NULL, NULL, NULL, 'металл/пластик', NULL, NULL, NULL, NULL, 24, NULL, 'A', 'Россия', NULL);
INSERT INTO public.equipment (id, name, category_id, price, model, manufacturer, serial_number, year_of_manufacture, status, description, equipment_type, dimensions, weight, power_consumption, voltage, min_temperature, max_temperature, volume, body_material, installation_address, installation_date, next_maintenance_date, last_maintenance_date, warranty_months, service_contract_number, energy_class, country_of_origin, maintenance_notes) VALUES (23, 'Касса Атол 77Ф', 3, 38000.00, '77Ф', 'Атол', 'AT-77F-032', 2026, 'AVAILABLE', 'Фискальный регистратор с Wi-Fi', 'CASH_REGISTER', '230x190x165', 1.90, 0.060, 220, NULL, NULL, NULL, 'пластик', NULL, NULL, NULL, NULL, 12, NULL, 'A', 'Россия', NULL);
INSERT INTO public.equipment (id, name, category_id, price, model, manufacturer, serial_number, year_of_manufacture, status, description, equipment_type, dimensions, weight, power_consumption, voltage, min_temperature, max_temperature, volume, body_material, installation_address, installation_date, next_maintenance_date, last_maintenance_date, warranty_months, service_contract_number, energy_class, country_of_origin, maintenance_notes) VALUES (24, 'Весы торговые Меркурий МП-15', 4, 12000.00, 'МП-15', 'Меркурий', 'MC-MP15-036', 2026, 'AVAILABLE', 'Торговые весы до 15 кг', 'SCALE', '350x250x100', 3.50, 0.020, 220, NULL, NULL, NULL, 'нержавеющая сталь', NULL, NULL, NULL, NULL, 12, NULL, NULL, 'Россия', NULL);
INSERT INTO public.equipment (id, name, category_id, price, model, manufacturer, serial_number, year_of_manufacture, status, description, equipment_type, dimensions, weight, power_consumption, voltage, min_temperature, max_temperature, volume, body_material, installation_address, installation_date, next_maintenance_date, last_maintenance_date, warranty_months, service_contract_number, energy_class, country_of_origin, maintenance_notes) VALUES (25, 'Весы этикетировочные CAS CL-3000', 4, 45000.00, 'CL-3000', 'CAS', 'CAS-CL3000-037', 2026, 'AVAILABLE', 'Весы с печатью этикеток', 'SCALE', '400x450x550', 12.00, 0.100, 220, NULL, NULL, NULL, 'металл', NULL, NULL, NULL, NULL, 24, NULL, NULL, 'Южная Корея', NULL);
INSERT INTO public.equipment (id, name, category_id, price, model, manufacturer, serial_number, year_of_manufacture, status, description, equipment_type, dimensions, weight, power_consumption, voltage, min_temperature, max_temperature, volume, body_material, installation_address, installation_date, next_maintenance_date, last_maintenance_date, warranty_months, service_contract_number, energy_class, country_of_origin, maintenance_notes) VALUES (7, 'Морозильная камера Liebherr GGv 5060', 1, 180000.00, 'GGv 5060', 'Liebherr', 'LH-GGV-007', 2026, 'MAINTENANCE', 'Профессиональная морозильная камера', 'FREEZER', '750x750x2100', 110.00, 2.000, 220, -25, -15, 500.00, 'нержавеющая сталь', NULL, NULL, NULL, NULL, 48, NULL, 'A++', 'Германия', NULL);
INSERT INTO public.equipment (id, name, category_id, price, model, manufacturer, serial_number, year_of_manufacture, status, description, equipment_type, dimensions, weight, power_consumption, voltage, min_temperature, max_temperature, volume, body_material, installation_address, installation_date, next_maintenance_date, last_maintenance_date, warranty_months, service_contract_number, energy_class, country_of_origin, maintenance_notes) VALUES (26, 'Весы торговые Масса-К МК-6.2', 4, 15000.00, 'МК-6.2', 'Масса-К', 'MK-62-038', 2026, 'AVAILABLE', 'Торговые весы настольные', 'SCALE', '330x240x110', 3.20, 0.020, 220, NULL, NULL, NULL, 'нержавеющая сталь', NULL, NULL, NULL, NULL, 12, NULL, NULL, 'Россия', NULL);
INSERT INTO public.equipment (id, name, category_id, price, model, manufacturer, serial_number, year_of_manufacture, status, description, equipment_type, dimensions, weight, power_consumption, voltage, min_temperature, max_temperature, volume, body_material, installation_address, installation_date, next_maintenance_date, last_maintenance_date, warranty_months, service_contract_number, energy_class, country_of_origin, maintenance_notes) VALUES (27, 'Весы этикетировочные Штрих-Принт', 4, 52000.00, 'Принт-4.5', 'Штрих-М', 'SH-PR45-039', 2026, 'AVAILABLE', 'Весы с термопринтером', 'SCALE', '420x480x580', 14.00, 0.120, 220, NULL, NULL, NULL, 'металл', NULL, NULL, NULL, NULL, 24, NULL, NULL, 'Россия', NULL);
INSERT INTO public.equipment (id, name, category_id, price, model, manufacturer, serial_number, year_of_manufacture, status, description, equipment_type, dimensions, weight, power_consumption, voltage, min_temperature, max_temperature, volume, body_material, installation_address, installation_date, next_maintenance_date, last_maintenance_date, warranty_months, service_contract_number, energy_class, country_of_origin, maintenance_notes) VALUES (28, 'Весы торговые Атол MARTA', 4, 18000.00, 'MARTA', 'Атол', 'AT-MARTA-040', 2026, 'AVAILABLE', 'Торговые весы с LED-дисплеем', 'SCALE', '360x270x120', 3.80, 0.030, 220, NULL, NULL, NULL, 'нержавеющая сталь', NULL, NULL, NULL, NULL, 12, NULL, NULL, 'Россия', NULL);
INSERT INTO public.equipment (id, name, category_id, price, model, manufacturer, serial_number, year_of_manufacture, status, description, equipment_type, dimensions, weight, power_consumption, voltage, min_temperature, max_temperature, volume, body_material, installation_address, installation_date, next_maintenance_date, last_maintenance_date, warranty_months, service_contract_number, energy_class, country_of_origin, maintenance_notes) VALUES (29, 'Весы этикетировочные Digi SM-100', 4, 48000.00, 'SM-100', 'Digi', 'DG-SM100-041', 2026, 'AVAILABLE', 'Весы с принтером этикеток', 'SCALE', '410x460x570', 13.00, 0.110, 220, NULL, NULL, NULL, 'металл', NULL, NULL, NULL, NULL, 24, NULL, NULL, 'Япония', NULL);
INSERT INTO public.equipment (id, name, category_id, price, model, manufacturer, serial_number, year_of_manufacture, status, description, equipment_type, dimensions, weight, power_consumption, voltage, min_temperature, max_temperature, volume, body_material, installation_address, installation_date, next_maintenance_date, last_maintenance_date, warranty_months, service_contract_number, energy_class, country_of_origin, maintenance_notes) VALUES (30, 'Весы торговые Меркурий МП-30', 4, 16000.00, 'МП-30', 'Меркурий', 'MC-MP30-042', 2026, 'AVAILABLE', 'Торговые весы до 30 кг', 'SCALE', '380x280x110', 4.00, 0.030, 220, NULL, NULL, NULL, 'нержавеющая сталь', NULL, NULL, NULL, NULL, 12, NULL, NULL, 'Россия', NULL);
INSERT INTO public.equipment (id, name, category_id, price, model, manufacturer, serial_number, year_of_manufacture, status, description, equipment_type, dimensions, weight, power_consumption, voltage, min_temperature, max_temperature, volume, body_material, installation_address, installation_date, next_maintenance_date, last_maintenance_date, warranty_months, service_contract_number, energy_class, country_of_origin, maintenance_notes) VALUES (1, 'Холодильная витрина Carboma R750', 1, 85000.00, 'R750', 'Carboma', 'CB-R750-001', 2026, 'LEASED', 'Холодильная витрина для магазинов самообслуживания', 'REFRIGERATOR', '1200x750x2000', 120.50, 1.200, 220, 0, 7, 500.00, 'нержавеющая сталь', NULL, NULL, NULL, NULL, 24, NULL, 'A+', 'Россия', NULL);
INSERT INTO public.equipment (id, name, category_id, price, model, manufacturer, serial_number, year_of_manufacture, status, description, equipment_type, dimensions, weight, power_consumption, voltage, min_temperature, max_temperature, volume, body_material, installation_address, installation_date, next_maintenance_date, last_maintenance_date, warranty_months, service_contract_number, energy_class, country_of_origin, maintenance_notes) VALUES (2, 'Морозильный ларь Pozis СФ-250', 1, 45000.00, 'СФ-250', 'Pozis', 'PZ-SF250-002', 2026, 'LEASED', 'Морозильный ларь для замороженных продуктов', 'FREEZER', '1000x650x850', 55.00, 0.800, 220, -18, -10, 250.00, 'металл', NULL, NULL, NULL, NULL, 36, NULL, 'A', 'Россия', NULL);
INSERT INTO public.equipment (id, name, category_id, price, model, manufacturer, serial_number, year_of_manufacture, status, description, equipment_type, dimensions, weight, power_consumption, voltage, min_temperature, max_temperature, volume, body_material, installation_address, installation_date, next_maintenance_date, last_maintenance_date, warranty_months, service_contract_number, energy_class, country_of_origin, maintenance_notes) VALUES (3, 'Холодильный шкаф Polair DM105-S', 1, 120000.00, 'DM105-S', 'Polair', 'PL-DM105-003', 2026, 'LEASED', 'Холодильный шкаф для хранения продуктов', 'REFRIGERATOR', '600x600x2000', 85.00, 1.500, 220, 1, 10, 500.00, 'нержавеющая сталь', NULL, NULL, NULL, NULL, 24, NULL, 'A++', 'Россия', NULL);
INSERT INTO public.equipment (id, name, category_id, price, model, manufacturer, serial_number, year_of_manufacture, status, description, equipment_type, dimensions, weight, power_consumption, voltage, min_temperature, max_temperature, volume, body_material, installation_address, installation_date, next_maintenance_date, last_maintenance_date, warranty_months, service_contract_number, energy_class, country_of_origin, maintenance_notes) VALUES (4, 'Холодильная витрина Carboma R800', 1, 92000.00, 'R800', 'Carboma', 'CB-R800-004', 2025, 'LEASED', 'Холодильная витрина увеличенного объема', 'REFRIGERATOR', '1300x800x2100', 135.00, 1.400, 220, 0, 7, 600.00, 'нержавеющая сталь', NULL, NULL, NULL, NULL, 24, NULL, 'A+', 'Россия', NULL);
INSERT INTO public.equipment (id, name, category_id, price, model, manufacturer, serial_number, year_of_manufacture, status, description, equipment_type, dimensions, weight, power_consumption, voltage, min_temperature, max_temperature, volume, body_material, installation_address, installation_date, next_maintenance_date, last_maintenance_date, warranty_months, service_contract_number, energy_class, country_of_origin, maintenance_notes) VALUES (5, 'Морозильный ларь Italfrost CF400', 1, 52000.00, 'CF400', 'Italfrost', 'IF-CF400-005', 2025, 'LEASED', 'Морозильный ларь с изогнутым стеклом', 'FREEZER', '1200x700x900', 68.00, 0.900, 220, -18, -12, 400.00, 'металл', NULL, NULL, NULL, NULL, 36, NULL, 'A+', 'Италия', NULL);
INSERT INTO public.equipment (id, name, category_id, price, model, manufacturer, serial_number, year_of_manufacture, status, description, equipment_type, dimensions, weight, power_consumption, voltage, min_temperature, max_temperature, volume, body_material, installation_address, installation_date, next_maintenance_date, last_maintenance_date, warranty_months, service_contract_number, energy_class, country_of_origin, maintenance_notes) VALUES (6, 'Холодильный шкаф Polair CM110-S', 1, 135000.00, 'CM110-S', 'Polair', 'PL-CM110-006', 2026, 'LEASED', 'Холодильный шкаф премиум класса', 'REFRIGERATOR', '700x700x2100', 95.00, 1.600, 220, 0, 8, 600.00, 'нержавеющая сталь', NULL, NULL, NULL, NULL, 36, NULL, 'A++', 'Россия', NULL);
INSERT INTO public.equipment (id, name, category_id, price, model, manufacturer, serial_number, year_of_manufacture, status, description, equipment_type, dimensions, weight, power_consumption, voltage, min_temperature, max_temperature, volume, body_material, installation_address, installation_date, next_maintenance_date, last_maintenance_date, warranty_months, service_contract_number, energy_class, country_of_origin, maintenance_notes) VALUES (8, 'Холодильная витрина Cryspi Gamma-2', 1, 98000.00, 'Gamma-2', 'Cryspi', 'CR-GAM2-008', 2026, 'LEASED', 'Холодильная витрина с LED-подсветкой', 'REFRIGERATOR', '1400x800x2050', 140.00, 1.500, 220, 0, 7, 550.00, 'нержавеющая сталь', NULL, NULL, NULL, NULL, 24, NULL, 'A+', 'Россия', NULL);
INSERT INTO public.equipment (id, name, category_id, price, model, manufacturer, serial_number, year_of_manufacture, status, description, equipment_type, dimensions, weight, power_consumption, voltage, min_temperature, max_temperature, volume, body_material, installation_address, installation_date, next_maintenance_date, last_maintenance_date, warranty_months, service_contract_number, energy_class, country_of_origin, maintenance_notes) VALUES (9, 'Витрина кондитерская Илеть ВВК-1,5', 2, 95000.00, 'ВВК-1,5', 'Илеть', 'IL-VVK15-016', 2026, 'LEASED', 'Витрина для кондитерских изделий', 'SHOWCASE', '1500x800x1200', 180.00, 1.800, 220, 2, 8, 300.00, 'стекло/металл', NULL, NULL, NULL, NULL, 12, NULL, 'A', 'Россия', NULL);
INSERT INTO public.equipment (id, name, category_id, price, model, manufacturer, serial_number, year_of_manufacture, status, description, equipment_type, dimensions, weight, power_consumption, voltage, min_temperature, max_temperature, volume, body_material, installation_address, installation_date, next_maintenance_date, last_maintenance_date, warranty_months, service_contract_number, energy_class, country_of_origin, maintenance_notes) VALUES (10, 'Горка холодильная Carboma G110', 2, 150000.00, 'G110', 'Carboma', 'CB-G110-017', 2026, 'LEASED', 'Холодильная горка для супермаркетов', 'COOLER', '1100x900x1950', 250.00, 2.500, 220, 0, 6, 800.00, 'нержавеющая сталь', NULL, NULL, NULL, NULL, 24, NULL, 'A+', 'Россия', NULL);


--
-- Data for Name: equipment_incidents; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.equipment_incidents (id, equipment_id, contract_id, incident_type, incident_date, description, responsible_party, estimated_cost, actual_cost, status, resolution_notes, resolved_date, police_report_number, insurance_claim_number, compensation_amount, reported_by, resolved_by) VALUES (1, 1, 1, 'BREAKDOWN', '2026-03-15 14:30:00', 'Отказ компрессора, холодильная витрина не охлаждает. Температура поднялась до +15°C', 'LESSOR', 15000.00, 14500.00, 'RESOLVED', 'Заменен компрессор, проведена диагностика системы охлаждения. Оборудование работает в штатном режиме', '2026-03-18 16:00:00', NULL, NULL, NULL, 2, 3);
INSERT INTO public.equipment_incidents (id, equipment_id, contract_id, incident_type, incident_date, description, responsible_party, estimated_cost, actual_cost, status, resolution_notes, resolved_date, police_report_number, insurance_claim_number, compensation_amount, reported_by, resolved_by) VALUES (2, 12, 8, 'DAMAGE', '2026-04-20 10:15:00', 'Разбито стекло витрины при разгрузке товара. Трещина 30см, требуется замена стеклопакета', 'LESSEE', 8000.00, NULL, 'IN_REPAIR', 'Заказано новое стекло, ожидается поставка. Клиент оплачивает ремонт', NULL, NULL, NULL, NULL, 3, NULL);
INSERT INTO public.equipment_incidents (id, equipment_id, contract_id, incident_type, incident_date, description, responsible_party, estimated_cost, actual_cost, status, resolution_notes, resolved_date, police_report_number, insurance_claim_number, compensation_amount, reported_by, resolved_by) VALUES (3, 17, 7, 'THEFT', '2026-04-25 22:00:00', 'Кража кассового аппарата из торговой точки. Взлом помещения в ночное время', 'UNDER_INVESTIGATION', 29400.00, NULL, 'UNDER_INVESTIGATION', 'Подано заявление в полицию, ведется расследование. Страховая компания уведомлена', NULL, NULL, NULL, NULL, 2, NULL);
INSERT INTO public.equipment_incidents (id, equipment_id, contract_id, incident_type, incident_date, description, responsible_party, estimated_cost, actual_cost, status, resolution_notes, resolved_date, police_report_number, insurance_claim_number, compensation_amount, reported_by, resolved_by) VALUES (4, 24, 9, 'BREAKDOWN', '2026-04-10 11:00:00', 'Не работает дисплей весов, не печатаются этикетки', 'LESSOR', 2500.00, 2200.00, 'RESOLVED', 'Заменен дисплей и термопринтер. Проведена калибровка', '2026-04-12 15:00:00', NULL, NULL, NULL, 4, 2);
INSERT INTO public.equipment_incidents (id, equipment_id, contract_id, incident_type, incident_date, description, responsible_party, estimated_cost, actual_cost, status, resolution_notes, resolved_date, police_report_number, insurance_claim_number, compensation_amount, reported_by, resolved_by) VALUES (5, 2, 2, 'DAMAGE', '2026-03-20 16:45:00', 'Вмятина на корпусе морозильного ларя, повреждена изоляция. Произошло при транспортировке', 'LESSOR', 5000.00, 4800.00, 'RESOLVED', 'Восстановлена изоляция, выправлен корпус. Функциональность не нарушена', '2026-03-22 14:00:00', NULL, NULL, NULL, 2, 3);
INSERT INTO public.equipment_incidents (id, equipment_id, contract_id, incident_type, incident_date, description, responsible_party, estimated_cost, actual_cost, status, resolution_notes, resolved_date, police_report_number, insurance_claim_number, compensation_amount, reported_by, resolved_by) VALUES (6, 18, 6, 'FORCE_MAJEURE', '2026-04-28 03:00:00', 'Затопление помещения из-за прорыва трубы. POS-система залита водой, не включается', 'FORCE_MAJEURE', 72800.00, NULL, 'UNDER_INVESTIGATION', 'Оборудование на экспертизе. Оформляется страховой случай', NULL, NULL, NULL, NULL, 3, NULL);
INSERT INTO public.equipment_incidents (id, equipment_id, contract_id, incident_type, incident_date, description, responsible_party, estimated_cost, actual_cost, status, resolution_notes, resolved_date, police_report_number, insurance_claim_number, compensation_amount, reported_by, resolved_by) VALUES (7, 3, 3, 'BREAKDOWN', '2026-05-01 09:30:00', 'Шумная работа компрессора, периодические отключения. Требуется диагностика', 'LESSOR', 8000.00, NULL, 'REPAIR_SCHEDULED', 'Запланирован выезд сервисной службы на 2026-05-08', NULL, NULL, NULL, NULL, 2, NULL);
INSERT INTO public.equipment_incidents (id, equipment_id, contract_id, incident_type, incident_date, description, responsible_party, estimated_cost, actual_cost, status, resolution_notes, resolved_date, police_report_number, insurance_claim_number, compensation_amount, reported_by, resolved_by) VALUES (8, 4, 4, 'LOSS', '2026-02-20 18:00:00', 'Утрата комплектующих (2 полки, решетка) при переезде клиента на новую точку', 'LESSEE', 3500.00, 3500.00, 'CLOSED', 'Клиент возместил стоимость утраченных комплектующих. Заказаны новые детали', '2026-02-25 12:00:00', NULL, NULL, NULL, 2, 2);


--
-- Data for Name: flyway_schema_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.flyway_schema_history (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) VALUES (1, '1.0', 'initial schema', 'SQL', 'V1.0__initial_schema.sql', -2057399525, 'postgres', '2026-05-02 21:08:21.915848', 20, true);
INSERT INTO public.flyway_schema_history (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) VALUES (2, '1.1', 'add indexes', 'SQL', 'V1.1__add_indexes.sql', -1735604371, 'postgres', '2026-05-02 21:08:21.964496', 10, true);
INSERT INTO public.flyway_schema_history (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) VALUES (3, '1.2', 'seed data', 'SQL', 'V1.2__seed_data.sql', 1490620018, 'postgres', '2026-05-02 21:08:56.695848', 12, true);
INSERT INTO public.flyway_schema_history (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) VALUES (4, '1.3', 'add client fields', 'SQL', 'V1.3__add_client_fields.sql', NULL, 'postgres', '2026-05-02 21:09:45.111353', 0, true);


--
-- Data for Name: payment_schedules; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (1, 1, 1, '2026-03-01', 2833.33, 2125.00, 708.33, 'PAID');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (2, 1, 2, '2026-04-01', 2833.33, 2125.00, 708.33, 'PAID');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (3, 1, 3, '2026-05-01', 2833.33, 2125.00, 708.33, 'PAID');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (4, 1, 4, '2026-06-01', 2833.33, 2125.00, 708.33, 'OVERDUE');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (5, 1, 5, '2026-07-01', 2833.33, 2125.00, 708.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (6, 1, 6, '2026-08-01', 2833.33, 2125.00, 708.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (7, 1, 7, '2026-09-01', 2833.33, 2125.00, 708.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (8, 1, 8, '2026-10-01', 2833.33, 2125.00, 708.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (9, 1, 9, '2026-11-01', 2833.33, 2125.00, 708.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (10, 1, 10, '2026-12-01', 2833.33, 2125.00, 708.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (11, 1, 11, '2027-01-01', 2833.33, 2125.00, 708.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (12, 1, 12, '2027-02-01', 2833.33, 2125.00, 708.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (13, 1, 13, '2027-03-01', 2833.33, 2125.00, 708.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (14, 1, 14, '2027-04-01', 2833.33, 2125.00, 708.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (15, 1, 15, '2027-05-01', 2833.33, 2125.00, 708.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (16, 1, 16, '2027-06-01', 2833.33, 2125.00, 708.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (17, 1, 17, '2027-07-01', 2833.33, 2125.00, 708.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (18, 1, 18, '2027-08-01', 2833.33, 2125.00, 708.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (19, 1, 19, '2027-09-01', 2833.33, 2125.00, 708.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (20, 1, 20, '2027-10-01', 2833.33, 2125.00, 708.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (21, 1, 21, '2027-11-01', 2833.33, 2125.00, 708.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (22, 1, 22, '2027-12-01', 2833.33, 2125.00, 708.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (23, 1, 23, '2028-01-01', 2833.33, 2125.00, 708.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (24, 1, 24, '2028-02-01', 2833.33, 2125.00, 708.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (25, 1, 25, '2028-03-01', 2833.33, 2125.00, 708.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (26, 1, 26, '2028-04-01', 2833.33, 2125.00, 708.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (27, 1, 27, '2028-05-01', 2833.33, 2125.00, 708.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (28, 1, 28, '2028-06-01', 2833.33, 2125.00, 708.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (29, 1, 29, '2028-07-01', 2833.33, 2125.00, 708.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (30, 1, 30, '2028-08-01', 2833.33, 2125.00, 708.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (31, 1, 31, '2028-09-01', 2833.33, 2125.00, 708.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (32, 1, 32, '2028-10-01', 2833.33, 2125.00, 708.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (33, 1, 33, '2028-11-01', 2833.33, 2125.00, 708.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (34, 1, 34, '2028-12-01', 2833.33, 2125.00, 708.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (35, 1, 35, '2029-01-01', 2833.33, 2125.00, 708.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (36, 1, 36, '2029-02-01', 2833.33, 2125.00, 708.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (37, 2, 1, '2026-03-15', 1500.00, 1095.00, 405.00, 'PAID');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (38, 2, 2, '2026-04-15', 1500.00, 1095.00, 405.00, 'PAID');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (39, 2, 3, '2026-05-15', 1500.00, 1095.00, 405.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (40, 2, 4, '2026-06-15', 1500.00, 1095.00, 405.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (41, 2, 5, '2026-07-15', 1500.00, 1095.00, 405.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (42, 2, 6, '2026-08-15', 1500.00, 1095.00, 405.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (43, 2, 7, '2026-09-15', 1500.00, 1095.00, 405.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (44, 2, 8, '2026-10-15', 1500.00, 1095.00, 405.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (45, 2, 9, '2026-11-15', 1500.00, 1095.00, 405.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (46, 2, 10, '2026-12-15', 1500.00, 1095.00, 405.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (47, 2, 11, '2027-01-15', 1500.00, 1095.00, 405.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (48, 2, 12, '2027-02-15', 1500.00, 1095.00, 405.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (49, 2, 13, '2027-03-15', 1500.00, 1095.00, 405.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (50, 2, 14, '2027-04-15', 1500.00, 1095.00, 405.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (51, 2, 15, '2027-05-15', 1500.00, 1095.00, 405.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (52, 2, 16, '2027-06-15', 1500.00, 1095.00, 405.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (53, 2, 17, '2027-07-15', 1500.00, 1095.00, 405.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (54, 2, 18, '2027-08-15', 1500.00, 1095.00, 405.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (55, 2, 19, '2027-09-15', 1500.00, 1095.00, 405.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (56, 2, 20, '2027-10-15', 1500.00, 1095.00, 405.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (57, 2, 21, '2027-11-15', 1500.00, 1095.00, 405.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (58, 2, 22, '2027-12-15', 1500.00, 1095.00, 405.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (59, 2, 23, '2028-01-15', 1500.00, 1095.00, 405.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (60, 2, 24, '2028-02-15', 1500.00, 1095.00, 405.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (61, 2, 25, '2028-03-15', 1500.00, 1095.00, 405.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (62, 2, 26, '2028-04-15', 1500.00, 1095.00, 405.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (63, 2, 27, '2028-05-15', 1500.00, 1095.00, 405.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (64, 2, 28, '2028-06-15', 1500.00, 1095.00, 405.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (65, 2, 29, '2028-07-15', 1500.00, 1095.00, 405.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (66, 2, 30, '2028-08-15', 1500.00, 1095.00, 405.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (67, 2, 31, '2028-09-15', 1500.00, 1095.00, 405.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (68, 2, 32, '2028-10-15', 1500.00, 1095.00, 405.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (69, 2, 33, '2028-11-15', 1500.00, 1095.00, 405.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (70, 2, 34, '2028-12-15', 1500.00, 1095.00, 405.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (71, 2, 35, '2029-01-15', 1500.00, 1095.00, 405.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (72, 2, 36, '2029-02-15', 1500.00, 1095.00, 405.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (73, 3, 1, '2026-04-01', 5600.00, 4368.00, 1232.00, 'PAID');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (74, 3, 2, '2026-05-01', 5600.00, 4368.00, 1232.00, 'PAID');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (75, 3, 3, '2026-06-01', 5600.00, 4368.00, 1232.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (76, 3, 4, '2026-07-01', 5600.00, 4368.00, 1232.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (77, 3, 5, '2026-08-01', 5600.00, 4368.00, 1232.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (78, 3, 6, '2026-09-01', 5600.00, 4368.00, 1232.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (79, 3, 7, '2026-10-01', 5600.00, 4368.00, 1232.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (80, 3, 8, '2026-11-01', 5600.00, 4368.00, 1232.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (81, 3, 9, '2026-12-01', 5600.00, 4368.00, 1232.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (82, 3, 10, '2027-01-01', 5600.00, 4368.00, 1232.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (83, 3, 11, '2027-02-01', 5600.00, 4368.00, 1232.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (84, 3, 12, '2027-03-01', 5600.00, 4368.00, 1232.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (85, 3, 13, '2027-04-01', 5600.00, 4368.00, 1232.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (86, 3, 14, '2027-05-01', 5600.00, 4368.00, 1232.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (87, 3, 15, '2027-06-01', 5600.00, 4368.00, 1232.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (88, 3, 16, '2027-07-01', 5600.00, 4368.00, 1232.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (89, 3, 17, '2027-08-01', 5600.00, 4368.00, 1232.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (90, 3, 18, '2027-09-01', 5600.00, 4368.00, 1232.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (91, 3, 19, '2027-10-01', 5600.00, 4368.00, 1232.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (92, 3, 20, '2027-11-01', 5600.00, 4368.00, 1232.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (93, 3, 21, '2027-12-01', 5600.00, 4368.00, 1232.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (94, 3, 22, '2028-01-01', 5600.00, 4368.00, 1232.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (95, 3, 23, '2028-02-01', 5600.00, 4368.00, 1232.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (96, 3, 24, '2028-03-01', 5600.00, 4368.00, 1232.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (97, 4, 1, '2026-04-15', 5000.00, 3800.00, 1200.00, 'PAID');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (98, 4, 2, '2026-05-15', 5000.00, 3800.00, 1200.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (99, 4, 3, '2026-06-15', 5000.00, 3800.00, 1200.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (100, 4, 4, '2026-07-15', 5000.00, 3800.00, 1200.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (101, 4, 5, '2026-08-15', 5000.00, 3800.00, 1200.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (102, 4, 6, '2026-09-15', 5000.00, 3800.00, 1200.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (103, 4, 7, '2026-10-15', 5000.00, 3800.00, 1200.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (104, 4, 8, '2026-11-15', 5000.00, 3800.00, 1200.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (105, 4, 9, '2026-12-15', 5000.00, 3800.00, 1200.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (106, 4, 10, '2027-01-15', 5000.00, 3800.00, 1200.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (107, 4, 11, '2027-02-15', 5000.00, 3800.00, 1200.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (108, 4, 12, '2027-03-15', 5000.00, 3800.00, 1200.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (109, 4, 13, '2027-04-15', 5000.00, 3800.00, 1200.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (110, 4, 14, '2027-05-15', 5000.00, 3800.00, 1200.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (111, 4, 15, '2027-06-15', 5000.00, 3800.00, 1200.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (112, 4, 16, '2027-07-15', 5000.00, 3800.00, 1200.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (113, 4, 17, '2027-08-15', 5000.00, 3800.00, 1200.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (114, 4, 18, '2027-09-15', 5000.00, 3800.00, 1200.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (115, 4, 19, '2027-10-15', 5000.00, 3800.00, 1200.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (116, 4, 20, '2027-11-15', 5000.00, 3800.00, 1200.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (117, 4, 21, '2027-12-15', 5000.00, 3800.00, 1200.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (118, 4, 22, '2028-01-15', 5000.00, 3800.00, 1200.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (119, 4, 23, '2028-02-15', 5000.00, 3800.00, 1200.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (120, 4, 24, '2028-03-15', 5000.00, 3800.00, 1200.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (121, 4, 25, '2028-04-15', 5000.00, 3800.00, 1200.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (122, 4, 26, '2028-05-15', 5000.00, 3800.00, 1200.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (123, 4, 27, '2028-06-15', 5000.00, 3800.00, 1200.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (124, 4, 28, '2028-07-15', 5000.00, 3800.00, 1200.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (125, 4, 29, '2028-08-15', 5000.00, 3800.00, 1200.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (126, 4, 30, '2028-09-15', 5000.00, 3800.00, 1200.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (127, 4, 31, '2028-10-15', 5000.00, 3800.00, 1200.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (128, 4, 32, '2028-11-15', 5000.00, 3800.00, 1200.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (129, 4, 33, '2028-12-15', 5000.00, 3800.00, 1200.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (130, 4, 34, '2029-01-15', 5000.00, 3800.00, 1200.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (131, 4, 35, '2029-02-15', 5000.00, 3800.00, 1200.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (132, 4, 36, '2029-03-15', 5000.00, 3800.00, 1200.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (133, 5, 1, '2026-04-20', 2100.00, 1512.00, 588.00, 'PAID');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (134, 5, 2, '2026-05-20', 2100.00, 1512.00, 588.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (135, 5, 3, '2026-06-20', 2100.00, 1512.00, 588.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (136, 5, 4, '2026-07-20', 2100.00, 1512.00, 588.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (137, 5, 5, '2026-08-20', 2100.00, 1512.00, 588.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (138, 5, 6, '2026-09-20', 2100.00, 1512.00, 588.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (139, 5, 7, '2026-10-20', 2100.00, 1512.00, 588.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (140, 5, 8, '2026-11-20', 2100.00, 1512.00, 588.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (141, 5, 9, '2026-12-20', 2100.00, 1512.00, 588.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (142, 5, 10, '2027-01-20', 2100.00, 1512.00, 588.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (143, 5, 11, '2027-02-20', 2100.00, 1512.00, 588.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (144, 5, 12, '2027-03-20', 2100.00, 1512.00, 588.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (145, 5, 13, '2027-04-20', 2100.00, 1512.00, 588.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (146, 5, 14, '2027-05-20', 2100.00, 1512.00, 588.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (147, 5, 15, '2027-06-20', 2100.00, 1512.00, 588.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (148, 5, 16, '2027-07-20', 2100.00, 1512.00, 588.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (149, 5, 17, '2027-08-20', 2100.00, 1512.00, 588.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (150, 5, 18, '2027-09-20', 2100.00, 1512.00, 588.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (151, 5, 19, '2027-10-20', 2100.00, 1512.00, 588.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (152, 5, 20, '2027-11-20', 2100.00, 1512.00, 588.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (153, 5, 21, '2027-12-20', 2100.00, 1512.00, 588.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (154, 5, 22, '2028-01-20', 2100.00, 1512.00, 588.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (155, 5, 23, '2028-02-20', 2100.00, 1512.00, 588.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (156, 5, 24, '2028-03-20', 2100.00, 1512.00, 588.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (157, 6, 1, '2026-05-01', 3033.33, 2335.66, 697.67, 'PAID');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (158, 6, 2, '2026-06-01', 3033.33, 2335.66, 697.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (159, 6, 3, '2026-07-01', 3033.33, 2335.66, 697.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (160, 6, 4, '2026-08-01', 3033.33, 2335.66, 697.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (161, 6, 5, '2026-09-01', 3033.33, 2335.66, 697.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (162, 6, 6, '2026-10-01', 3033.33, 2335.66, 697.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (163, 6, 7, '2026-11-01', 3033.33, 2335.66, 697.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (164, 6, 8, '2026-12-01', 3033.33, 2335.66, 697.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (165, 6, 9, '2027-01-01', 3033.33, 2335.66, 697.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (166, 6, 10, '2027-02-01', 3033.33, 2335.66, 697.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (167, 6, 11, '2027-03-01', 3033.33, 2335.66, 697.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (168, 6, 12, '2027-04-01', 3033.33, 2335.66, 697.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (169, 6, 13, '2027-05-01', 3033.33, 2335.66, 697.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (170, 6, 14, '2027-06-01', 3033.33, 2335.66, 697.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (171, 6, 15, '2027-07-01', 3033.33, 2335.66, 697.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (172, 6, 16, '2027-08-01', 3033.33, 2335.66, 697.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (173, 6, 17, '2027-09-01', 3033.33, 2335.66, 697.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (174, 6, 18, '2027-10-01', 3033.33, 2335.66, 697.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (175, 6, 19, '2027-11-01', 3033.33, 2335.66, 697.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (176, 6, 20, '2027-12-01', 3033.33, 2335.66, 697.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (177, 6, 21, '2028-01-01', 3033.33, 2335.66, 697.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (178, 6, 22, '2028-02-01', 3033.33, 2335.66, 697.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (179, 6, 23, '2028-03-01', 3033.33, 2335.66, 697.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (180, 6, 24, '2028-04-01', 3033.33, 2335.66, 697.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (181, 7, 1, '2026-05-10', 2450.00, 1715.00, 735.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (182, 7, 2, '2026-06-10', 2450.00, 1715.00, 735.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (183, 7, 3, '2026-07-10', 2450.00, 1715.00, 735.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (184, 7, 4, '2026-08-10', 2450.00, 1715.00, 735.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (185, 7, 5, '2026-09-10', 2450.00, 1715.00, 735.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (186, 7, 6, '2026-10-10', 2450.00, 1715.00, 735.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (187, 7, 7, '2026-11-10', 2450.00, 1715.00, 735.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (188, 7, 8, '2026-12-10', 2450.00, 1715.00, 735.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (189, 7, 9, '2027-01-10', 2450.00, 1715.00, 735.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (190, 7, 10, '2027-02-10', 2450.00, 1715.00, 735.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (191, 7, 11, '2027-03-10', 2450.00, 1715.00, 735.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (192, 7, 12, '2027-04-10', 2450.00, 1715.00, 735.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (193, 8, 1, '2026-05-15', 5833.33, 4550.00, 1283.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (194, 8, 2, '2026-06-15', 5833.33, 4550.00, 1283.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (195, 8, 3, '2026-07-15', 5833.33, 4550.00, 1283.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (196, 8, 4, '2026-08-15', 5833.33, 4550.00, 1283.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (197, 8, 5, '2026-09-15', 5833.33, 4550.00, 1283.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (198, 8, 6, '2026-10-15', 5833.33, 4550.00, 1283.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (199, 8, 7, '2026-11-15', 5833.33, 4550.00, 1283.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (200, 8, 8, '2026-12-15', 5833.33, 4550.00, 1283.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (201, 8, 9, '2027-01-15', 5833.33, 4550.00, 1283.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (202, 8, 10, '2027-02-15', 5833.33, 4550.00, 1283.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (203, 8, 11, '2027-03-15', 5833.33, 4550.00, 1283.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (204, 8, 12, '2027-04-15', 5833.33, 4550.00, 1283.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (205, 8, 13, '2027-05-15', 5833.33, 4550.00, 1283.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (206, 8, 14, '2027-06-15', 5833.33, 4550.00, 1283.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (207, 8, 15, '2027-07-15', 5833.33, 4550.00, 1283.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (208, 8, 16, '2027-08-15', 5833.33, 4550.00, 1283.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (209, 8, 17, '2027-09-15', 5833.33, 4550.00, 1283.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (210, 8, 18, '2027-10-15', 5833.33, 4550.00, 1283.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (211, 8, 19, '2027-11-15', 5833.33, 4550.00, 1283.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (212, 8, 20, '2027-12-15', 5833.33, 4550.00, 1283.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (213, 8, 21, '2028-01-15', 5833.33, 4550.00, 1283.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (214, 8, 22, '2028-02-15', 5833.33, 4550.00, 1283.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (215, 8, 23, '2028-03-15', 5833.33, 4550.00, 1283.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (216, 8, 24, '2028-04-15', 5833.33, 4550.00, 1283.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (217, 8, 25, '2028-05-15', 5833.33, 4550.00, 1283.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (218, 8, 26, '2028-06-15', 5833.33, 4550.00, 1283.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (219, 8, 27, '2028-07-15', 5833.33, 4550.00, 1283.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (220, 8, 28, '2028-08-15', 5833.33, 4550.00, 1283.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (221, 8, 29, '2028-09-15', 5833.33, 4550.00, 1283.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (222, 8, 30, '2028-10-15', 5833.33, 4550.00, 1283.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (223, 8, 31, '2028-11-15', 5833.33, 4550.00, 1283.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (224, 8, 32, '2028-12-15', 5833.33, 4550.00, 1283.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (225, 8, 33, '2029-01-15', 5833.33, 4550.00, 1283.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (226, 8, 34, '2029-02-15', 5833.33, 4550.00, 1283.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (227, 8, 35, '2029-03-15', 5833.33, 4550.00, 1283.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (228, 8, 36, '2029-04-15', 5833.33, 4550.00, 1283.33, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (229, 9, 1, '2026-05-20', 1050.00, 724.50, 325.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (230, 9, 2, '2026-06-20', 1050.00, 724.50, 325.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (231, 9, 3, '2026-07-20', 1050.00, 724.50, 325.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (232, 9, 4, '2026-08-20', 1050.00, 724.50, 325.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (233, 9, 5, '2026-09-20', 1050.00, 724.50, 325.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (234, 9, 6, '2026-10-20', 1050.00, 724.50, 325.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (235, 9, 7, '2026-11-20', 1050.00, 724.50, 325.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (236, 9, 8, '2026-12-20', 1050.00, 724.50, 325.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (237, 9, 9, '2027-01-20', 1050.00, 724.50, 325.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (238, 9, 10, '2027-02-20', 1050.00, 724.50, 325.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (239, 9, 11, '2027-03-20', 1050.00, 724.50, 325.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (240, 9, 12, '2027-04-20', 1050.00, 724.50, 325.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (241, 10, 1, '2026-05-25', 4433.33, 3369.33, 1064.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (242, 10, 2, '2026-06-25', 4433.33, 3369.33, 1064.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (243, 10, 3, '2026-07-25', 4433.33, 3369.33, 1064.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (244, 10, 4, '2026-08-25', 4433.33, 3369.33, 1064.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (245, 10, 5, '2026-09-25', 4433.33, 3369.33, 1064.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (246, 10, 6, '2026-10-25', 4433.33, 3369.33, 1064.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (247, 10, 7, '2026-11-25', 4433.33, 3369.33, 1064.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (248, 10, 8, '2026-12-25', 4433.33, 3369.33, 1064.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (249, 10, 9, '2027-01-25', 4433.33, 3369.33, 1064.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (250, 10, 10, '2027-02-25', 4433.33, 3369.33, 1064.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (251, 10, 11, '2027-03-25', 4433.33, 3369.33, 1064.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (252, 10, 12, '2027-04-25', 4433.33, 3369.33, 1064.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (253, 10, 13, '2027-05-25', 4433.33, 3369.33, 1064.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (254, 10, 14, '2027-06-25', 4433.33, 3369.33, 1064.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (255, 10, 15, '2027-07-25', 4433.33, 3369.33, 1064.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (256, 10, 16, '2027-08-25', 4433.33, 3369.33, 1064.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (257, 10, 17, '2027-09-25', 4433.33, 3369.33, 1064.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (258, 10, 18, '2027-10-25', 4433.33, 3369.33, 1064.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (259, 10, 19, '2027-11-25', 4433.33, 3369.33, 1064.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (260, 10, 20, '2027-12-25', 4433.33, 3369.33, 1064.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (261, 10, 21, '2028-01-25', 4433.33, 3369.33, 1064.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (262, 10, 22, '2028-02-25', 4433.33, 3369.33, 1064.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (263, 10, 23, '2028-03-25', 4433.33, 3369.33, 1064.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (264, 10, 24, '2028-04-25', 4433.33, 3369.33, 1064.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (265, 11, 1, '2026-06-01', 4250.00, 3187.50, 1062.50, 'PAID');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (266, 11, 2, '2026-07-01', 4250.00, 3187.50, 1062.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (267, 11, 3, '2026-08-01', 4250.00, 3187.50, 1062.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (268, 11, 4, '2026-09-01', 4250.00, 3187.50, 1062.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (269, 11, 5, '2026-10-01', 4250.00, 3187.50, 1062.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (270, 11, 6, '2026-11-01', 4250.00, 3187.50, 1062.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (271, 11, 7, '2026-12-01', 4250.00, 3187.50, 1062.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (272, 11, 8, '2027-01-01', 4250.00, 3187.50, 1062.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (273, 11, 9, '2027-02-01', 4250.00, 3187.50, 1062.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (274, 11, 10, '2027-03-01', 4250.00, 3187.50, 1062.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (275, 11, 11, '2027-04-01', 4250.00, 3187.50, 1062.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (276, 11, 12, '2027-05-01', 4250.00, 3187.50, 1062.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (277, 11, 13, '2027-06-01', 4250.00, 3187.50, 1062.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (278, 11, 14, '2027-07-01', 4250.00, 3187.50, 1062.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (279, 11, 15, '2027-08-01', 4250.00, 3187.50, 1062.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (280, 11, 16, '2027-09-01', 4250.00, 3187.50, 1062.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (281, 11, 17, '2027-10-01', 4250.00, 3187.50, 1062.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (282, 11, 18, '2027-11-01', 4250.00, 3187.50, 1062.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (283, 11, 19, '2027-12-01', 4250.00, 3187.50, 1062.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (284, 11, 20, '2028-01-01', 4250.00, 3187.50, 1062.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (285, 11, 21, '2028-02-01', 4250.00, 3187.50, 1062.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (286, 11, 22, '2028-03-01', 4250.00, 3187.50, 1062.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (287, 11, 23, '2028-04-01', 4250.00, 3187.50, 1062.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (288, 11, 24, '2028-05-01', 4250.00, 3187.50, 1062.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (289, 12, 1, '2026-05-25', 2250.00, 1687.50, 562.50, 'PAID');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (290, 12, 2, '2026-06-25', 2250.00, 1687.50, 562.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (291, 12, 3, '2026-07-25', 2250.00, 1687.50, 562.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (292, 12, 4, '2026-08-25', 2250.00, 1687.50, 562.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (293, 12, 5, '2026-09-25', 2250.00, 1687.50, 562.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (294, 12, 6, '2026-10-25', 2250.00, 1687.50, 562.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (295, 12, 7, '2026-11-25', 2250.00, 1687.50, 562.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (296, 12, 8, '2026-12-25', 2250.00, 1687.50, 562.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (297, 12, 9, '2027-01-25', 2250.00, 1687.50, 562.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (298, 12, 10, '2027-02-25', 2250.00, 1687.50, 562.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (299, 12, 11, '2027-03-25', 2250.00, 1687.50, 562.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (300, 12, 12, '2027-04-25', 2250.00, 1687.50, 562.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (301, 12, 13, '2027-05-25', 2250.00, 1687.50, 562.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (302, 12, 14, '2027-06-25', 2250.00, 1687.50, 562.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (303, 12, 15, '2027-07-25', 2250.00, 1687.50, 562.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (304, 12, 16, '2027-08-25', 2250.00, 1687.50, 562.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (305, 12, 17, '2027-09-25', 2250.00, 1687.50, 562.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (306, 12, 18, '2027-10-25', 2250.00, 1687.50, 562.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (307, 12, 19, '2027-11-25', 2250.00, 1687.50, 562.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (308, 12, 20, '2027-12-25', 2250.00, 1687.50, 562.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (309, 12, 21, '2028-01-25', 2250.00, 1687.50, 562.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (310, 12, 22, '2028-02-25', 2250.00, 1687.50, 562.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (311, 12, 23, '2028-03-25', 2250.00, 1687.50, 562.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (312, 12, 24, '2028-04-25', 2250.00, 1687.50, 562.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (313, 13, 1, '2026-05-20', 11200.00, 8400.00, 2800.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (314, 13, 2, '2026-06-20', 11200.00, 8400.00, 2800.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (315, 13, 3, '2026-07-20', 11200.00, 8400.00, 2800.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (316, 13, 4, '2026-08-20', 11200.00, 8400.00, 2800.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (317, 13, 5, '2026-09-20', 11200.00, 8400.00, 2800.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (318, 13, 6, '2026-10-20', 11200.00, 8400.00, 2800.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (319, 13, 7, '2026-11-20', 11200.00, 8400.00, 2800.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (320, 13, 8, '2026-12-20', 11200.00, 8400.00, 2800.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (321, 13, 9, '2027-01-20', 11200.00, 8400.00, 2800.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (322, 13, 10, '2027-02-20', 11200.00, 8400.00, 2800.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (323, 13, 11, '2027-03-20', 11200.00, 8400.00, 2800.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (324, 13, 12, '2027-04-20', 11200.00, 8400.00, 2800.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (325, 14, 1, '2026-05-15', 4666.67, 3500.00, 1166.67, 'PAID');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (326, 14, 2, '2026-06-15', 4666.67, 3500.00, 1166.67, 'PAID');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (327, 14, 3, '2026-07-15', 4666.67, 3500.00, 1166.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (328, 14, 4, '2026-08-15', 4666.67, 3500.00, 1166.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (329, 14, 5, '2026-09-15', 4666.67, 3500.00, 1166.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (330, 14, 6, '2026-10-15', 4666.67, 3500.00, 1166.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (331, 14, 7, '2026-11-15', 4666.67, 3500.00, 1166.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (332, 14, 8, '2026-12-15', 4666.67, 3500.00, 1166.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (333, 14, 9, '2027-01-15', 4666.67, 3500.00, 1166.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (334, 14, 10, '2027-02-15', 4666.67, 3500.00, 1166.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (335, 14, 11, '2027-03-15', 4666.67, 3500.00, 1166.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (336, 14, 12, '2027-04-15', 4666.67, 3500.00, 1166.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (337, 14, 13, '2027-05-15', 4666.67, 3500.00, 1166.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (338, 14, 14, '2027-06-15', 4666.67, 3500.00, 1166.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (339, 14, 15, '2027-07-15', 4666.67, 3500.00, 1166.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (340, 14, 16, '2027-08-15', 4666.67, 3500.00, 1166.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (341, 14, 17, '2027-09-15', 4666.67, 3500.00, 1166.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (342, 14, 18, '2027-10-15', 4666.67, 3500.00, 1166.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (343, 14, 19, '2027-11-15', 4666.67, 3500.00, 1166.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (344, 14, 20, '2027-12-15', 4666.67, 3500.00, 1166.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (345, 14, 21, '2028-01-15', 4666.67, 3500.00, 1166.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (346, 14, 22, '2028-02-15', 4666.67, 3500.00, 1166.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (347, 14, 23, '2028-03-15', 4666.67, 3500.00, 1166.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (348, 14, 24, '2028-04-15', 4666.67, 3500.00, 1166.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (349, 14, 25, '2028-05-15', 4666.67, 3500.00, 1166.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (350, 14, 26, '2028-06-15', 4666.67, 3500.00, 1166.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (351, 14, 27, '2028-07-15', 4666.67, 3500.00, 1166.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (352, 14, 28, '2028-08-15', 4666.67, 3500.00, 1166.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (353, 14, 29, '2028-09-15', 4666.67, 3500.00, 1166.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (354, 14, 30, '2028-10-15', 4666.67, 3500.00, 1166.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (355, 14, 31, '2028-11-15', 4666.67, 3500.00, 1166.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (356, 14, 32, '2028-12-15', 4666.67, 3500.00, 1166.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (357, 14, 33, '2029-01-15', 4666.67, 3500.00, 1166.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (358, 14, 34, '2029-02-15', 4666.67, 3500.00, 1166.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (359, 14, 35, '2029-03-15', 4666.67, 3500.00, 1166.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (360, 14, 36, '2029-04-15', 4666.67, 3500.00, 1166.67, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (361, 15, 1, '2026-05-10', 17500.00, 13125.00, 4375.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (362, 15, 2, '2026-06-10', 17500.00, 13125.00, 4375.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (363, 15, 3, '2026-07-10', 17500.00, 13125.00, 4375.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (364, 15, 4, '2026-08-10', 17500.00, 13125.00, 4375.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (365, 15, 5, '2026-09-10', 17500.00, 13125.00, 4375.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (366, 15, 6, '2026-10-10', 17500.00, 13125.00, 4375.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (367, 15, 7, '2026-11-10', 17500.00, 13125.00, 4375.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (368, 15, 8, '2026-12-10', 17500.00, 13125.00, 4375.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (369, 15, 9, '2027-01-10', 17500.00, 13125.00, 4375.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (370, 15, 10, '2027-02-10', 17500.00, 13125.00, 4375.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (371, 15, 11, '2027-03-10', 17500.00, 13125.00, 4375.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (372, 15, 12, '2027-04-10', 17500.00, 13125.00, 4375.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (373, 16, 1, '2026-05-05', 4900.00, 3675.00, 1225.00, 'PAID');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (374, 16, 2, '2026-06-05', 4900.00, 3675.00, 1225.00, 'OVERDUE');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (375, 16, 3, '2026-07-05', 4900.00, 3675.00, 1225.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (376, 16, 4, '2026-08-05', 4900.00, 3675.00, 1225.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (377, 16, 5, '2026-09-05', 4900.00, 3675.00, 1225.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (378, 16, 6, '2026-10-05', 4900.00, 3675.00, 1225.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (379, 16, 7, '2026-11-05', 4900.00, 3675.00, 1225.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (380, 16, 8, '2026-12-05', 4900.00, 3675.00, 1225.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (381, 16, 9, '2027-01-05', 4900.00, 3675.00, 1225.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (382, 16, 10, '2027-02-05', 4900.00, 3675.00, 1225.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (383, 16, 11, '2027-03-05', 4900.00, 3675.00, 1225.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (384, 16, 12, '2027-04-05', 4900.00, 3675.00, 1225.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (385, 16, 13, '2027-05-05', 4900.00, 3675.00, 1225.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (386, 16, 14, '2027-06-05', 4900.00, 3675.00, 1225.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (387, 16, 15, '2027-07-05', 4900.00, 3675.00, 1225.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (388, 16, 16, '2027-08-05', 4900.00, 3675.00, 1225.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (389, 16, 17, '2027-09-05', 4900.00, 3675.00, 1225.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (390, 16, 18, '2027-10-05', 4900.00, 3675.00, 1225.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (391, 16, 19, '2027-11-05', 4900.00, 3675.00, 1225.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (392, 16, 20, '2027-12-05', 4900.00, 3675.00, 1225.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (393, 16, 21, '2028-01-05', 4900.00, 3675.00, 1225.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (394, 16, 22, '2028-02-05', 4900.00, 3675.00, 1225.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (395, 16, 23, '2028-03-05', 4900.00, 3675.00, 1225.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (396, 16, 24, '2028-04-05', 4900.00, 3675.00, 1225.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (397, 18, 1, '2026-04-25', 3500.00, 2625.00, 875.00, 'PAID');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (398, 18, 2, '2026-05-25', 3500.00, 2625.00, 875.00, 'PAID');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (399, 18, 3, '2026-06-25', 3500.00, 2625.00, 875.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (400, 18, 4, '2026-07-25', 3500.00, 2625.00, 875.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (401, 18, 5, '2026-08-25', 3500.00, 2625.00, 875.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (402, 18, 6, '2026-09-25', 3500.00, 2625.00, 875.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (403, 18, 7, '2026-10-25', 3500.00, 2625.00, 875.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (404, 18, 8, '2026-11-25', 3500.00, 2625.00, 875.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (405, 18, 9, '2026-12-25', 3500.00, 2625.00, 875.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (406, 18, 10, '2027-01-25', 3500.00, 2625.00, 875.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (407, 18, 11, '2027-02-25', 3500.00, 2625.00, 875.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (408, 18, 12, '2027-03-25', 3500.00, 2625.00, 875.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (409, 18, 13, '2027-04-25', 3500.00, 2625.00, 875.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (410, 18, 14, '2027-05-25', 3500.00, 2625.00, 875.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (411, 18, 15, '2027-06-25', 3500.00, 2625.00, 875.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (412, 18, 16, '2027-07-25', 3500.00, 2625.00, 875.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (413, 18, 17, '2027-08-25', 3500.00, 2625.00, 875.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (414, 18, 18, '2027-09-25', 3500.00, 2625.00, 875.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (415, 18, 19, '2027-10-25', 3500.00, 2625.00, 875.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (416, 18, 20, '2027-11-25', 3500.00, 2625.00, 875.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (417, 18, 21, '2027-12-25', 3500.00, 2625.00, 875.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (418, 18, 22, '2028-01-25', 3500.00, 2625.00, 875.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (419, 18, 23, '2028-02-25', 3500.00, 2625.00, 875.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (420, 18, 24, '2028-03-25', 3500.00, 2625.00, 875.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (421, 19, 1, '2026-04-20', 14000.00, 10500.00, 3500.00, 'PAID');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (422, 19, 2, '2026-05-20', 14000.00, 10500.00, 3500.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (423, 19, 3, '2026-06-20', 14000.00, 10500.00, 3500.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (424, 19, 4, '2026-07-20', 14000.00, 10500.00, 3500.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (425, 19, 5, '2026-08-20', 14000.00, 10500.00, 3500.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (426, 19, 6, '2026-09-20', 14000.00, 10500.00, 3500.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (427, 19, 7, '2026-10-20', 14000.00, 10500.00, 3500.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (428, 19, 8, '2026-11-20', 14000.00, 10500.00, 3500.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (429, 19, 9, '2026-12-20', 14000.00, 10500.00, 3500.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (430, 19, 10, '2027-01-20', 14000.00, 10500.00, 3500.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (431, 19, 11, '2027-02-20', 14000.00, 10500.00, 3500.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (432, 19, 12, '2027-03-20', 14000.00, 10500.00, 3500.00, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (433, 20, 1, '2026-04-15', 5250.00, 3937.50, 1312.50, 'PAID');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (434, 20, 2, '2026-05-15', 5250.00, 3937.50, 1312.50, 'OVERDUE');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (435, 20, 3, '2026-06-15', 5250.00, 3937.50, 1312.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (436, 20, 4, '2026-07-15', 5250.00, 3937.50, 1312.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (437, 20, 5, '2026-08-15', 5250.00, 3937.50, 1312.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (438, 20, 6, '2026-09-15', 5250.00, 3937.50, 1312.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (439, 20, 7, '2026-10-15', 5250.00, 3937.50, 1312.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (440, 20, 8, '2026-11-15', 5250.00, 3937.50, 1312.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (441, 20, 9, '2026-12-15', 5250.00, 3937.50, 1312.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (442, 20, 10, '2027-01-15', 5250.00, 3937.50, 1312.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (443, 20, 11, '2027-02-15', 5250.00, 3937.50, 1312.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (444, 20, 12, '2027-03-15', 5250.00, 3937.50, 1312.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (445, 20, 13, '2027-04-15', 5250.00, 3937.50, 1312.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (446, 20, 14, '2027-05-15', 5250.00, 3937.50, 1312.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (447, 20, 15, '2027-06-15', 5250.00, 3937.50, 1312.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (448, 20, 16, '2027-07-15', 5250.00, 3937.50, 1312.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (449, 20, 17, '2027-08-15', 5250.00, 3937.50, 1312.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (450, 20, 18, '2027-09-15', 5250.00, 3937.50, 1312.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (451, 20, 19, '2027-10-15', 5250.00, 3937.50, 1312.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (452, 20, 20, '2027-11-15', 5250.00, 3937.50, 1312.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (453, 20, 21, '2027-12-15', 5250.00, 3937.50, 1312.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (454, 20, 22, '2028-01-15', 5250.00, 3937.50, 1312.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (455, 20, 23, '2028-02-15', 5250.00, 3937.50, 1312.50, 'PENDING');
INSERT INTO public.payment_schedules (id, contract_id, period_number, payment_date, total_amount, principal_part, interest_part, status) VALUES (456, 20, 24, '2028-03-15', 5250.00, 3937.50, 1312.50, 'PENDING');


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.payments (id, schedule_id, contract_id, amount, due_date, paid_date, payment_type, payment_method, status, comment) VALUES (1, 1, 1, 2833.33, '2026-03-01 00:00:00', '2026-03-01 00:00:00', NULL, 'BANK_TRANSFER', 'PAID', 'Платеж за период 1');
INSERT INTO public.payments (id, schedule_id, contract_id, amount, due_date, paid_date, payment_type, payment_method, status, comment) VALUES (2, 2, 1, 2833.33, '2026-04-01 00:00:00', '2026-04-01 00:00:00', NULL, 'BANK_TRANSFER', 'PAID', 'Платеж за период 2');
INSERT INTO public.payments (id, schedule_id, contract_id, amount, due_date, paid_date, payment_type, payment_method, status, comment) VALUES (3, 3, 1, 2833.33, '2026-05-01 00:00:00', '2026-05-01 00:00:00', NULL, 'BANK_TRANSFER', 'PAID', 'Платеж за период 3');
INSERT INTO public.payments (id, schedule_id, contract_id, amount, due_date, paid_date, payment_type, payment_method, status, comment) VALUES (4, 37, 2, 1500.00, '2026-03-15 00:00:00', '2026-03-15 00:00:00', NULL, 'BANK_TRANSFER', 'PAID', 'Платеж за период 1');
INSERT INTO public.payments (id, schedule_id, contract_id, amount, due_date, paid_date, payment_type, payment_method, status, comment) VALUES (5, 38, 2, 1500.00, '2026-04-15 00:00:00', '2026-04-15 00:00:00', NULL, 'BANK_TRANSFER', 'PAID', 'Платеж за период 2');
INSERT INTO public.payments (id, schedule_id, contract_id, amount, due_date, paid_date, payment_type, payment_method, status, comment) VALUES (6, 73, 3, 5600.00, '2026-04-01 00:00:00', '2026-04-01 00:00:00', NULL, 'CASH', 'PAID', 'Наличный платеж за период 1');
INSERT INTO public.payments (id, schedule_id, contract_id, amount, due_date, paid_date, payment_type, payment_method, status, comment) VALUES (7, 74, 3, 5600.00, '2026-05-01 00:00:00', '2026-05-01 00:00:00', NULL, 'CASH', 'PAID', 'Наличный платеж за период 2');
INSERT INTO public.payments (id, schedule_id, contract_id, amount, due_date, paid_date, payment_type, payment_method, status, comment) VALUES (8, 97, 4, 5000.00, '2026-04-15 00:00:00', '2026-04-15 00:00:00', NULL, 'BANK_TRANSFER', 'PAID', 'Платеж за период 1');
INSERT INTO public.payments (id, schedule_id, contract_id, amount, due_date, paid_date, payment_type, payment_method, status, comment) VALUES (9, 133, 5, 2100.00, '2026-04-20 00:00:00', '2026-04-20 00:00:00', NULL, 'CARD', 'PAID', 'Оплата картой за период 1');
INSERT INTO public.payments (id, schedule_id, contract_id, amount, due_date, paid_date, payment_type, payment_method, status, comment) VALUES (10, 157, 6, 3033.33, '2026-05-01 00:00:00', '2026-05-01 00:00:00', NULL, 'BANK_TRANSFER', 'PAID', 'Платеж за период 1');
INSERT INTO public.payments (id, schedule_id, contract_id, amount, due_date, paid_date, payment_type, payment_method, status, comment) VALUES (11, 265, 11, 4250.00, '2026-06-01 00:00:00', '2026-06-01 10:30:00', 'PRINCIPAL', 'BANK_TRANSFER', 'PAID', NULL);
INSERT INTO public.payments (id, schedule_id, contract_id, amount, due_date, paid_date, payment_type, payment_method, status, comment) VALUES (12, 289, 12, 2250.00, '2026-05-25 00:00:00', '2026-05-25 14:15:00', 'PRINCIPAL', 'BANK_TRANSFER', 'PAID', NULL);
INSERT INTO public.payments (id, schedule_id, contract_id, amount, due_date, paid_date, payment_type, payment_method, status, comment) VALUES (13, 325, 14, 4666.67, '2026-05-15 00:00:00', '2026-05-15 11:00:00', 'PRINCIPAL', 'BANK_TRANSFER', 'PAID', NULL);
INSERT INTO public.payments (id, schedule_id, contract_id, amount, due_date, paid_date, payment_type, payment_method, status, comment) VALUES (14, 326, 14, 4666.67, '2026-06-15 00:00:00', '2026-06-14 16:30:00', 'PRINCIPAL', 'BANK_TRANSFER', 'PAID', NULL);
INSERT INTO public.payments (id, schedule_id, contract_id, amount, due_date, paid_date, payment_type, payment_method, status, comment) VALUES (15, 373, 16, 4900.00, '2026-05-05 00:00:00', '2026-05-05 09:45:00', 'PRINCIPAL', 'BANK_TRANSFER', 'PAID', NULL);
INSERT INTO public.payments (id, schedule_id, contract_id, amount, due_date, paid_date, payment_type, payment_method, status, comment) VALUES (16, 397, 18, 3500.00, '2026-04-25 00:00:00', '2026-04-25 13:20:00', 'PRINCIPAL', 'BANK_TRANSFER', 'PAID', NULL);
INSERT INTO public.payments (id, schedule_id, contract_id, amount, due_date, paid_date, payment_type, payment_method, status, comment) VALUES (17, 398, 18, 3500.00, '2026-05-25 00:00:00', '2026-05-24 15:00:00', 'PRINCIPAL', 'BANK_TRANSFER', 'PAID', NULL);
INSERT INTO public.payments (id, schedule_id, contract_id, amount, due_date, paid_date, payment_type, payment_method, status, comment) VALUES (18, 421, 19, 14000.00, '2026-04-20 00:00:00', '2026-04-20 10:00:00', 'PRINCIPAL', 'BANK_TRANSFER', 'PAID', NULL);
INSERT INTO public.payments (id, schedule_id, contract_id, amount, due_date, paid_date, payment_type, payment_method, status, comment) VALUES (19, 433, 20, 5250.00, '2026-04-15 00:00:00', '2026-04-15 12:30:00', 'PRINCIPAL', 'BANK_TRANSFER', 'PAID', NULL);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users (id, username, password, role, full_name, email, active) VALUES (1, 'admin', '$2a$10$.3di7IlVZCzilEQcSUID7OfSmetdqaqHPcckkF73MTdit3XIv8cE6', 'ADMIN', 'Иванов Иван Иванович', 'admin@leasemanager.ru', true);
INSERT INTO public.users (id, username, password, role, full_name, email, active) VALUES (2, 'manager1', '$2a$10$5gvvD/Bc5.igx/k2ZQv/yelw..Pk.EGBvfObfv5VfXJKUrxU1LYqO', 'MANAGER', 'Петрова Анна Сергеевна', 'petrova@leasemanager.ru', true);
INSERT INTO public.users (id, username, password, role, full_name, email, active) VALUES (3, 'manager2', '$2a$10$0/vkWjcT1oAcvpT/Kriaae82Vs8Ckw.RElfvSsqh2XuzqrPVcjnii', 'MANAGER', 'Сидоров Петр Александрович', 'sidorov@leasemanager.ru', true);
INSERT INTO public.users (id, username, password, role, full_name, email, active) VALUES (4, 'manager3', '$2a$10$72m2xJFsG6hZOSz8Km1pmuBWyXGcblCukI8lF3iwZrfR0NKABMjvi', 'MANAGER', 'Козлова Мария Викторовна', 'kozlova@leasemanager.ru', true);
INSERT INTO public.users (id, username, password, role, full_name, email, active) VALUES (5, 'operator1', '$2a$10$zGhU3JrPfKZusZspRnBg..c5z9tKcxdVnYkPtyZWg2IyEgEL63VM.', 'MANAGER', 'Смирнов Алексей Дмитриевич', 'smirnov@leasemanager.ru', true);


--
-- Name: audit_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.audit_log_id_seq', 32, true);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categories_id_seq', 4, true);


--
-- Name: client_scoring_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.client_scoring_id_seq', 28, true);


--
-- Name: clients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clients_id_seq', 30, true);


--
-- Name: contracts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contracts_id_seq', 20, true);


--
-- Name: equipment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.equipment_id_seq', 30, true);


--
-- Name: equipment_incidents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.equipment_incidents_id_seq', 8, true);


--
-- Name: payment_schedules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payment_schedules_id_seq', 456, true);


--
-- Name: payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payments_id_seq', 19, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 5, true);


--
-- Name: audit_log audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: client_scoring client_scoring_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_scoring
    ADD CONSTRAINT client_scoring_pkey PRIMARY KEY (id);


--
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- Name: contracts contracts_contract_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contracts
    ADD CONSTRAINT contracts_contract_number_key UNIQUE (contract_number);


--
-- Name: contracts contracts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contracts
    ADD CONSTRAINT contracts_pkey PRIMARY KEY (id);


--
-- Name: equipment_incidents equipment_incidents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment_incidents
    ADD CONSTRAINT equipment_incidents_pkey PRIMARY KEY (id);


--
-- Name: equipment equipment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT equipment_pkey PRIMARY KEY (id);


--
-- Name: flyway_schema_history flyway_schema_history_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flyway_schema_history
    ADD CONSTRAINT flyway_schema_history_pk PRIMARY KEY (installed_rank);


--
-- Name: payment_schedules payment_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_schedules
    ADD CONSTRAINT payment_schedules_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: flyway_schema_history_s_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX flyway_schema_history_s_idx ON public.flyway_schema_history USING btree (success);


--
-- Name: idx_audit_log_action; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_audit_log_action ON public.audit_log USING btree (action);


--
-- Name: idx_audit_log_entity; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_audit_log_entity ON public.audit_log USING btree (entity_type, entity_id);


--
-- Name: idx_audit_log_timestamp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_audit_log_timestamp ON public.audit_log USING btree ("timestamp" DESC);


--
-- Name: idx_audit_log_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_audit_log_user_id ON public.audit_log USING btree (user_id);


--
-- Name: idx_client_scoring_client_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_client_scoring_client_id ON public.client_scoring USING btree (client_id);


--
-- Name: idx_client_scoring_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_client_scoring_date ON public.client_scoring USING btree (checked_date);


--
-- Name: idx_client_scoring_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_client_scoring_status ON public.client_scoring USING btree (status);


--
-- Name: idx_clients_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_clients_email ON public.clients USING btree (email);


--
-- Name: idx_clients_inn; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_clients_inn ON public.clients USING btree (inn);


--
-- Name: idx_contract_insurance_expiry; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_contract_insurance_expiry ON public.contracts USING btree (insurance_expiry_date);


--
-- Name: idx_contract_insurance_policy; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_contract_insurance_policy ON public.contracts USING btree (insurance_policy_number);


--
-- Name: idx_contracts_client; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_contracts_client ON public.contracts USING btree (client_id);


--
-- Name: idx_contracts_dates; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_contracts_dates ON public.contracts USING btree (start_date, end_date);


--
-- Name: idx_contracts_equipment; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_contracts_equipment ON public.contracts USING btree (equipment_id);


--
-- Name: idx_contracts_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_contracts_number ON public.contracts USING btree (contract_number);


--
-- Name: idx_contracts_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_contracts_status ON public.contracts USING btree (status);


--
-- Name: idx_equipment_category; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_equipment_category ON public.equipment USING btree (category_id);


--
-- Name: idx_equipment_energy_class; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_equipment_energy_class ON public.equipment USING btree (energy_class);


--
-- Name: idx_equipment_serial; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_equipment_serial ON public.equipment USING btree (serial_number);


--
-- Name: idx_equipment_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_equipment_status ON public.equipment USING btree (status);


--
-- Name: idx_equipment_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_equipment_type ON public.equipment USING btree (equipment_type);


--
-- Name: idx_incident_contract; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_incident_contract ON public.equipment_incidents USING btree (contract_id);


--
-- Name: idx_incident_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_incident_date ON public.equipment_incidents USING btree (incident_date);


--
-- Name: idx_incident_equipment; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_incident_equipment ON public.equipment_incidents USING btree (equipment_id);


--
-- Name: idx_incident_responsible; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_incident_responsible ON public.equipment_incidents USING btree (responsible_party);


--
-- Name: idx_incident_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_incident_status ON public.equipment_incidents USING btree (status);


--
-- Name: idx_incident_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_incident_type ON public.equipment_incidents USING btree (incident_type);


--
-- Name: idx_payment_schedules_contract; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_payment_schedules_contract ON public.payment_schedules USING btree (contract_id);


--
-- Name: idx_payment_schedules_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_payment_schedules_date ON public.payment_schedules USING btree (payment_date);


--
-- Name: idx_payment_schedules_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_payment_schedules_status ON public.payment_schedules USING btree (status);


--
-- Name: idx_payments_contract; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_payments_contract ON public.payments USING btree (contract_id);


--
-- Name: idx_payments_paid_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_payments_paid_date ON public.payments USING btree (paid_date);


--
-- Name: idx_payments_schedule; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_payments_schedule ON public.payments USING btree (schedule_id);


--
-- Name: idx_payments_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_payments_status ON public.payments USING btree (status);


--
-- Name: audit_log fk_audit_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT fk_audit_user FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: contracts fk_contract_client; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contracts
    ADD CONSTRAINT fk_contract_client FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE RESTRICT;


--
-- Name: contracts fk_contract_equipment; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contracts
    ADD CONSTRAINT fk_contract_equipment FOREIGN KEY (equipment_id) REFERENCES public.equipment(id) ON DELETE RESTRICT;


--
-- Name: equipment fk_equipment_category; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT fk_equipment_category FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE RESTRICT;


--
-- Name: equipment_incidents fk_incident_contract; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment_incidents
    ADD CONSTRAINT fk_incident_contract FOREIGN KEY (contract_id) REFERENCES public.contracts(id) ON DELETE SET NULL;


--
-- Name: equipment_incidents fk_incident_equipment; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment_incidents
    ADD CONSTRAINT fk_incident_equipment FOREIGN KEY (equipment_id) REFERENCES public.equipment(id) ON DELETE CASCADE;


--
-- Name: equipment_incidents fk_incident_reporter; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment_incidents
    ADD CONSTRAINT fk_incident_reporter FOREIGN KEY (reported_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: equipment_incidents fk_incident_resolver; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment_incidents
    ADD CONSTRAINT fk_incident_resolver FOREIGN KEY (resolved_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: payments fk_payment_contract; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT fk_payment_contract FOREIGN KEY (contract_id) REFERENCES public.contracts(id) ON DELETE CASCADE;


--
-- Name: payments fk_payment_schedule; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT fk_payment_schedule FOREIGN KEY (schedule_id) REFERENCES public.payment_schedules(id) ON DELETE CASCADE;


--
-- Name: payment_schedules fk_schedule_contract; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_schedules
    ADD CONSTRAINT fk_schedule_contract FOREIGN KEY (contract_id) REFERENCES public.contracts(id) ON DELETE CASCADE;


--
-- Name: client_scoring fk_scoring_client; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_scoring
    ADD CONSTRAINT fk_scoring_client FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE;


--
-- Name: client_scoring fk_scoring_reviewer; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_scoring
    ADD CONSTRAINT fk_scoring_reviewer FOREIGN KEY (reviewed_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

\unrestrict ZTQ2QgKXzDVJd4v477MH40w4mJRuynWsWudcXSzQHFZiwpghT3DSxMEfGkS8zSh

