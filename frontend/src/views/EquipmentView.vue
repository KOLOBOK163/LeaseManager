<template>
  <div class="equipment-page">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h2>Оборудование</h2>
      <button class="btn btn-primary" @click="showCreateModal = true">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" class="me-1">
          <path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4z"/>
        </svg>
        Добавить оборудование
      </button>
    </div>

    <!-- Фильтр по статусу и поиск -->
    <div class="card mb-4">
      <div class="card-body">
        <div class="row g-3 align-items-center">
          <div class="col-auto">
            <label class="col-form-label">Поиск:</label>
          </div>
          <div class="col-md-4">
            <input
              type="text"
              class="form-control"
              v-model="searchQuery"
              placeholder="Поиск по названию, модели, производителю..."
            />
          </div>
          <div class="col-auto">
            <label class="col-form-label">Статус:</label>
          </div>
          <div class="col-auto">
            <select class="form-select" v-model="selectedStatus" @change="loadEquipment">
              <option value="">Все статусы</option>
              <option value="AVAILABLE">Доступно</option>
              <option value="LEASED">В лизинге</option>
              <option value="MAINTENANCE">На обслуживании</option>
              <option value="SOLD">Продано</option>
              <option value="WRITE_OFF">Списано</option>
            </select>
          </div>
          <div class="col-auto ms-auto">
            <span class="text-muted">Найдено: {{ filteredEquipment.length }} из {{ equipment.length }}</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Таблица оборудования -->
    <div class="card">
      <div class="card-body">
        <div v-if="loading" class="text-center py-5">
          <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Загрузка...</span>
          </div>
        </div>
        <div v-else-if="filteredEquipment.length === 0" class="text-center py-5 text-muted">
          Оборудование не найдено
        </div>
        <table v-else class="table table-hover">
          <thead>
            <tr>
              <th>Название</th>
              <th>Тип</th>
              <th>Категория</th>
              <th>Модель</th>
              <th>Производитель</th>
              <th>Цена</th>
              <th>Статус</th>
              <th class="text-end">Действия</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in filteredEquipment" :key="item.id">
              <td><strong>{{ item.name }}</strong></td>
              <td>{{ equipmentTypeLabel(item.equipmentType) }}</td>
              <td>{{ item.categoryName }}</td>
              <td>{{ item.model || '—' }}</td>
              <td>{{ item.manufacturer || '—' }}</td>
              <td>{{ formatMoney(item.price) }}</td>
              <td>
                <span :class="statusBadgeClass(item.status)">
                  {{ statusLabel(item.status) }}
                </span>
              </td>
              <td class="text-end">
                <div class="btn-group btn-group-sm">
                  <button class="btn btn-outline-primary" @click="goToDetail(item)" title="Подробно">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                      <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
                      <path d="M7.002 11a1 1 0 1 1 2 0 1 1 0 0 1-2 0zM7.1 4.995a.905.905 0 1 1 1.8 0l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 4.995z"/>
                    </svg>
                  </button>
                  <button class="btn btn-outline-secondary" @click="editEquipment(item)" title="Редактировать">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                      <path d="M12.146.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1 0 .708l-10 10a.5.5 0 0 1-.168.11l-5 2a.5.5 0 0 1-.65-.65l2-5a.5.5 0 0 1 .11-.168l10-10zM11.207 2.5 13.5 4.793 14.793 3.5 12.5 1.207 11.207 2.5zm1.586 3L10.5 3.207 4 9.707V10h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.293l6.5-6.5zm-9.761 5.175-.106.106-1.528 3.821 3.821-1.528.106-.106A.5.5 0 0 1 5 12.5V12h-.5a.5.5 0 0 1-.5-.5V11h-.5a.5.5 0 0 1-.468-.325z"/>
                    </svg>
                  </button>
                  <button class="btn btn-outline-danger" @click="deleteEquipment(item)" title="Удалить">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                      <path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0V6z"/>
                      <path d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118zM2.5 3V2h11v1h-11z"/>
                    </svg>
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Модальное окно создания/редактирования -->
    <div v-if="showCreateModal || showEditModal" class="modal fade show d-block" tabindex="-1">
      <div class="modal-dialog modal-xl">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">{{ showCreateModal ? 'Новое оборудование' : 'Редактирование оборудования' }}</h5>
            <button type="button" class="btn-close" @click="closeModal"></button>
          </div>
          <div class="modal-body">
            <form @submit.prevent="submitForm">
              <h6 class="mb-3">Основная информация</h6>
              <div class="row g-3 mb-4">
                <div class="col-md-6">
                  <label class="form-label">Название *</label>
                  <input type="text" class="form-control" v-model="form.name" required />
                </div>
                <div class="col-md-6">
                  <label class="form-label">Категория *</label>
                  <select class="form-select" v-model="form.categoryId" required>
                    <option value="" disabled>Выберите категорию</option>
                    <option v-for="cat in categories" :key="cat.id" :value="cat.id">{{ cat.name }}</option>
                  </select>
                </div>
                <div class="col-md-6">
                  <label class="form-label">Цена *</label>
                  <input type="number" step="0.01" class="form-control" v-model="form.price" required />
                </div>
                <div class="col-md-6">
                  <label class="form-label">Статус</label>
                  <select class="form-select" v-model="form.status">
                    <option value="AVAILABLE">Доступно</option>
                    <option value="LEASED">В лизинге</option>
                    <option value="MAINTENANCE">На обслуживании</option>
                    <option value="SOLD">Продано</option>
                    <option value="WRITE_OFF">Списано</option>
                  </select>
                </div>
                <div class="col-md-6">
                  <label class="form-label">Модель</label>
                  <input type="text" class="form-control" v-model="form.model" />
                </div>
                <div class="col-md-6">
                  <label class="form-label">Производитель</label>
                  <input type="text" class="form-control" v-model="form.manufacturer" />
                </div>
                <div class="col-md-6">
                  <label class="form-label">Серийный номер</label>
                  <input type="text" class="form-control" v-model="form.serialNumber" />
                </div>
                <div class="col-md-6">
                  <label class="form-label">Год производства</label>
                  <input type="number" class="form-control" v-model.number="form.yearOfManufacture" />
                </div>
                <div class="col-12">
                  <label class="form-label">Описание</label>
                  <textarea class="form-control" v-model="form.description" rows="3"></textarea>
                </div>
              </div>

              <h6 class="mb-3">Характеристики торгового оборудования</h6>
              <div class="row g-3 mb-4">
                <div class="col-md-4">
                  <label class="form-label">Тип оборудования</label>
                  <select class="form-select" v-model="form.equipmentType">
                    <option value="">Не указан</option>
                    <option value="REFRIGERATOR">Холодильник</option>
                    <option value="FREEZER">Морозильник</option>
                    <option value="SHOWCASE">Витрина</option>
                    <option value="CASH_REGISTER">Кассовый аппарат</option>
                    <option value="SCALE">Весы</option>
                    <option value="SHELVING">Стеллажи</option>
                    <option value="COOLER">Охладитель</option>
                    <option value="HEAT_DISPLAY">Тепловая витрина</option>
                    <option value="SLICER">Слайсер</option>
                    <option value="PACKAGING_MACHINE">Упаковочная машина</option>
                    <option value="TERMINAL">Платёжный терминал</option>
                    <option value="SCANNER">Сканер штрих-кодов</option>
                    <option value="OTHER">Другое</option>
                  </select>
                </div>
                <div class="col-md-4">
                  <label class="form-label">Габариты (Д×Ш×В, см)</label>
                  <input type="text" class="form-control" v-model="form.dimensions" placeholder="1200x750x2000" />
                </div>
                <div class="col-md-4">
                  <label class="form-label">Вес (кг)</label>
                  <input type="number" step="0.01" class="form-control" v-model.number="form.weight" />
                </div>
                <div class="col-md-4">
                  <label class="form-label">Потребляемая мощность (кВт)</label>
                  <input type="number" step="0.001" class="form-control" v-model.number="form.powerConsumption" />
                </div>
                <div class="col-md-4">
                  <label class="form-label">Напряжение (В)</label>
                  <input type="number" class="form-control" v-model.number="form.voltage" placeholder="220" />
                </div>
                <div class="col-md-4">
                  <label class="form-label">Энергокласс</label>
                  <input type="text" class="form-control" v-model="form.energyClass" placeholder="A++" />
                </div>
                <div class="col-md-4">
                  <label class="form-label">Мин. температура (°C)</label>
                  <input type="number" class="form-control" v-model.number="form.minTemperature" />
                </div>
                <div class="col-md-4">
                  <label class="form-label">Макс. температура (°C)</label>
                  <input type="number" class="form-control" v-model.number="form.maxTemperature" />
                </div>
                <div class="col-md-4">
                  <label class="form-label">Объём (л)</label>
                  <input type="number" step="0.01" class="form-control" v-model.number="form.volume" />
                </div>
                <div class="col-md-6">
                  <label class="form-label">Материал корпуса</label>
                  <input type="text" class="form-control" v-model="form.bodyMaterial" placeholder="нержавеющая сталь" />
                </div>
                <div class="col-md-6">
                  <label class="form-label">Страна производства</label>
                  <input type="text" class="form-control" v-model="form.countryOfOrigin" />
                </div>
              </div>

              <h6 class="mb-3">Установка и обслуживание</h6>
              <div class="row g-3">
                <div class="col-md-8">
                  <label class="form-label">Адрес установки</label>
                  <input type="text" class="form-control" v-model="form.installationAddress" />
                </div>
                <div class="col-md-4">
                  <label class="form-label">Дата установки</label>
                  <input type="date" class="form-control" v-model="form.installationDate" />
                </div>
                <div class="col-md-4">
                  <label class="form-label">Гарантийный срок (мес.)</label>
                  <input type="number" class="form-control" v-model.number="form.warrantyMonths" />
                </div>
                <div class="col-md-4">
                  <label class="form-label">Дата последнего ТО</label>
                  <input type="date" class="form-control" v-model="form.lastMaintenanceDate" />
                </div>
                <div class="col-md-4">
                  <label class="form-label">Дата следующего ТО</label>
                  <input type="date" class="form-control" v-model="form.nextMaintenanceDate" />
                </div>
                <div class="col-md-6">
                  <label class="form-label">Сервисный контракт №</label>
                  <input type="text" class="form-control" v-model="form.serviceContractNumber" />
                </div>
                <div class="col-12">
                  <label class="form-label">Примечание по обслуживанию</label>
                  <textarea class="form-control" v-model="form.maintenanceNotes" rows="2"></textarea>
                </div>
              </div>
            </form>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" @click="closeModal">Отмена</button>
            <button type="button" class="btn btn-primary" @click="submitForm" :disabled="submitting">
              {{ submitting ? 'Сохранение...' : 'Сохранить' }}
            </button>
          </div>
        </div>
      </div>
    </div>
    <div v-if="showCreateModal || showEditModal" class="modal-backdrop fade show"></div>

    <!-- Модальное окно просмотра деталей оборудования -->
    <div v-if="showDetailsModal" class="modal fade show d-block" tabindex="-1">
      <div class="modal-dialog modal-xl">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Оборудование: {{ selectedEquipment?.name }}</h5>
            <button type="button" class="btn-close" @click="showDetailsModal = false"></button>
          </div>
          <div class="modal-body">
            <div v-if="selectedEquipment">
              <h6 class="mb-3">Основная информация</h6>
              <div class="row g-3 mb-4">
                <div class="col-md-4">
                  <label class="form-label text-muted">Название</label>
                  <p><strong>{{ selectedEquipment.name }}</strong></p>
                </div>
                <div class="col-md-4">
                  <label class="form-label text-muted">Категория</label>
                  <p>{{ selectedEquipment.categoryName }}</p>
                </div>
                <div class="col-md-4">
                  <label class="form-label text-muted">Цена</label>
                  <p>{{ formatMoney(selectedEquipment.price) }}</p>
                </div>
                <div class="col-md-4">
                  <label class="form-label text-muted">Статус</label>
                  <p><span :class="statusBadgeClass(selectedEquipment.status)">{{ statusLabel(selectedEquipment.status) }}</span></p>
                </div>
                <div class="col-md-4">
                  <label class="form-label text-muted">Модель</label>
                  <p>{{ selectedEquipment.model || '—' }}</p>
                </div>
                <div class="col-md-4">
                  <label class="form-label text-muted">Производитель</label>
                  <p>{{ selectedEquipment.manufacturer || '—' }}</p>
                </div>
                <div class="col-md-4">
                  <label class="form-label text-muted">Серийный номер</label>
                  <p>{{ selectedEquipment.serialNumber || '—' }}</p>
                </div>
                <div class="col-md-4">
                  <label class="form-label text-muted">Год производства</label>
                  <p>{{ selectedEquipment.yearOfManufacture || '—' }}</p>
                </div>
                <div class="col-12">
                  <label class="form-label text-muted">Описание</label>
                  <p>{{ selectedEquipment.description || '—' }}</p>
                </div>
              </div>

              <h6 class="mb-3">Характеристики торгового оборудования</h6>
              <div class="row g-3 mb-4">
                <div class="col-md-4">
                  <label class="form-label text-muted">Тип оборудования</label>
                  <p>{{ equipmentTypeLabel(selectedEquipment.equipmentType) }}</p>
                </div>
                <div class="col-md-4">
                  <label class="form-label text-muted">Габариты (Д×Ш×В, см)</label>
                  <p>{{ selectedEquipment.dimensions || '—' }}</p>
                </div>
                <div class="col-md-4">
                  <label class="form-label text-muted">Вес (кг)</label>
                  <p>{{ selectedEquipment.weight || '—' }}</p>
                </div>
                <div class="col-md-4">
                  <label class="form-label text-muted">Потребляемая мощность (кВт)</label>
                  <p>{{ selectedEquipment.powerConsumption || '—' }}</p>
                </div>
                <div class="col-md-4">
                  <label class="form-label text-muted">Напряжение (В)</label>
                  <p>{{ selectedEquipment.voltage || '—' }}</p>
                </div>
                <div class="col-md-4">
                  <label class="form-label text-muted">Энергокласс</label>
                  <p>{{ selectedEquipment.energyClass || '—' }}</p>
                </div>
                <div class="col-md-4">
                  <label class="form-label text-muted">Мин. температура (°C)</label>
                  <p>{{ selectedEquipment.minTemperature !== null && selectedEquipment.minTemperature !== undefined ? selectedEquipment.minTemperature + '°C' : '—' }}</p>
                </div>
                <div class="col-md-4">
                  <label class="form-label text-muted">Макс. температура (°C)</label>
                  <p>{{ selectedEquipment.maxTemperature !== null && selectedEquipment.maxTemperature !== undefined ? selectedEquipment.maxTemperature + '°C' : '—' }}</p>
                </div>
                <div class="col-md-4">
                  <label class="form-label text-muted">Объём (л)</label>
                  <p>{{ selectedEquipment.volume || '—' }}</p>
                </div>
                <div class="col-md-6">
                  <label class="form-label text-muted">Материал корпуса</label>
                  <p>{{ selectedEquipment.bodyMaterial || '—' }}</p>
                </div>
                <div class="col-md-6">
                  <label class="form-label text-muted">Страна производства</label>
                  <p>{{ selectedEquipment.countryOfOrigin || '—' }}</p>
                </div>
              </div>

              <h6 class="mb-3">Установка и обслуживание</h6>
              <div class="row g-3">
                <div class="col-md-8">
                  <label class="form-label text-muted">Адрес установки</label>
                  <p>{{ selectedEquipment.installationAddress || '—' }}</p>
                </div>
                <div class="col-md-4">
                  <label class="form-label text-muted">Дата установки</label>
                  <p>{{ selectedEquipment.installationDate || '—' }}</p>
                </div>
                <div class="col-md-4">
                  <label class="form-label text-muted">Гарантийный срок (мес.)</label>
                  <p>{{ selectedEquipment.warrantyMonths || '—' }}</p>
                </div>
                <div class="col-md-4">
                  <label class="form-label text-muted">Дата последнего ТО</label>
                  <p>{{ selectedEquipment.lastMaintenanceDate || '—' }}</p>
                </div>
                <div class="col-md-4">
                  <label class="form-label text-muted">Дата следующего ТО</label>
                  <p>{{ selectedEquipment.nextMaintenanceDate || '—' }}</p>
                </div>
                <div class="col-md-6">
                  <label class="form-label text-muted">Сервисный контракт №</label>
                  <p>{{ selectedEquipment.serviceContractNumber || '—' }}</p>
                </div>
                <div class="col-12">
                  <label class="form-label text-muted">Примечание по обслуживанию</label>
                  <p>{{ selectedEquipment.maintenanceNotes || '—' }}</p>
                </div>
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" @click="showDetailsModal = false">Закрыть</button>
            <button type="button" class="btn btn-primary" @click="editEquipment(selectedEquipment!); showDetailsModal = false">Редактировать</button>
          </div>
        </div>
      </div>
    </div>
    <div v-if="showDetailsModal" class="modal-backdrop fade show"></div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { equipmentApi, type Equipment, type CreateEquipmentRequest, type UpdateEquipmentRequest, type EquipmentStatus, type EquipmentType, type Category } from '@/types/equipment'

