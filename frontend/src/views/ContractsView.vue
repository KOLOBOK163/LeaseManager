<template>
  <div class="contracts-page">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h2>Договоры</h2>
      <div class="btn-group">
        <button class="btn btn-success" @click="handleExportAll" :disabled="exportingAll">
          <span v-if="exportingAll" class="spinner-border spinner-border-sm me-1"></span>
          <svg v-else xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" class="me-1">
            <path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5z"/>
            <path d="M7.646 11.854a.5.5 0 0 0 .708 0l3-3a.5.5 0 0 0-.708-.708L8.5 10.293V1.5a.5.5 0 0 0-1 0v8.793L5.354 8.146a.5.5 0 1 0-.708.708l3 3z"/>
          </svg>
          Экспорт в Excel
        </button>
        <button class="btn btn-primary" @click="showCreateModal = true">
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" class="me-1">
            <path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4z"/>
          </svg>
          Новый договор
        </button>
      </div>
    </div>

    <!-- Фильтр и поиск -->
    <div class="card mb-4">
      <div class="card-body">
        <div class="row g-3">
          <div class="col-md-6">
            <input
              type="text"
              class="form-control"
              placeholder="Поиск по номеру договора, клиенту, оборудованию..."
              v-model="searchQuery"
              @input="debouncedSearch"
            />
          </div>
          <div class="col-md-3">
            <select class="form-select" v-model="selectedStatus" @change="loadContracts">
              <option value="">Все статусы</option>
              <option value="DRAFT">Черновик</option>
              <option value="ACTIVE">Активен</option>
              <option value="SUSPENDED">Приостановлен</option>
              <option value="CLOSED">Закрыт</option>
              <option value="CANCELLED">Отменен</option>
            </select>
          </div>
          <div class="col-md-3 text-end">
            <span class="text-muted">Всего: {{ contracts.length }}</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Таблица договоров -->
    <div class="card">
      <div class="card-body">
        <div v-if="loading" class="text-center py-5">
          <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Загрузка...</span>
          </div>
        </div>
        <div v-else-if="contracts.length === 0" class="text-center py-5 text-muted">
          Договоры не найдены
        </div>
        <table v-else class="table table-hover">
          <thead>
            <tr>
              <th>Номер</th>
              <th>Клиент</th>
              <th>Оборудование</th>
              <th>Сумма</th>
              <th>Период</th>
              <th>Статус</th>
              <th class="text-end">Действия</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="contract in contracts" :key="contract.id">
              <td>
                <router-link :to="`/contracts/${contract.id}`" class="text-decoration-none">
                  <strong>{{ contract.contractNumber }}</strong>
                </router-link>
              </td>
              <td>{{ contract.client.fullName }}</td>
              <td>{{ contract.equipment.name }}</td>
              <td>{{ formatMoney(contract.totalAmount) }}</td>
              <td>{{ formatDate(contract.startDate) }} — {{ formatDate(contract.endDate) }}</td>
              <td>
                <span :class="statusBadgeClass(contract.status)">
                  {{ statusLabel(contract.status) }}
                </span>
              </td>
              <td class="text-end">
                <div class="btn-group btn-group-sm">
                  <button class="btn btn-outline-primary" @click="showChangeStatusModal(contract)" title="Сменить статус">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                      <path d="M8 1a2 2 0 0 1 2 2v2H6V3a2 2 0 0 1 2-2zm3 4V3a3 3 0 1 0-6 0v2H3.36a1.5 1.5 0 0 0-1.483 1.277L.85 13.13A1.5 1.5 0 0 0 2.34 15h11.32a1.5 1.5 0 0 0 1.488-1.87l-1.04-4.853A1.5 1.5 0 0 0 12.64 5H11zm-4 7a1 1 0 1 1-2 0 1 1 0 0 1 2 0zm3-1a1 1 0 1 0 0 2 1 1 0 0 0 0-2z"/>
                    </svg>
                  </button>
                  <button class="btn btn-outline-secondary" @click="editContract(contract)" title="Редактировать">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                      <path d="M12.146.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1 0 .708l-10 10a.5.5 0 0 1-.168.11l-5 2a.5.5 0 0 1-.65-.65l2-5a.5.5 0 0 1 .11-.168l10-10zM11.207 2.5 13.5 4.793 14.793 3.5 12.5 1.207 11.207 2.5zm1.586 3L10.5 3.207 4 9.707V10h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.293l6.5-6.5zm-9.761 5.175-.106.106-1.528 3.821 3.821-1.528.106-.106A.5.5 0 0 1 5 12.5V12h-.5a.5.5 0 0 1-.5-.5V11h-.5a.5.5 0 0 1-.468-.325z"/>
                    </svg>
                  </button>
                  <button class="btn btn-outline-danger" @click="deleteContract(contract)" title="Удалить">
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
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">{{ showCreateModal ? 'Новый договор' : 'Редактирование договора' }}</h5>
            <button type="button" class="btn-close" @click="closeModal"></button>
          </div>
          <div class="modal-body">
            <form @submit.prevent="submitForm">
              <div class="row g-3">
                <div class="col-md-6">
                  <label class="form-label">Номер договора</label>
                  <input type="text" class="form-control" v-model="form.contractNumber" placeholder="Автоматически сгенерируется" />
                  <small class="text-muted">Оставьте пустым для автогенерации</small>
                </div>
                <div class="col-md-6">
                  <label class="form-label">Клиент *</label>
                  <select class="form-select" v-model="form.clientId" required>
                    <option value="" disabled>Выберите клиента</option>
                    <option v-for="client in clients" :key="client.id" :value="client.id">
                      {{ client.fullName }}{{ client.companyName ? ' (' + client.companyName + ')' : '' }}
                    </option>
                  </select>
                </div>
                <div class="col-md-6">
                  <label class="form-label">Оборудование *</label>
                  <select class="form-select" v-model="form.equipmentId" @change="onEquipmentChange" required>
                    <option value="" disabled>Выберите оборудование</option>
                    <option v-for="eq in equipment" :key="eq.id" :value="eq.id">
                      {{ eq.name }} ({{ statusLabel(eq.status) }})
                    </option>
                  </select>
                </div>
                <div class="col-md-6">
                  <label class="form-label">Сумма договора *</label>
                  <input type="number" step="0.01" class="form-control" v-model="form.totalAmount" required readonly />
                  <small class="text-muted">Автоматически заполняется из цены оборудования</small>
                </div>
                <div class="col-md-6">
                  <label class="form-label">Дата начала *</label>
                  <input type="date" class="form-control" v-model="form.startDate" required />
                </div>
                <div class="col-md-6">
                  <label class="form-label">Дата окончания *</label>
                  <input type="date" class="form-control" v-model="form.endDate" required />
                </div>
                <div class="col-md-6">
                  <label class="form-label">Процентная ставка (%)</label>
                  <input type="number" step="0.01" class="form-control" v-model="form.interestRate" />
                </div>
                <div class="col-md-6">
                  <label class="form-label">Период платежей (мес.)</label>
                  <input type="number" class="form-control" v-model.number="form.periodMonths" />
                  <small class="text-muted">Автоматически рассчитывается из дат договора</small>
                </div>

                <!-- Предпросмотр расчёта -->
                <div v-if="monthlyPaymentPreview > 0" class="col-12">
                  <div class="alert alert-info">
                    <h6 class="alert-heading mb-2">📊 Предпросмотр расчёта (аннуитетные платежи)</h6>
                    <div class="row g-2">
                      <div class="col-md-4">
                        <small class="text-muted d-block">Ежемесячный платёж:</small>
                        <strong>{{ formatMoney(monthlyPaymentPreview) }}</strong>
                      </div>
                      <div class="col-md-4">
                        <small class="text-muted d-block">Количество платежей:</small>
                        <strong>{{ form.periodMonths }} мес.</strong>
                      </div>
                      <div class="col-md-4">
                        <small class="text-muted d-block">Общая сумма выплат:</small>
                        <strong>{{ formatMoney(monthlyPaymentPreview * (form.periodMonths || 0)) }}</strong>
                      </div>
                    </div>
                    <small class="text-muted mt-2 d-block">
                      * График платежей будет автоматически сгенерирован после создания договора
                    </small>
                  </div>
                </div>

                <div class="col-12">
                  <label class="form-label">Описание</label>
                  <textarea class="form-control" v-model="form.description" rows="3"></textarea>
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

    <!-- Модальное окно смены статуса -->
    <div v-if="showStatusModal" class="modal fade show d-block" tabindex="-1">
      <div class="modal-dialog modal-sm">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Смена статуса</h5>
            <button type="button" class="btn-close" @click="showStatusModal = false"></button>
          </div>
          <div class="modal-body">
            <p class="mb-2"><strong>{{ selectedContract?.contractNumber }}</strong></p>
            <label class="form-label">Новый статус:</label>
            <select class="form-select" v-model="newStatus">
              <option value="DRAFT">Черновик</option>
              <option value="ACTIVE">Активен</option>
              <option value="SUSPENDED">Приостановлен</option>
              <option value="CLOSED">Закрыт</option>
              <option value="CANCELLED">Отменен</option>
            </select>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" @click="showStatusModal = false">Отмена</button>
            <button type="button" class="btn btn-primary" @click="submitStatusChange" :disabled="submittingStatus">
              {{ submittingStatus ? 'Сохранение...' : 'Применить' }}
            </button>
          </div>
        </div>
      </div>
    </div>
    <div v-if="showStatusModal" class="modal-backdrop fade show"></div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, watch } from 'vue'
