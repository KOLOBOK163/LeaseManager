# LeaseManager - Система управления лизингом торгового оборудования

## 📋 Описание проекта

LeaseManager - это полнофункциональная система управления лизингом торгового оборудования, разработанная на Spring Boot. Система автоматизирует все этапы лизингового процесса: от заявки клиента до завершения договора.

## 🎯 Реализованный функционал

### Обязательные функции (100%)
- ✅ Управление клиентами (юр. лица, ИП) с валидацией ИНН
- ✅ Управление оборудованием с автоматической сменой статусов
- ✅ Договоры лизинга с защитой от двойной передачи
- ✅ Автоматический расчёт графика платежей (аннуитет)
- ✅ Учёт платежей с выявлением просрочек
- ✅ Ролевая модель (ADMIN, MANAGER) + JWT аутентификация

### Расширенные функции (100%)
- ✅ Автоматический расчёт пени за просрочку (0.1% в день)
- ✅ Отчётность и экспорт в Excel
- ✅ Система инцидентов с оборудованием (поломки, кражи, форс-мажор)
- ✅ Страхование оборудования с автоматическими уведомлениями
- ✅ Скоринг клиентов (автоматический + ручное одобрение)
- ✅ Email-уведомления (4 типа событий)
- ✅ Дашборд с аналитикой
- ✅ Аудит всех действий пользователей

## 🛠️ Технологический стек

**Backend:**
- Java 21
- Spring Boot 4.0.3
- Spring Security + JWT
- Spring Data JPA
- PostgreSQL
- Flyway (миграции БД)
- MapStruct (маппинг)
- Lombok
- Apache POI (Excel)
- iText (PDF)
- Spring Mail

**Архитектура:**
- Layered Architecture
- REST API
- DTO pattern
- Repository pattern
- Service layer

## 📦 Структура проекта

```
src/main/java/com/LeaseManager/
├── Controller/          # REST контроллеры
│   ├── AuthController.java
│   ├── ClientController.java
│   ├── ContractController.java
│   ├── EquipmentController.java
│   ├── PaymentController.java
│   ├── IncidentController.java      # НОВОЕ
│   ├── InsuranceController.java     # НОВОЕ
│   ├── PenaltyController.java       # НОВОЕ
│   └── ...
├── Service/             # Бизнес-логика
│   ├── ClientService.java
│   ├── ContractService.java
│   ├── PaymentScheduleService.java
│   ├── Incident/
│   │   └── IncidentService.java     # НОВОЕ
│   ├── Insurance/
│   │   └── InsuranceService.java    # НОВОЕ
│   ├── Penalty/
│   │   └── PenaltyService.java      # НОВОЕ
│   ├── Scoring/
│   │   └── ScoringService.java
│   ├── Notification/
│   │   ├── NotificationService.java
│   │   └── EmailService.java
│   └── ...
├── Entity/              # JPA сущности
│   ├── Client.java
│   ├── Contract.java            # ОБНОВЛЕНО (страхование)
│   ├── Equipment.java
│   ├── PaymentSchedule.java
│   ├── Payment.java
│   ├── EquipmentIncident.java   # НОВОЕ
│   └── ...
├── Repository/          # JPA репозитории
├── Dto/                 # Data Transfer Objects
├── Security/            # JWT + Spring Security
└── ...

src/main/resources/
├── application.properties       # НОВОЕ (конфигурация)
└── db/migration/
    ├── V1__init.sql
    ├── V2__add_trade_equipment_fields.sql
    ├── V3__add_trade_equipment_data.sql
    ├── V4__add_equipment_incidents.sql      # НОВОЕ
    └── V5__add_insurance_and_maintenance.sql # НОВОЕ
```

## 🚀 Быстрый старт

### 1. Требования
- Java 21+
- PostgreSQL 14+
- Maven 3.8+

### 2. Настройка БД
```bash
createdb leasemanager
```

### 3. Настройка приложения

Отредактируйте `src/main/resources/application.properties`:

```properties
# База данных
spring.datasource.url=jdbc:postgresql://localhost:5432/leasemanager
spring.datasource.username=postgres
spring.datasource.password=ваш-пароль

# Email (опционально)
spring.mail.username=ваш-email@gmail.com
spring.mail.password=пароль-приложения
notification.email.enabled=true

# JWT
jwt.secret=ваш-секретный-ключ-минимум-256-бит
```

### 4. Запуск
```bash
mvn clean install
mvn spring-boot:run
```

Приложение будет доступно на http://localhost:8080

## 📚 API Endpoints

### Аутентификация
```
POST   /api/auth/register - регистрация
POST   /api/auth/login - вход
```