const router = useRouter()

const equipment = ref<Equipment[]>([])
const categories = ref<Category[]>([])
const loading = ref(false)
const selectedStatus = ref('')
const searchQuery = ref('')
const showCreateModal = ref(false)
const showEditModal = ref(false)
const showDetailsModal = ref(false)
const submitting = ref(false)
const editingEquipmentId = ref<number | null>(null)
const selectedEquipment = ref<Equipment | null>(null)

const form = reactive<CreateEquipmentRequest>({
  name: '',
  categoryId: 0,
  price: 0,
  model: '',
  manufacturer: '',
  serialNumber: '',
  yearOfManufacture: undefined,
  status: 'AVAILABLE',
  description: '',

  // Характеристики торгового оборудования
  equipmentType: undefined,
  dimensions: '',
  weight: undefined,
  powerConsumption: undefined,
  voltage: undefined,
  minTemperature: undefined,
  maxTemperature: undefined,
  volume: undefined,
  bodyMaterial: '',
  installationAddress: '',
  installationDate: undefined,
  nextMaintenanceDate: undefined,
  warrantyMonths: undefined,
  serviceContractNumber: '',
  energyClass: '',
  countryOfOrigin: '',
  lastMaintenanceDate: undefined,
  maintenanceNotes: ''
})