import { contractApi, type Contract, type CreateContractRequest, type UpdateContractRequest, type ContractStatus, type Client, type Equipment } from '@/types/contract'
import { exportApi, downloadFile } from '@/api/export'

const contracts = ref<Contract[]>([])
const clients = ref<Client[]>([])
const equipment = ref<Equipment[]>([])
const loading = ref(false)
const exportingAll = ref(false)
const selectedStatus = ref('')
const searchQuery = ref('')
const showCreateModal = ref(false)
const showEditModal = ref(false)
const showStatusModal = ref(false)
const submitting = ref(false)
const submittingStatus = ref(false)
const editingContractId = ref<number | null>(null)
const selectedContract = ref<Contract | null>(null)
const newStatus = ref<ContractStatus>('DRAFT')

const form = reactive<CreateContractRequest>({
  contractNumber: '',
  clientId: 0,
  equipmentId: 0,
  startDate: '',
  endDate: '',
  totalAmount: 0,
  interestRate: undefined,
  periodMonths: undefined,
  description: ''
})

const loadContracts = async () => {
  loading.value = true
  try {
    contracts.value = await contractApi.getContracts(
      selectedStatus.value || undefined,
      searchQuery.value || undefined
    )
  } catch (error) {
    console.error('Failed to load contracts:', error)
  } finally {
    loading.value = false
  }
}

