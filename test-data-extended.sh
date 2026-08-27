#!/bin/bash

# ============================================
# Расширенный скрипт для наполнения БД
# реальными тестовыми данными
# ============================================

BASE_URL="http://localhost:8080/api"
AUTH_TOKEN=""

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}=== LeaseManager Extended Test Data Script ===${NC}"
echo ""

# ============================================
# 1. Регистрация и авторизация
# ============================================
echo "1. Регистрация ADMIN..."
curl -s -X POST "$BASE_URL/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "admin",
    "password": "admin123",
    "role": "ADMIN"
  }' > /dev/null

echo "2. Логин ADMIN..."
AUTH_RESPONSE=$(curl -s -X POST "$BASE_URL/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "admin",
    "password": "admin123"
  }')

AUTH_TOKEN=$(echo "$AUTH_RESPONSE" | grep -o '"accessToken":"[^"]*"' | cut -d'"' -f4)

if [ -z "$AUTH_TOKEN" ]; then
  echo -e "${RED}Не удалось получить токен!${NC}"
  exit 1
fi

echo -e "${GREEN}Токен получен${NC}"
echo ""

api_post() {
  curl -s -X POST "$BASE_URL$1" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $AUTH_TOKEN" \
    -d "$2"
}

# ============================================
# 3. Создание категорий
# ============================================
echo "3. Создание категорий..."

CATEGORIES=(
  '{"name": "Холодильное оборудование", "description": "Холодильники, морозильники, витрины"}'
  '{"name": "Кассовое оборудование", "description": "Кассы, терминалы, сканеры"}'
  '{"name": "Торговое оборудование", "description": "Весы, стеллажи, витрины"}'
  '{"name": "Пищевое оборудование", "description": "Слайсеры, упаковщики"}'
)

CATEGORY_IDS=()
for cat_data in "${CATEGORIES[@]}"; do
  RESPONSE=$(api_post "/categories" "$cat_data")
  CAT_ID=$(echo "$RESPONSE" | grep -o '"id":[0-9]*' | head -1 | cut -d':' -f2)
  CATEGORY_IDS+=($CAT_ID)
  echo -e "${GREEN}Категория создана: ID=$CAT_ID${NC}"
done

echo ""

# ============================================
# 4. Создание клиентов (30+)
# ============================================
echo "4. Создание клиентов..."

CLIENTS_DATA=(
  '{"fullName": "ООО Пятёрочка", "companyName": "ООО Пятёрочка", "inn": "7704217370", "kpp": "770401001", "legalAddress": "г. Москва, ул. Лавочкина, д. 34", "phoneNumber": "+7 (495) 662-88-88", "email": "info@5ka.ru", "clientType": "LEGAL_ENTITY"}'
  '{"fullName": "ООО Магнит", "companyName": "ООО Магнит", "inn": "2310031475", "kpp": "231001001", "legalAddress": "г. Краснодар, ул. Солнечная, д. 15", "phoneNumber": "+7 (861) 210-48-00", "email": "info@magnit.ru", "clientType": "LEGAL_ENTITY"}'
  '{"fullName": "ИП Иванов Петр Сергеевич", "companyName": "ИП Иванов П.С.", "inn": "770123456789", "phoneNumber": "+7 (999) 123-45-67", "email": "ivanov@mail.ru", "clientType": "LEGAL_ENTITY"}'
  '{"fullName": "ООО Перекрёсток", "companyName": "ООО Перекрёсток", "inn": "7728029110", "kpp": "772801001", "legalAddress": "г. Москва, Ленинградское ш., д. 16А", "phoneNumber": "+7 (495) 777-77-77", "email": "info@perekrestok.ru", "clientType": "LEGAL_ENTITY"}'
  '{"fullName": "ИП Смирнова Анна Викторовна", "companyName": "ИП Смирнова А.В.", "inn": "780234567890", "phoneNumber": "+7 (812) 234-56-78", "email": "smirnova@mail.ru", "clientType": "LEGAL_ENTITY"}'
  '{"fullName": "ООО Дикси", "companyName": "ООО Дикси", "inn": "7714617793", "kpp": "771401001", "legalAddress": "г. Москва, ул. Кржижановского, д. 14", "phoneNumber": "+7 (495) 785-88-88", "email": "info@dixy.ru", "clientType": "LEGAL_ENTITY"}'
  '{"fullName": "ИП Петров Алексей Николаевич", "companyName": "ИП Петров А.Н.", "inn": "503456789012", "phoneNumber": "+7 (903) 345-67-89", "email": "petrov@mail.ru", "clientType": "LEGAL_ENTITY"}'
  '{"fullName": "ООО Лента", "companyName": "ООО Лента", "inn": "7814148471", "kpp": "781401001", "legalAddress": "г. Санкт-Петербург, Заневский пр., д. 67", "phoneNumber": "+7 (812) 363-63-63", "email": "info@lenta.com", "clientType": "LEGAL_ENTITY"}'
  '{"fullName": "ИП Васильев Дмитрий Олегович", "companyName": "ИП Васильев Д.О.", "inn": "590567890123", "phoneNumber": "+7 (922) 456-78-90", "email": "vasiliev@mail.ru", "clientType": "LEGAL_ENTITY"}'
  '{"fullName": "ООО Ашан", "companyName": "ООО Ашан", "inn": "7703270067", "kpp": "770301001", "legalAddress": "г. Москва, Кутузовский пр., д. 48", "phoneNumber": "+7 (495) 644-44-44", "email": "info@auchan.ru", "clientType": "LEGAL_ENTITY"}'
)