// Вычисляемое свойство для фильтрации оборудования по поисковому запросу
const filteredEquipment = computed(() => {
  if (!searchQuery.value.trim()) {
    return equipment.value
  }

  const query = searchQuery.value.toLowerCase().trim()
  return equipment.value.filter(item => {
    return (
      item.name.toLowerCase().includes(query) ||
      (item.model && item.model.toLowerCase().includes(query)) ||
      (item.manufacturer && item.manufacturer.toLowerCase().includes(query)) ||
      item.categoryName.toLowerCase().includes(query)
    )
  })
})

const loadEquipment = async () => {
  loading.value = true
  try {
    equipment.value = await equipmentApi.getEquipment(selectedStatus.value || undefined)
  } catch (error) {
    console.error('Failed to load equipment:', error)
  } finally {
    loading.value = false
  }
}

const loadCategories = async () => {
  try {
    categories.value = await equipmentApi.getCategories()
  } catch (error) {
    console.error('Failed to load categories:', error)
  }
}

const editEquipment = (item: Equipment) => {
  editingEquipmentId.value = item.id
  form.name = item.name
  form.categoryId = item.categoryId
  form.price = Number(item.price)
  form.model = item.model || ''
  form.manufacturer = item.manufacturer || ''
  form.serialNumber = item.serialNumber || ''
  form.yearOfManufacture = item.yearOfManufacture || undefined
  form.status = item.status
  form.description = item.description || ''
  
  // Характеристики торгового оборудования
  form.equipmentType = item.equipmentType
  form.dimensions = item.dimensions || ''
  form.weight = item.weight || undefined
  form.powerConsumption = item.powerConsumption || undefined
  form.voltage = item.voltage || undefined
  form.minTemperature = item.minTemperature || undefined
  form.maxTemperature = item.maxTemperature || undefined
  form.volume = item.volume || undefined
  form.bodyMaterial = item.bodyMaterial || ''
  form.installationAddress = item.installationAddress || ''
  form.installationDate = item.installationDate || undefined
  form.nextMaintenanceDate = item.nextMaintenanceDate || undefined
  form.warrantyMonths = item.warrantyMonths || undefined
  form.serviceContractNumber = item.serviceContractNumber || ''
  form.energyClass = item.energyClass || ''
  form.countryOfOrigin = item.countryOfOrigin || ''
  form.lastMaintenanceDate = item.lastMaintenanceDate || undefined
  form.maintenanceNotes = item.maintenanceNotes || ''
  
  showEditModal.value = true
}