let searchTimeout: ReturnType<typeof setTimeout>
const debouncedSearch = () => {
  clearTimeout(searchTimeout)
  searchTimeout = setTimeout(() => {
    loadContracts()
  }, 300)
}

const loadClients = async () => {
  try {
    clients.value = await contractApi.getClients()
  } catch (error) {
    console.error('Failed to load clients:', error)
  }
}

const loadEquipment = async () => {
  try {
    equipment.value = await contractApi.getEquipment()
  } catch (error) {
    console.error('Failed to load equipment:', error)
  }
}

const onEquipmentChange = () => {
  const selectedEquipment = equipment.value.find(eq => eq.id === form.equipmentId)
  if (selectedEquipment) {
    form.totalAmount = Number(selectedEquipment.price)
  }
}

// Функция расчёта разницы в месяцах между двумя датами
const calculateMonthsDifference = (startDate: string, endDate: string): number => {
  if (!startDate || !endDate) return 0

  const start = new Date(startDate)
  const end = new Date(endDate)

  if (end <= start) return 0

  const yearsDiff = end.getFullYear() - start.getFullYear()
  const monthsDiff = end.getMonth() - start.getMonth()

  return yearsDiff * 12 + monthsDiff
}

// Функция расчёта ежемесячного аннуитетного платежа
const calculateAnnuityPayment = (
  totalAmount: number,
  annualRate: number | undefined,
  periods: number
): number => {
  if (!totalAmount || !periods || periods <= 0) return 0
  if (!annualRate || annualRate === 0) {
    // Если ставка 0%, то просто делим сумму на количество периодов
    return totalAmount / periods
  }

  // Месячная процентная ставка
  const monthlyRate = annualRate / 100 / 12

  // Аннуитетный коэффициент: A = P * (r * (1+r)^n) / ((1+r)^n - 1)
  const onePlusR = 1 + monthlyRate
  const onePlusRpowN = Math.pow(onePlusR, periods)
  const annuityFactor = (monthlyRate * onePlusRpowN) / (onePlusRpowN - 1)

  return totalAmount * annuityFactor
}

// Вычисляемое свойство для предпросмотра ежемесячного платежа
const monthlyPaymentPreview = ref<number>(0)

// Автоматический расчёт периода платежей при изменении дат
watch([() => form.startDate, () => form.endDate], ([startDate, endDate]) => {
  if (startDate && endDate) {
    const months = calculateMonthsDifference(startDate, endDate)
    if (months > 0) {
      form.periodMonths = months
    }
  }
})

