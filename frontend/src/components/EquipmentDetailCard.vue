<template>
  <div class="equipment-detail-card">
    <div class="card">
      <div class="card-header bg-primary text-white">
        <h4 class="mb-0">{{ equipment.name }}</h4>
      </div>
      <div class="card-body">
        <div class="row">
          <!-- Левая колонка - изображение и основная информация -->
          <div class="col-md-5">
            <div class="equipment-image mb-4">
              <img
                :src="getEquipmentImage(equipment.equipmentType)"
                :alt="equipment.name"
                class="img-fluid rounded shadow-sm"
              />
            </div>

            <div class="price-block mb-4">
              <div class="text-muted mb-1">Стоимость оборудования</div>
              <h2 class="text-primary mb-0">{{ formatMoney(equipment.price) }}</h2>
            </div>

            <div class="status-block mb-4">
              <div class="text-muted mb-2">Статус</div>
              <span :class="statusBadgeClass(equipment.status)" class="fs-5">
                {{ statusLabel(equipment.status) }}
              </span>
            </div>

            <div class="quick-info">
              <h6 class="mb-3">Быстрая информация</h6>
              <table class="table table-sm">
                <tbody>
                  <tr>
                    <td class="text-muted">Производитель:</td>
                    <td><strong>{{ equipment.manufacturer || '—' }}</strong></td>
                  </tr>
                  <tr>
                    <td class="text-muted">Модель:</td>
                    <td><strong>{{ equipment.model || '—' }}</strong></td>
                  </tr>
                  <tr>
                    <td class="text-muted">Год выпуска:</td>
                    <td><strong>{{ equipment.yearOfManufacture || '—' }}</strong></td>
                  </tr>
                  <tr>
                    <td class="text-muted">Серийный номер:</td>
                    <td><strong>{{ equipment.serialNumber || '—' }}</strong></td>
                  </tr>
                  <tr>
                    <td class="text-muted">Категория:</td>
                    <td><strong>{{ equipment.categoryName }}</strong></td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>

          <!-- Правая колонка - детальные характеристики -->
          <div class="col-md-7">
            <!-- Описание -->
            <div class="mb-4" v-if="equipment.description">
              <h5>Описание</h5>
              <p class="text-muted">{{ equipment.description }}</p>
            </div>

            <!-- Технические характеристики -->
            <div class="mb-4">
              <h5 class="mb-3">Технические характеристики</h5>
              <div class="row g-3">
                <div class="col-md-6" v-if="equipment.equipmentType">
                  <div class="spec-item">
                    <div class="spec-label">Тип оборудования</div>
                    <div class="spec-value">{{ equipmentTypeLabel(equipment.equipmentType) }}</div>
                  </div>
                </div>
                <div class="col-md-6" v-if="equipment.dimensions">
                  <div class="spec-item">
                    <div class="spec-label">Габариты (Д×Ш×В)</div>
                    <div class="spec-value">{{ equipment.dimensions }} см</div>
                  </div>
                </div>
                <div class="col-md-6" v-if="equipment.weight">
                  <div class="spec-item">
                    <div class="spec-label">Вес</div>
                    <div class="spec-value">{{ equipment.weight }} кг</div>
                  </div>
                </div>
                <div class="col-md-6" v-if="equipment.volume">
                  <div class="spec-item">
                    <div class="spec-label">Объём</div>
                    <div class="spec-value">{{ equipment.volume }} л</div>
                  </div>
                </div>
                <div class="col-md-6" v-if="equipment.powerConsumption">
                  <div class="spec-item">
                    <div class="spec-label">Потребляемая мощность</div>
                    <div class="spec-value">{{ equipment.powerConsumption }} кВт</div>
                  </div>
                </div>
                <div class="col-md-6" v-if="equipment.voltage">
                  <div class="spec-item">
                    <div class="spec-label">Напряжение</div>
                    <div class="spec-value">{{ equipment.voltage }} В</div>
                  </div>
                </div>
                <div class="col-md-6" v-if="equipment.energyClass">
                  <div class="spec-item">
                    <div class="spec-label">Энергокласс</div>
                    <div class="spec-value">
                      <span class="badge bg-success">{{ equipment.energyClass }}</span>
                    </div>
                  </div>
                </div>
                <div class="col-md-6" v-if="equipment.countryOfOrigin">
                  <div class="spec-item">
                    <div class="spec-label">Страна производства</div>
                    <div class="spec-value">{{ equipment.countryOfOrigin }}</div>
                  </div>
                </div>
                <div class="col-md-6" v-if="hasTemperatureRange">
                  <div class="spec-item">
                    <div class="spec-label">Температурный режим</div>
                    <div class="spec-value">
                      {{ equipment.minTemperature }}°C ... {{ equipment.maxTemperature }}°C
                    </div>
                  </div>
                </div>
                <div class="col-md-6" v-if="equipment.bodyMaterial">
                  <div class="spec-item">
                    <div class="spec-label">Материал корпуса</div>
                    <div class="spec-value">{{ equipment.bodyMaterial }}</div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Гарантия и обслуживание -->
            <div class="mb-4" v-if="hasMaintenanceInfo">
              <h5 class="mb-3">Гарантия и обслуживание</h5>
              <div class="row g-3">
                <div class="col-md-6" v-if="equipment.warrantyMonths">
                  <div class="spec-item">
                    <div class="spec-label">Гарантийный срок</div>
                    <div class="spec-value">{{ equipment.warrantyMonths }} мес.</div>
                  </div>
                </div>
                <div class="col-md-6" v-if="equipment.serviceContractNumber">
                  <div class="spec-item">
                    <div class="spec-label">Сервисный контракт</div>
                    <div class="spec-value">{{ equipment.serviceContractNumber }}</div>
                  </div>
                </div>
                <div class="col-md-6" v-if="equipment.lastMaintenanceDate">
                  <div class="spec-item">
                    <div class="spec-label">Последнее ТО</div>
                    <div class="spec-value">{{ formatDate(equipment.lastMaintenanceDate) }}</div>
                  </div>
                </div>
                <div class="col-md-6" v-if="equipment.nextMaintenanceDate">
                  <div class="spec-item">
                    <div class="spec-label">Следующее ТО</div>
                    <div class="spec-value">{{ formatDate(equipment.nextMaintenanceDate) }}</div>
                  </div>
                </div>
                <div class="col-12" v-if="equipment.maintenanceNotes">
                  <div class="spec-item">
                    <div class="spec-label">Примечания</div>
                    <div class="spec-value text-muted">{{ equipment.maintenanceNotes }}</div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Установка -->
            <div class="mb-4" v-if="equipment.installationAddress || equipment.installationDate">
              <h5 class="mb-3">Установка</h5>
              <div class="row g-3">
                <div class="col-md-8" v-if="equipment.installationAddress">
                  <div class="spec-item">
                    <div class="spec-label">Адрес установки</div>
                    <div class="spec-value">{{ equipment.installationAddress }}</div>
                  </div>
                </div>
                <div class="col-md-4" v-if="equipment.installationDate">
                  <div class="spec-item">
                    <div class="spec-label">Дата установки</div>
                    <div class="spec-value">{{ formatDate(equipment.installationDate) }}</div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Преимущества -->
            <div class="advantages-block">
              <h5 class="mb-3">Преимущества лизинга</h5>
              <ul class="list-unstyled">
                <li class="mb-2">
                  <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="text-success me-2" viewBox="0 0 16 16">
                    <path d="M10.97 4.97a.75.75 0 0 1 1.07 1.05l-3.99 4.99a.75.75 0 0 1-1.08.02L4.324 8.384a.75.75 0 1 1 1.06-1.06l2.094 2.093 3.473-4.425a.267.267 0 0 1 .02-.022z"/>
                  </svg>
                  Экономия оборотных средств
                </li>
                <li class="mb-2">
                  <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="text-success me-2" viewBox="0 0 16 16">
                    <path d="M10.97 4.97a.75.75 0 0 1 1.07 1.05l-3.99 4.99a.75.75 0 0 1-1.08.02L4.324 8.384a.75.75 0 1 1 1.06-1.06l2.094 2.093 3.473-4.425a.267.267 0 0 1 .02-.022z"/>
                  </svg>
                  Налоговые преимущества
                </li>
                <li class="mb-2">
                  <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="text-success me-2" viewBox="0 0 16 16">
                    <path d="M10.97 4.97a.75.75 0 0 1 1.07 1.05l-3.99 4.99a.75.75 0 0 1-1.08.02L4.324 8.384a.75.75 0 1 1 1.06-1.06l2.094 2.093 3.473-4.425a.267.267 0 0 1 .02-.022z"/>
                  </svg>
                  Гибкие условия платежей
                </li>
                <li class="mb-2">
                  <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="text-success me-2" viewBox="0 0 16 16">
                    <path d="M10.97 4.97a.75.75 0 0 1 1.07 1.05l-3.99 4.99a.75.75 0 0 1-1.08.02L4.324 8.384a.75.75 0 1 1 1.06-1.06l2.094 2.093 3.473-4.425a.267.267 0 0 1 .02-.022z"/>
                  </svg>
                  Возможность выкупа по остаточной стоимости
                </li>
              </ul>
            </div>
          </div>
        </div>
      </div>
      <div class="card-footer bg-light">
        <div class="d-flex justify-content-between align-items-center">
          <button class="btn btn-outline-secondary" @click="$emit('close')">
            Закрыть
          </button>
          <div>
            <button class="btn btn-primary me-2" @click="$emit('edit', equipment)">
              Редактировать
            </button>
            <button
              class="btn btn-success"
              @click="$emit('create-contract', equipment)"
              v-if="equipment.status === 'AVAILABLE'"
            >
              Оформить лизинг
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import type { Equipment } from '@/types/equipment'