const submitForm = async () => {
  submitting.value = true
  try {
    if (editingEquipmentId.value) {
      await equipmentApi.updateEquipment(editingEquipmentId.value, form as UpdateEquipmentRequest)
    } else {
      await equipmentApi.createEquipment(form)
    }
    closeModal()
    loadEquipment()
  } catch (error) {
    console.error('Failed to save equipment:', error)
    alert('Ошибка при сохранении оборудования')
  } finally {
    submitting.value = false
  }
}

const deleteEquipment = async (item: Equipment) => {
  if (!confirm(`Удалить оборудование "${item.name}"?`)) return
  try {
    await equipmentApi.deleteEquipment(item.id)
    loadEquipment()
  } catch (error) {
    console.error('Failed to delete equipment:', error)
    alert('Ошибка при удалении оборудования')
  }
}

const showDetails = (item: Equipment) => {
  selectedEquipment.value = item
  showDetailsModal.value = true
}

const goToDetail = (item: Equipment) => {
  router.push(`/equipment/${item.id}`)
}

const closeModal = () => {
  showCreateModal.value = false
  showEditModal.value = false
  showDetailsModal.value = false
  editingEquipmentId.value = null
  Object.assign(form, {
    name: '',
    categoryId: 0,
    price: 0,
    model: '',
    manufacturer: '',
    serialNumber: '',
    yearOfManufacture: undefined,
    status: 'AVAILABLE',
    description: '',
    equipmentType: undefined,
    dimensions: '',
    weight: undefined,
    powerConsumption: undefined,
    voltage: undefined,
    minTemperature: undefined,
    maxTemperature: undefined,
    volume: undefined,
    bodyMaterial: '',
    installationAddress: '',
    installationDate: undefined,
    nextMaintenanceDate: undefined,
    warrantyMonths: undefined,
    serviceContractNumber: '',
    energyClass: '',
    countryOfOrigin: '',
    lastMaintenanceDate: undefined,
    maintenanceNotes: ''
  })
}