// Автоматический расчёт предпросмотра платежа при изменении параметров
watch(
  [() => form.totalAmount, () => form.interestRate, () => form.periodMonths],
  ([totalAmount, interestRate, periodMonths]) => {
    if (totalAmount && periodMonths && periodMonths > 0) {
      monthlyPaymentPreview.value = calculateAnnuityPayment(
        totalAmount,
        interestRate,
        periodMonths
      )
    } else {
      monthlyPaymentPreview.value = 0
    }
  }
)

const editContract = (contract: Contract) => {
  editingContractId.value = contract.id
  form.contractNumber = contract.contractNumber
  form.clientId = contract.client.id
  form.equipmentId = contract.equipment.id
  form.startDate = contract.startDate
  form.endDate = contract.endDate
  form.totalAmount = Number(contract.totalAmount)
  form.interestRate = contract.interestRate ? Number(contract.interestRate) : undefined
  form.periodMonths = contract.paymentPeriodMonths || undefined
  form.description = contract.description || ''
  showEditModal.value = true
}

const submitForm = async () => {
  submitting.value = true
  try {
    if (editingContractId.value) {
      await contractApi.updateContract(editingContractId.value, form as UpdateContractRequest)
    } else {
      // Если номер договора пустой, отправляем null для автогенерации
      const requestData = {
        ...form,
        contractNumber: form.contractNumber.trim() || null
      }
      const createdContract = await contractApi.createContract(requestData)
      // Автоматически генерируем график платежей для нового договора
      if (form.periodMonths && form.periodMonths > 0) {
        try {
          await contractApi.generatePaymentSchedule(createdContract.id, form.periodMonths)
        } catch (error) {
          console.error('Failed to generate payment schedule:', error)
          alert('Договор создан, но не удалось сгенерировать график платежей. Вы можете сделать это позже.')
        }
      }
    }
    closeModal()
    loadContracts()
  } catch (error) {
    console.error('Failed to save contract:', error)
    alert('Ошибка при сохранении договора')
  } finally {
    submitting.value = false
  }
}

const showChangeStatusModal = (contract: Contract) => {
  selectedContract.value = contract
  newStatus.value = contract.status
  showStatusModal.value = true
}

const submitStatusChange = async () => {
  if (!selectedContract.value) return
  submittingStatus.value = true
  try {
    await contractApi.changeStatus(selectedContract.value.id, newStatus.value)
    showStatusModal.value = false
    loadContracts()
  } catch (error) {
    console.error('Failed to change status:', error)
    alert('Ошибка при смене статуса')
  } finally {
    submittingStatus.value = false
  }
}

const deleteContract = async (contract: Contract) => {
  if (!confirm(`Удалить договор "${contract.contractNumber}"?`)) return
  try {
    await contractApi.deleteContract(contract.id)
    loadContracts()
  } catch (error) {
    console.error('Failed to delete contract:', error)
    alert('Ошибка при удалении договора')
  }
}

const handleExportAll = async () => {
  exportingAll.value = true
  try {
    const blob = await exportApi.exportAllContracts()
    const filename = `contracts_${new Date().toISOString().split('T')[0]}.xlsx`
    downloadFile(blob, filename)
  } catch (error) {
    console.error('Failed to export contracts:', error)
    alert('Ошибка при экспорте договоров')
  } finally {
    exportingAll.value = false
  }
}

const closeModal = () => {
  showCreateModal.value = false
  showEditModal.value = false
  editingContractId.value = null
  Object.assign(form, {
    contractNumber: '',
    clientId: 0,
    equipmentId: 0,
    startDate: '',
    endDate: '',
    totalAmount: 0,
    interestRate: undefined,
    periodMonths: undefined,
    description: ''
  })
}

const statusBadgeClass = (status: string) => {
  const classes: Record<string, string> = {
    DRAFT: 'badge bg-secondary',
    ACTIVE: 'badge bg-success',
    SUSPENDED: 'badge bg-warning text-dark',
    CLOSED: 'badge bg-dark',
    CANCELLED: 'badge bg-danger'
  }
  return classes[status] || 'badge bg-secondary'
}

const statusLabel = (status: string) => {
  const labels: Record<string, string> = {
    DRAFT: 'Черновик',
    ACTIVE: 'Активен',
    SUSPENDED: 'Приостановлен',
    CLOSED: 'Закрыт',
    CANCELLED: 'Отменен',
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

const formatDate = (dateString: string) => {
  if (!dateString) return '—'
  return new Date(dateString).toLocaleDateString('ru-RU')
}

onMounted(() => {
  loadContracts()
  loadClients()
  loadEquipment()
})
</script>

<style scoped>
.contracts-page {
  padding: 1rem;
}

.modal {
  background-color: rgba(0, 0, 0, 0.5);
}
</style>