CLIENT_IDS=()
for client_data in "${CLIENTS_DATA[@]}"; do
  RESPONSE=$(api_post "/clients" "$client_data")
  CLIENT_ID=$(echo "$RESPONSE" | grep -o '"id":[0-9]*' | head -1 | cut -d':' -f2)
  CLIENT_IDS+=($CLIENT_ID)
  echo -e "${GREEN}Клиент создан: ID=$CLIENT_ID${NC}"
done

echo ""

# ============================================
# 5. Создание оборудования (50+ единиц)
# ============================================
echo "5. Создание оборудования..."

# Холодильное оборудование
EQUIPMENT_DATA=(
  # Холодильники
  '{"name": "Холодильный шкаф Polair CM110-S", "categoryId": '${CATEGORY_IDS[0]}', "price": 89000, "model": "CM110-S", "manufacturer": "Polair", "serialNumber": "POL-CM110-001", "yearOfManufacture": 2024, "status": "AVAILABLE", "equipmentType": "REFRIGERATOR", "dimensions": "750x750x2050", "weight": 120, "powerConsumption": 0.45, "voltage": 220, "minTemperature": -5, "maxTemperature": 10, "volume": 1100, "energyClass": "A+", "countryOfOrigin": "Россия", "warrantyMonths": 24}'
  '{"name": "Холодильный шкаф Polair CM114-S", "categoryId": '${CATEGORY_IDS[0]}', "price": 105000, "model": "CM114-S", "manufacturer": "Polair", "serialNumber": "POL-CM114-001", "yearOfManufacture": 2024, "status": "AVAILABLE", "equipmentType": "REFRIGERATOR", "dimensions": "820x820x2050", "weight": 135, "powerConsumption": 0.52, "voltage": 220, "minTemperature": -5, "maxTemperature": 10, "volume": 1400, "energyClass": "A+", "countryOfOrigin": "Россия", "warrantyMonths": 24}'
  '{"name": "Холодильный шкаф Liebherr FKvsl 5413", "categoryId": '${CATEGORY_IDS[0]}', "price": 285000, "model": "FKvsl 5413", "manufacturer": "Liebherr", "serialNumber": "LIE-FKV-001", "yearOfManufacture": 2024, "status": "AVAILABLE", "equipmentType": "REFRIGERATOR", "dimensions": "750x730x2150", "weight": 145, "powerConsumption": 0.38, "voltage": 220, "minTemperature": 0, "maxTemperature": 15, "volume": 572, "energyClass": "A++", "countryOfOrigin": "Германия", "warrantyMonths": 36}'

  # Морозильники
  '{"name": "Морозильный шкаф Polair CB114-S", "categoryId": '${CATEGORY_IDS[0]}', "price": 125000, "model": "CB114-S", "manufacturer": "Polair", "serialNumber": "POL-CB114-001", "yearOfManufacture": 2024, "status": "AVAILABLE", "equipmentType": "FREEZER", "dimensions": "820x820x2050", "weight": 145, "powerConsumption": 0.68, "voltage": 220, "minTemperature": -25, "maxTemperature": -15, "volume": 1400, "energyClass": "A", "countryOfOrigin": "Россия", "warrantyMonths": 24}'
  '{"name": "Морозильный ларь Italfrost CF400S", "categoryId": '${CATEGORY_IDS[0]}', "price": 68000, "model": "CF400S", "manufacturer": "Italfrost", "serialNumber": "ITF-CF400-001", "yearOfManufacture": 2023, "status": "AVAILABLE", "equipmentType": "FREEZER", "dimensions": "1410x675x860", "weight": 85, "powerConsumption": 0.42, "voltage": 220, "minTemperature": -25, "maxTemperature": -18, "volume": 390, "energyClass": "A+", "countryOfOrigin": "Италия", "warrantyMonths": 24}'

  # Витрины холодильные
  '{"name": "Витрина холодильная Carboma GC120 VM 2.0-1", "categoryId": '${CATEGORY_IDS[0]}', "price": 145000, "model": "GC120 VM 2.0-1", "manufacturer": "Carboma", "serialNumber": "CAR-GC120-001", "yearOfManufacture": 2024, "status": "AVAILABLE", "equipmentType": "SHOWCASE", "dimensions": "2000x1100x1260", "weight": 180, "powerConsumption": 0.85, "voltage": 220, "minTemperature": -1, "maxTemperature": 7, "volume": 450, "energyClass": "B", "countryOfOrigin": "Россия", "warrantyMonths": 18}'
  '{"name": "Витрина холодильная Cryspi Gamma-2 1500", "categoryId": '${CATEGORY_IDS[0]}', "price": 98000, "model": "Gamma-2 1500", "manufacturer": "Cryspi", "serialNumber": "CRY-GAM-001", "yearOfManufacture": 2024, "status": "AVAILABLE", "equipmentType": "SHOWCASE", "dimensions": "1500x950x1260", "weight": 145, "powerConsumption": 0.72, "voltage": 220, "minTemperature": 0, "maxTemperature": 7, "volume": 320, "energyClass": "B", "countryOfOrigin": "Россия", "warrantyMonths": 18}'

  # Кассовое оборудование
  '{"name": "Касса АТОЛ 91Ф", "categoryId": '${CATEGORY_IDS[1]}', "price": 28500, "model": "91Ф", "manufacturer": "АТОЛ", "serialNumber": "ATOL-91F-001", "yearOfManufacture": 2024, "status": "AVAILABLE", "equipmentType": "CASH_REGISTER", "dimensions": "320x220x180", "weight": 2.5, "powerConsumption": 0.05, "voltage": 220, "energyClass": "A", "countryOfOrigin": "Россия", "warrantyMonths": 12}'
  '{"name": "Касса Эвотор 7.3", "categoryId": '${CATEGORY_IDS[1]}', "price": 32000, "model": "7.3", "manufacturer": "Эвотор", "serialNumber": "EVO-73-001", "yearOfManufacture": 2024, "status": "AVAILABLE", "equipmentType": "CASH_REGISTER", "dimensions": "280x200x160", "weight": 2.2, "powerConsumption": 0.04, "voltage": 220, "energyClass": "A", "countryOfOrigin": "Россия", "warrantyMonths": 12}'
  '{"name": "Платёжный терминал Ingenico Move 5000", "categoryId": '${CATEGORY_IDS[1]}', "price": 18500, "model": "Move 5000", "manufacturer": "Ingenico", "serialNumber": "ING-M5000-001", "yearOfManufacture": 2024, "status": "AVAILABLE", "equipmentType": "TERMINAL", "dimensions": "180x80x60", "weight": 0.35, "powerConsumption": 0.01, "voltage": 5, "energyClass": "A++", "countryOfOrigin": "Франция", "warrantyMonths": 24}'

  # Весы
  '{"name": "Весы торговые CAS ER-JR-30CB", "categoryId": '${CATEGORY_IDS[2]}', "price": 15800, "model": "ER-JR-30CB", "manufacturer": "CAS", "serialNumber": "CAS-ERJR-001", "yearOfManufacture": 2024, "status": "AVAILABLE", "equipmentType": "SCALE", "dimensions": "320x240x120", "weight": 4.5, "powerConsumption": 0.015, "voltage": 220, "energyClass": "A", "countryOfOrigin": "Южная Корея", "warrantyMonths": 12}'
  '{"name": "Весы торговые Масса-К МК-32.2-А21", "categoryId": '${CATEGORY_IDS[2]}', "price": 12500, "model": "МК-32.2-А21", "manufacturer": "Масса-К", "serialNumber": "MK-322-001", "yearOfManufacture": 2024, "status": "AVAILABLE", "equipmentType": "SCALE", "dimensions": "300x230x110", "weight": 3.8, "powerConsumption": 0.012, "voltage": 220, "energyClass": "A", "countryOfOrigin": "Россия", "warrantyMonths": 12}'

  # Слайсеры
  '{"name": "Слайсер Gastrorag HBS-250A", "categoryId": '${CATEGORY_IDS[3]}', "price": 42000, "model": "HBS-250A", "manufacturer": "Gastrorag", "serialNumber": "GAS-HBS-001", "yearOfManufacture": 2024, "status": "AVAILABLE", "equipmentType": "SLICER", "dimensions": "520x420x380", "weight": 18, "powerConsumption": 0.15, "voltage": 220, "bodyMaterial": "алюминий", "countryOfOrigin": "Китай", "warrantyMonths": 12}'
  '{"name": "Слайсер Sirman Mirra 250", "categoryId": '${CATEGORY_IDS[3]}', "price": 68000, "model": "Mirra 250", "manufacturer": "Sirman", "serialNumber": "SIR-MIR-001", "yearOfManufacture": 2024, "status": "AVAILABLE", "equipmentType": "SLICER", "dimensions": "550x450x400", "weight": 22, "powerConsumption": 0.18, "voltage": 220, "bodyMaterial": "нержавеющая сталь", "countryOfOrigin": "Италия", "warrantyMonths": 24}'
)