const equipmentTypeLabel = (type?: string) => {
  if (!type) return '—'
  const labels: Record<string, string> = {
    REFRIGERATOR: 'Холодильник',
    FREEZER: 'Морозильник',
    SHOWCASE: 'Витрина',
    CASH_REGISTER: 'Кассовый аппарат',
    SCALE: 'Весы',
    SHELVING: 'Стеллажи',
    COOLER: 'Охладитель',
    HEAT_DISPLAY: 'Тепловая витрина',
    SLICER: 'Слайсер',
    PACKAGING_MACHINE: 'Упаковочная машина',
    TERMINAL: 'Платёжный терминал',
    SCANNER: 'Сканер',
    OTHER: 'Другое'
  }
  return labels[type] || type
}

const statusBadgeClass = (status: string) => {
  const classes: Record<string, string> = {
    AVAILABLE: 'badge bg-success',
    LEASED: 'badge bg-primary',
    MAINTENANCE: 'badge bg-warning text-dark',
    SOLD: 'badge bg-info',
    WRITE_OFF: 'badge bg-secondary'
  }
  return classes[status] || 'badge bg-secondary'
}

const statusLabel = (status: string) => {
  const labels: Record<string, string> = {
    AVAILABLE: 'Доступно',
    LEASED: 'В лизинге',
    MAINTENANCE: 'На обслуживании',
    SOLD: 'Продано',
    WRITE_OFF: 'Списано'
  }
  return labels[status] || status
}

const formatMoney = (amount: number) => {
  return new Intl.NumberFormat('ru-RU', {
    style: 'currency',
    currency: 'RUB',
    minimumFractionDigits: 0
  }).format(amount)
}

onMounted(() => {
  loadEquipment()
  loadCategories()
})
</script>

<style scoped>
.equipment-page {
  padding: 1rem;
}

.modal {
  background-color: rgba(0, 0, 0, 0.5);
}
</style>