interface Props {
  equipment: Equipment
}

const props = defineProps<Props>()

defineEmits<{
  close: []
  edit: [equipment: Equipment]
  'create-contract': [equipment: Equipment]
}>()

const hasTemperatureRange = computed(() => {
  return props.equipment.minTemperature !== null &&
         props.equipment.minTemperature !== undefined &&
         props.equipment.maxTemperature !== null &&
         props.equipment.maxTemperature !== undefined
})

const hasMaintenanceInfo = computed(() => {
  return props.equipment.warrantyMonths ||
         props.equipment.serviceContractNumber ||
         props.equipment.lastMaintenanceDate ||
         props.equipment.nextMaintenanceDate ||
         props.equipment.maintenanceNotes
})

const getEquipmentImage = (type?: string) => {
  // Заглушки изображений по типу оборудования
  const images: Record<string, string> = {
    REFRIGERATOR: 'https://via.placeholder.com/400x300/4A90E2/FFFFFF?text=Холодильник',
    FREEZER: 'https://via.placeholder.com/400x300/5C9EAD/FFFFFF?text=Морозильник',
    SHOWCASE: 'https://via.placeholder.com/400x300/7CB342/FFFFFF?text=Витрина',
    CASH_REGISTER: 'https://via.placeholder.com/400x300/FFA726/FFFFFF?text=Касса',
    SCALE: 'https://via.placeholder.com/400x300/AB47BC/FFFFFF?text=Весы',
    SHELVING: 'https://via.placeholder.com/400x300/8D6E63/FFFFFF?text=Стеллажи',
    COOLER: 'https://via.placeholder.com/400x300/42A5F5/FFFFFF?text=Охладитель',
    HEAT_DISPLAY: 'https://via.placeholder.com/400x300/EF5350/FFFFFF?text=Тепловая+витрина',
    SLICER: 'https://via.placeholder.com/400x300/78909C/FFFFFF?text=Слайсер',
    PACKAGING_MACHINE: 'https://via.placeholder.com/400x300/9CCC65/FFFFFF?text=Упаковщик',
    TERMINAL: 'https://via.placeholder.com/400x300/26A69A/FFFFFF?text=Терминал',
    SCANNER: 'https://via.placeholder.com/400x300/5C6BC0/FFFFFF?text=Сканер',
  }
  return type && images[type] ? images[type] : 'https://via.placeholder.com/400x300/9E9E9E/FFFFFF?text=Оборудование'
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

const formatDate = (date: string) => {
  return new Date(date).toLocaleDateString('ru-RU')
}
</script>

<style scoped>
.equipment-detail-card {
  max-width: 1200px;
  margin: 0 auto;
}

.equipment-image {
  background: #f8f9fa;
  border-radius: 8px;
  overflow: hidden;
}

.equipment-image img {
  width: 100%;
  height: auto;
  object-fit: cover;
}

.price-block {
  padding: 1.5rem;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 8px;
  color: white;
}

.price-block h2 {
  color: white;
  font-weight: bold;
}

.status-block {
  padding: 1rem;
  background: #f8f9fa;
  border-radius: 8px;
}

.spec-item {
  padding: 0.75rem;
  background: #f8f9fa;
  border-radius: 6px;
  height: 100%;
}

.spec-label {
  font-size: 0.875rem;
  color: #6c757d;
  margin-bottom: 0.25rem;
}

.spec-value {
  font-weight: 600;
  color: #212529;
}

.advantages-block {
  padding: 1.5rem;
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
  border-radius: 8px;
}

.advantages-block li {
  display: flex;
  align-items: center;
}
</style>