### Клиенты
```
GET    /api/clients - список клиентов
POST   /api/clients - создать клиента
GET    /api/clients/{id} - получить клиента
PUT    /api/clients/{id} - обновить клиента
DELETE /api/clients/{id} - удалить клиента
```

### Оборудование
```
GET    /api/equipment - список оборудования
POST   /api/equipment - создать оборудование
GET    /api/equipment/{id} - получить оборудование
PUT    /api/equipment/{id} - обновить оборудование
DELETE /api/equipment/{id} - удалить оборудование
GET    /api/equipment/available - доступное оборудование
```

### Договоры
```
GET    /api/contracts - список договоров
POST   /api/contracts - создать договор
GET    /api/contracts/{id} - получить договор
PUT    /api/contracts/{id} - обновить договор
DELETE /api/contracts/{id} - удалить договор
POST   /api/contracts/{id}/generate-schedule - сгенерировать график платежей
GET    /api/contracts/{id}/statistics - статистика по договору
```

### Инциденты (НОВОЕ)
```
POST   /api/incidents - создать инцидент
GET    /api/incidents/{id} - получить инцидент
GET    /api/incidents/equipment/{id} - по оборудованию
GET    /api/incidents/active - активные инциденты
GET    /api/incidents/{id}/calculate-compensation - рассчитать компенсацию
```

### Страхование (НОВОЕ)
```
POST   /api/insurance/contract/{id} - добавить страхование
GET    /api/insurance/contract/{id} - получить информацию
GET    /api/insurance/calculate-premium/equipment/{id} - рассчитать премию
GET    /api/insurance/expiring - истекающие страховки
```

### Пени (НОВОЕ)
```
GET    /api/penalties/calculate/schedule/{id} - рассчитать пеню
GET    /api/penalties/total/contract/{id} - общая сумма пени
POST   /api/penalties/create/schedule/{id} - создать платёж пени
```

### Дашборд
```
GET    /api/dashboard/stats - общая статистика
GET    /api/dashboard/payment-chart - график платежей
GET    /api/dashboard/upcoming-payments - предстоящие платежи
```

## 🔐 Безопасность

- JWT токены для аутентификации
- Роли: ADMIN, MANAGER
- Разграничение доступа к эндпоинтам
- Валидация всех входных данных
- Аудит всех действий пользователей

## 📧 Email-уведомления

Система автоматически отправляет уведомления:
- **9:00** - о предстоящих платежах (за 3 дня)
- **10:00** - о просроченных платежах
- **8:00** - об истечении страховки (за 30 дней)
- **23:00** - автоматическое начисление пени

Подробная инструкция: `EMAIL_SETUP.md`

## 📊 Автоматизация

### Scheduled задачи:
- Проверка предстоящих платежей (ежедневно 9:00)
- Проверка просроченных платежей (ежедневно 10:00)
- Проверка истечения страховки (ежедневно 8:00)
- Автоматическое начисление пени (ежедневно 23:00)

### Автоматические действия:
- Смена статуса оборудования при активации/закрытии договора
- Завершение договора при полной оплате
- Приостановка договора при критических инцидентах
- Возврат оборудования в статус AVAILABLE

## 🧪 Тестирование

```bash
mvn test
```

Реализованы тесты:
- `InnValidatorTest` - валидация ИНН
- `BankAccountValidatorTest` - валидация банковских реквизитов
- `ScoringServiceTest` - скоринг клиентов

## 📖 Документация

- `COMPLETION_REPORT.md` - итоговый отчёт по доработке
- `EMAIL_SETUP.md` - настройка email-уведомлений
- `RISK_MANAGEMENT_AND_CONTRACT_PROCESS.md` - управление рисками

## 🎓 Для защиты диплома

### Ключевые формулы:

**Аннуитетный платёж:**
```
PMT = P × r / (1 − (1+r)^−n)
где P - сумма, r - месячная ставка, n - количество периодов
```

**Пеня за просрочку:**
```
Пеня = Сумма × Дни просрочки × 0.1%
```

**Компенсация при повреждении:**
```
Компенсация = Остаточная стоимость + 
              Упущенная выгода (30% от оставшихся платежей) + 
              Штраф (10% от остаточной стоимости)
```

**Страховая премия:**
```
Годовая премия = Стоимость оборудования × Тариф (1.5-3%)
Ежемесячная = Годовая / 12
```

### Демонстрация функционала:
1. Создание клиента с валидацией ИНН
2. Добавление оборудования
3. Создание договора с автоматическим графиком платежей
4. Регистрация инцидента с расчётом компенсации
5. Добавление страхования
6. Просмотр дашборда с аналитикой

## 👨‍💻 Автор

Дипломный проект по специальности "Информационные системы"

## 📄 Лицензия

Учебный проект

---

**Статус проекта:** ✅ Готов к защите (100%)

**Последнее обновление:** 21 апреля 2026