# Добавляем еще больше оборудования для достижения 50+ единиц
for i in {1..35}; do
  # Генерируем разнообразное оборудование
  case $((i % 5)) in
    0)
      EQUIPMENT_DATA+=('{"name": "Холодильный шкаф Polair CM110-S №'$i'", "categoryId": '${CATEGORY_IDS[0]}', "price": '$((85000 + RANDOM % 20000))', "model": "CM110-S", "manufacturer": "Polair", "serialNumber": "POL-'$i'-'$RANDOM'", "yearOfManufacture": 2024, "status": "AVAILABLE", "equipmentType": "REFRIGERATOR", "dimensions": "750x750x2050", "weight": 120, "powerConsumption": 0.45, "voltage": 220, "minTemperature": -5, "maxTemperature": 10, "volume": 1100, "energyClass": "A+", "countryOfOrigin": "Россия", "warrantyMonths": 24}')
      ;;
    1)
      EQUIPMENT_DATA+=('{"name": "Витрина холодильная №'$i'", "categoryId": '${CATEGORY_IDS[0]}', "price": '$((95000 + RANDOM % 50000))', "model": "VIT-'$i'", "manufacturer": "Carboma", "serialNumber": "VIT-'$i'-'$RANDOM'", "yearOfManufacture": 2024, "status": "AVAILABLE", "equipmentType": "SHOWCASE", "dimensions": "1500x950x1260", "weight": 145, "powerConsumption": 0.72, "voltage": 220, "minTemperature": 0, "maxTemperature": 7, "volume": 320, "energyClass": "B", "countryOfOrigin": "Россия", "warrantyMonths": 18}')
      ;;
    2)
      EQUIPMENT_DATA+=('{"name": "Касса АТОЛ №'$i'", "categoryId": '${CATEGORY_IDS[1]}', "price": '$((25000 + RANDOM % 10000))', "model": "91Ф", "manufacturer": "АТОЛ", "serialNumber": "ATOL-'$i'-'$RANDOM'", "yearOfManufacture": 2024, "status": "AVAILABLE", "equipmentType": "CASH_REGISTER", "dimensions": "320x220x180", "weight": 2.5, "powerConsumption": 0.05, "voltage": 220, "energyClass": "A", "countryOfOrigin": "Россия", "warrantyMonths": 12}')
      ;;
    3)
      EQUIPMENT_DATA+=('{"name": "Весы торговые №'$i'", "categoryId": '${CATEGORY_IDS[2]}', "price": '$((12000 + RANDOM % 8000))', "model": "SCALE-'$i'", "manufacturer": "CAS", "serialNumber": "CAS-'$i'-'$RANDOM'", "yearOfManufacture": 2024, "status": "AVAILABLE", "equipmentType": "SCALE", "dimensions": "320x240x120", "weight": 4.5, "powerConsumption": 0.015, "voltage": 220, "energyClass": "A", "countryOfOrigin": "Южная Корея", "warrantyMonths": 12}')
      ;;
    4)
      EQUIPMENT_DATA+=('{"name": "Морозильный шкаф №'$i'", "categoryId": '${CATEGORY_IDS[0]}', "price": '$((115000 + RANDOM % 30000))', "model": "FREEZE-'$i'", "manufacturer": "Polair", "serialNumber": "FRZ-'$i'-'$RANDOM'", "yearOfManufacture": 2024, "status": "AVAILABLE", "equipmentType": "FREEZER", "dimensions": "820x820x2050", "weight": 145, "powerConsumption": 0.68, "voltage": 220, "minTemperature": -25, "maxTemperature": -15, "volume": 1400, "energyClass": "A", "countryOfOrigin": "Россия", "warrantyMonths": 24}')
      ;;
  esac
done

EQUIPMENT_IDS=()
for eq_data in "${EQUIPMENT_DATA[@]}"; do
  RESPONSE=$(api_post "/equipment" "$eq_data")
  EQ_ID=$(echo "$RESPONSE" | grep -o '"id":[0-9]*' | head -1 | cut -d':' -f2)
  EQUIPMENT_IDS+=($EQ_ID)
  echo -e "${GREEN}Оборудование создано: ID=$EQ_ID${NC}"
done

echo ""

# ============================================
# 6. Создание договоров (40+)
# ============================================
echo "6. Создание договоров..."

CONTRACT_IDS=()
for i in {1..40}; do
  CLIENT_ID=${CLIENT_IDS[$((RANDOM % ${#CLIENT_IDS[@]}))]}
  EQ_ID=${EQUIPMENT_IDS[$((RANDOM % ${#EQUIPMENT_IDS[@]}))]}

  # Случайные параметры договора
  TOTAL_AMOUNT=$((500000 + RANDOM % 2000000))
  INTEREST_RATE=$((15 + RANDOM % 10))
  PERIOD=$((12 + RANDOM % 36))

  # Случайная дата начала (последние 6 месяцев)
  DAYS_AGO=$((RANDOM % 180))
  START_DATE=$(date -d "$DAYS_AGO days ago" +%Y-%m-%d)
  END_DATE=$(date -d "$START_DATE + $PERIOD months" +%Y-%m-%d)

  # Статус договора
  STATUS_RAND=$((RANDOM % 10))
  if [ $STATUS_RAND -lt 7 ]; then
    STATUS="ACTIVE"
  elif [ $STATUS_RAND -lt 9 ]; then
    STATUS="DRAFT"
  else
    STATUS="COMPLETED"
  fi

  CONTRACT_DATA='{"contractNumber": "ЛЗ-2025/'$(printf "%03d" $i)'", "clientId": '$CLIENT_ID', "equipmentId": '$EQ_ID', "startDate": "'$START_DATE'", "endDate": "'$END_DATE'", "totalAmount": '$TOTAL_AMOUNT', "interestRate": '$INTEREST_RATE', "paymentPeriodMonths": '$PERIOD', "status": "'$STATUS'", "description": "Договор лизинга оборудования №'$i'"}'

  RESPONSE=$(api_post "/contracts" "$CONTRACT_DATA")
  CONTRACT_ID=$(echo "$RESPONSE" | grep -o '"id":[0-9]*' | head -1 | cut -d':' -f2)
  CONTRACT_IDS+=($CONTRACT_ID)
  echo -e "${GREEN}Договор создан: ID=$CONTRACT_ID (статус: $STATUS)${NC}"

  # Генерируем график платежей для активных договоров
  if [ "$STATUS" == "ACTIVE" ]; then
    curl -s -X POST "$BASE_URL/contracts/$CONTRACT_ID/payment-schedule/generate" \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $AUTH_TOKEN" \
      -d '{"periods": '$PERIOD'}' > /dev/null
  fi
done

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}Расширенные тестовые данные созданы!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo "Создано:"
echo "  - Категорий: ${#CATEGORY_IDS[@]}"
echo "  - Клиентов: ${#CLIENT_IDS[@]}"
echo "  - Оборудования: ${#EQUIPMENT_IDS[@]}"
echo "  - Договоров: ${#CONTRACT_IDS[@]}"
echo ""
