<template>
  <div class="contract-detail-page">
    <div v-if="loading" class="text-center py-5">
      <div class="spinner-border text-primary" role="status">
        <span class="visually-hidden">Загрузка...</span>
      </div>
    </div>

    <div v-else-if="!contract" class="alert alert-danger">
      Договор не найден
    </div>

    <template v-else>
      <!-- Заголовок -->
      <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
          <nav aria-label="breadcrumb" class="mb-2">
            <ol class="breadcrumb">
              <li class="breadcrumb-item"><router-link to="/contracts">Договоры</router-link></li>
              <li class="breadcrumb-item active">{{ contract.contractNumber }}</li>
            </ol>
          </nav>
          <h2>Договор № {{ contract.contractNumber }}</h2>
        </div>
        <div>
          <button class="btn btn-success me-2" @click="handleExport" :disabled="exporting">
            <span v-if="exporting" class="spinner-border spinner-border-sm me-1"></span>
            <svg v-else xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" class="me-1">
              <path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5z"/>
              <path d="M7.646 11.854a.5.5 0 0 0 .708 0l3-3a.5.5 0 0 0-.708-.708L8.5 10.293V1.5a.5.5 0 0 0-1 0v8.793L5.354 8.146a.5.5 0 1 0-.708.708l3 3z"/>
            </svg>
            Экспорт в Excel
          </button>
          <router-link :to="`/contracts/${contract.id}/payments`" class="btn btn-outline-primary me-2">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" class="me-1">
              <path d="M4 10.781c.148 1.667 1.513 2.85 3.591 3.003V15h1.043v-1.216c2.27-.179 3.678-1.438 3.678-3.3 0-1.59-.947-2.51-2.956-3.028l-.722-.187V3.467c1.122.11 1.879.714 2.07 1.616h1.47c-.166-1.6-1.54-2.748-3.54-2.987V1H7.591v1.233c-1.939.23-3.27 1.272-3.27 3.138 0 1.72 1.064 2.525 2.874 2.977l.673.179v3.822c-1.166-.11-1.955-.694-2.124-1.614H4.28l-.28 1.222z"/>
            </svg>
            График платежей
          </router-link>
          <button class="btn btn-primary me-2" @click="showChangeStatusModal = true">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" class="me-1">
              <path d="M8 1a2 2 0 0 1 2 2v2H6V3a2 2 0 0 1 2-2zm3 4V3a3 3 0 1 0-6 0v2H3.36a1.5 1.5 0 0 0-1.483 1.277L.85 13.13A1.5 1.5 0 0 0 2.34 15h11.32a1.5 1.5 0 0 0 1.488-1.87l-1.04-4.853A1.5 1.5 0 0 0 12.64 5H11zm-4 7a1 1 0 1 1-2 0 1 1 0 0 1 2 0zm3-1a1 1 0 1 0 0 2 1 1 0 0 0 0-2z"/>
            </svg>
            Сменить статус
          </button>
          <button class="btn btn-outline-secondary" @click="$router.push('/contracts')">
            Назад
          </button>
        </div>
      </div>

      <div class="row">
        <!-- Информация о договоре -->
        <div class="col-lg-6 mb-4">
          <div class="card">
            <div class="card-header bg-white">
              <h5 class="mb-0">Информация о договоре</h5>
            </div>
            <div class="card-body">
              <div class="mb-3">
                <label class="text-muted small">Статус</label>
                <div>
                  <span :class="statusBadgeClass(contract.status)">
                    {{ statusLabel(contract.status) }}
                  </span>
                </div>
              </div>
              <div class="mb-3">
                <label class="text-muted small">Клиент</label>
                <div>{{ contract.client.fullName }}</div>
              </div>
              <div class="mb-3">
                <label class="text-muted small">Оборудование</label>
                <div>{{ contract.equipment.name }}</div>
              </div>
              <div class="mb-3">
                <label class="text-muted small">Сумма договора</label>
                <div><strong>{{ formatMoney(contract.totalAmount) }}</strong></div>
              </div>
              <div class="mb-3">
                <label class="text-muted small">Процентная ставка</label>
                <div>{{ contract.interestRate ? contract.interestRate + '%' : '—' }}</div>
              </div>
              <div class="mb-3">
                <label class="text-muted small">Период платежей</label>
                <div>{{ contract.paymentPeriodMonths ? contract.paymentPeriodMonths + ' мес.' : '—' }}</div>
              </div>
              <div class="mb-3">
                <label class="text-muted small">Дата начала</label>
                <div>{{ formatDate(contract.startDate) }}</div>
              </div>
              <div class="mb-3">
                <label class="text-muted small">Дата окончания</label>
                <div>{{ formatDate(contract.endDate) }}</div>
              </div>
              <div class="mb-3">
                <label class="text-muted small">Дата создания</label>
                <div>{{ formatDate(contract.createdDate) }}</div>
              </div>
              <div class="mb-3" v-if="contract.description">
                <label class="text-muted small">Описание</label>
                <div>{{ contract.description }}</div>
              </div>
            </div>
          </div>

          <!-- Статистика по договору -->
          <div class="card mt-4" v-if="statistics">
            <div class="card-header bg-white">
              <h5 class="mb-0">Статистика</h5>
            </div>
            <div class="card-body">
              <div class="mb-3">
                <label class="text-muted small">Оплачено</label>
                <div><strong class="text-success">{{ formatMoney(statistics.paidAmount) }}</strong></div>
              </div>
              <div class="mb-3">
                <label class="text-muted small">Остаток долга</label>
                <div><strong class="text-primary">{{ formatMoney(statistics.remainingAmount) }}</strong></div>
              </div>
              <div class="mb-3">
                <label class="text-muted small">Платежей оплачено</label>
                <div>{{ statistics.paidPayments }} из {{ statistics.totalPayments }}</div>
              </div>
              <div class="mb-3" v-if="statistics.overduePayments > 0">
                <label class="text-muted small">Просроченных платежей</label>
                <div><strong class="text-danger">{{ statistics.overduePayments }}</strong></div>
              </div>
            </div>
          </div>
        </div>

        <!-- График платежей -->
        <div class="col-lg-6 mb-4">
          <div class="card">
            <div class="card-header bg-white d-flex justify-content-between align-items-center">
              <h5 class="mb-0">График платежей</h5>
              <span class="badge bg-secondary">{{ contract.paymentSchedules?.length || 0 }}</span>
            </div>
            <div class="card-body">
              <div v-if="!contract.paymentSchedules || contract.paymentSchedules.length === 0" class="text-center py-5 text-muted">
                График платежей не сформирован
              </div>
              <div v-else class="table-responsive">
                <table class="table table-sm">
                  <thead>
                    <tr>
                      <th>№</th>
                      <th>Дата</th>
                      <th>Сумма</th>
                      <th>Статус</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="schedule in contract.paymentSchedules" :key="schedule.id">
                      <td>{{ schedule.periodNumber }}</td>
                      <td>{{ formatDate(schedule.paymentDate) }}</td>
                      <td>{{ formatMoney(schedule.totalAmount) }}</td>
                      <td>
                        <span :class="scheduleStatusClass(schedule.status)">
                          {{ scheduleStatusLabel(schedule.status) }}
                        </span>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          </div>

          <!-- Страхование -->
          <div class="card mt-4">
            <div class="card-header bg-white d-flex justify-content-between align-items-center">
              <h5 class="mb-0">Страхование</h5>
              <button
                v-if="!hasInsurance"
                class="btn btn-sm btn-primary"
                @click="openInsuranceModal">
                Добавить
              </button>
              <button
                v-else
                class="btn btn-sm btn-outline-primary"
                @click="openInsuranceModal">
                Изменить
              </button>
            </div>
            <div class="card-body">
              <div v-if="!hasInsurance" class="text-center py-4 text-muted">
                Страхование не оформлено
              </div>
              <div v-else>
                <div class="mb-2">
                  <label class="text-muted small">Страховая компания</label>
                  <div>{{ contract.insuranceCompany }}</div>
                </div>
                <div class="mb-2">
                  <label class="text-muted small">Номер полиса</label>
                  <div>{{ contract.insurancePolicyNumber }}</div>
                </div>
                <div class="mb-2">
                  <label class="text-muted small">Тип страхования</label>
                  <div>{{ insuranceTypeLabel(contract.insuranceType) }}</div>
                </div>
                <div class="mb-2">
                  <label class="text-muted small">Сумма покрытия</label>
                  <div><strong>{{ formatMoney(contract.insuranceCoverageAmount) }}</strong></div>
                </div>
                <div class="mb-2">
                  <label class="text-muted small">Годовая премия</label>
                  <div>{{ formatMoney(contract.insurancePremiumAnnual) }}</div>
                </div>
                <div class="mb-2">
                  <label class="text-muted small">Ежемесячная премия</label>
                  <div>{{ formatMoney(contract.insurancePremiumMonthly) }}</div>
                </div>
                <div class="mb-2">
                  <label class="text-muted small">Период действия</label>
                  <div>
                    {{ formatDate(contract.insuranceStartDate) }} — {{ formatDate(contract.insuranceExpiryDate) }}
                    <span v-if="isInsuranceExpiringSoon" class="badge bg-warning text-dark ms-2">
                      Истекает скоро
                    </span>
                    <span v-if="isInsuranceExpired" class="badge bg-danger ms-2">
                      Просрочено
                    </span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Модальное окно смены статуса -->
      <div v-if="showChangeStatusModal" class="modal fade show d-block" tabindex="-1">
        <div class="modal-dialog modal-sm">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title">Смена статуса</h5>
              <button type="button" class="btn-close" @click="showChangeStatusModal = false"></button>
            </div>
            <div class="modal-body">
              <p class="mb-2"><strong>{{ contract.contractNumber }}</strong></p>
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
              <button type="button" class="btn btn-secondary" @click="showChangeStatusModal = false">Отмена</button>
              <button type="button" class="btn btn-primary" @click="submitStatusChange" :disabled="submittingStatus">
                {{ submittingStatus ? 'Сохранение...' : 'Применить' }}
              </button>
            </div>
          </div>
        </div>
      </div>
      <div v-if="showChangeStatusModal" class="modal-backdrop fade show"></div>

      <!-- Модальное окно страхования -->
      <div v-if="showInsuranceModal" class="modal fade show d-block" tabindex="-1">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title">{{ hasInsurance ? 'Изменить страхование' : 'Добавить страхование' }}</h5>
              <button type="button" class="btn-close" @click="closeInsuranceModal"></button>
            </div>
            <div class="modal-body">
              <form @submit.prevent="submitInsurance">
                <div class="mb-3">
                  <label class="form-label">Страховая компания *</label>
                  <input v-model="insuranceForm.insuranceCompany" type="text" class="form-control" required>
                </div>
                <div class="mb-3">
                  <label class="form-label">Номер полиса *</label>
                  <input v-model="insuranceForm.insurancePolicyNumber" type="text" class="form-control" required>
                </div>
                <div class="mb-3">
                  <label class="form-label">Тип страхования *</label>
                  <select v-model="insuranceForm.insuranceType" class="form-select" required>
                    <option value="FULL">Полное</option>
                    <option value="PARTIAL">Частичное</option>
                    <option value="THEFT_ONLY">Только от кражи</option>
                    <option value="DAMAGE_ONLY">Только от повреждений</option>
                  </select>
                </div>
                <div class="mb-3">
                  <label class="form-label">Сумма покрытия (₽) *</label>
                  <input v-model.number="insuranceForm.insuranceCoverageAmount" type="number" class="form-control" required>
                </div>
                <div class="mb-3">
                  <label class="form-label">Годовая премия (₽)</label>
                  <div class="input-group">
                    <input v-model.number="insuranceForm.insurancePremiumAnnual" type="number" class="form-control">
                    <button type="button" class="btn btn-outline-secondary" @click="calculatePremium">
                      Рассчитать
                    </button>
                  </div>
                  <small class="text-muted">Оставьте пустым для автоматического расчёта</small>
                </div>
                <div class="mb-3">
                  <label class="form-label">Дата начала *</label>
                  <input v-model="insuranceForm.insuranceStartDate" type="date" class="form-control" required>
                </div>
                <div class="mb-3">
                  <label class="form-label">Дата окончания *</label>
                  <input v-model="insuranceForm.insuranceExpiryDate" type="date" class="form-control" required>
                </div>
              </form>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" @click="closeInsuranceModal">Отмена</button>
              <button type="button" class="btn btn-primary" @click="submitInsurance" :disabled="submittingInsurance">
                {{ submittingInsurance ? 'Сохранение...' : 'Сохранить' }}
              </button>
            </div>
          </div>
        </div>
      </div>
      <div v-if="showInsuranceModal" class="modal-backdrop fade show"></div>
    </template>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { contractApi, type Contract, type ContractStatus, type ContractStatistics } from '@/types/contract'
import { insuranceApi } from '@/api/insurance'
import type { InsuranceRequest } from '@/types/insurance'
import { exportApi, downloadFile } from '@/api/export'

const route = useRoute()
const contract = ref<Contract | null>(null)
const statistics = ref<ContractStatistics | null>(null)
const loading = ref(true)
const exporting = ref(false)
const showChangeStatusModal = ref(false)
const submittingStatus = ref(false)
const newStatus = ref<ContractStatus>('DRAFT')

const showInsuranceModal = ref(false)
const submittingInsurance = ref(false)
const insuranceForm = ref<InsuranceRequest>({
  insuranceCompany: '',
  insurancePolicyNumber: '',
  insuranceType: 'FULL',
  insuranceCoverageAmount: 0,
  insurancePremiumAnnual: 0,
  insuranceStartDate: '',
  insuranceExpiryDate: ''
})

const hasInsurance = computed(() => {
  return contract.value?.insuranceCompany && contract.value?.insurancePolicyNumber
})

const isInsuranceExpiringSoon = computed(() => {
  if (!contract.value?.insuranceExpiryDate) return false
  const expiryDate = new Date(contract.value.insuranceExpiryDate)
  const today = new Date()
  const daysUntilExpiry = Math.floor((expiryDate.getTime() - today.getTime()) / (1000 * 60 * 60 * 24))
  return daysUntilExpiry > 0 && daysUntilExpiry <= 30
})

const isInsuranceExpired = computed(() => {
  if (!contract.value?.insuranceExpiryDate) return false
  const expiryDate = new Date(contract.value.insuranceExpiryDate)
  const today = new Date()
  return expiryDate < today
})

const loadContract = async () => {
  loading.value = true
  try {
    const id = Number(route.params.id)
    contract.value = await contractApi.getContractById(id)
    newStatus.value = contract.value.status

    // Загрузка статистики
    statistics.value = await contractApi.getContractStatistics(id)
  } catch (error) {
    console.error('Failed to load contract:', error)
  } finally {
    loading.value = false
  }
}

const handleExport = async () => {
  if (!contract.value) return
  exporting.value = true
  try {
    const blob = await exportApi.exportContract(contract.value.id)
    const filename = `contract_${contract.value.contractNumber}_${new Date().toISOString().split('T')[0]}.xlsx`
    downloadFile(blob, filename)
  } catch (error) {
    console.error('Failed to export contract:', error)
    alert('Ошибка при экспорте договора')
  } finally {
    exporting.value = false
  }
}

const submitStatusChange = async () => {
  if (!contract.value) return
  submittingStatus.value = true
  try {
    await contractApi.changeStatus(contract.value.id, newStatus.value)
    await loadContract()
    showChangeStatusModal.value = false
  } catch (error) {
    console.error('Failed to change status:', error)
    alert('Ошибка при смене статуса')
  } finally {
    submittingStatus.value = false
  }
}

const calculatePremium = async () => {
  if (!contract.value?.equipment?.id) return
  try {
    const response = await insuranceApi.calculatePremium(contract.value.equipment.id)
    insuranceForm.value.insurancePremiumAnnual = response.data
  } catch (error) {
    console.error('Failed to calculate premium:', error)
    alert('Ошибка при расчёте премии')
  }
}

const closeInsuranceModal = () => {
  showInsuranceModal.value = false
  resetInsuranceForm()
}

const resetInsuranceForm = () => {
  insuranceForm.value = {
    insuranceCompany: '',
    insurancePolicyNumber: '',
    insuranceType: 'FULL',
    insuranceCoverageAmount: 0,
    insurancePremiumAnnual: 0,
    insuranceStartDate: '',
    insuranceExpiryDate: ''
  }
}

const openInsuranceModal = () => {
  if (hasInsurance.value && contract.value) {
    insuranceForm.value = {
      insuranceCompany: contract.value.insuranceCompany || '',
      insurancePolicyNumber: contract.value.insurancePolicyNumber || '',
      insuranceType: contract.value.insuranceType || 'FULL',
      insuranceCoverageAmount: contract.value.insuranceCoverageAmount || 0,
      insurancePremiumAnnual: contract.value.insurancePremiumAnnual || 0,
      insuranceStartDate: contract.value.insuranceStartDate || '',
      insuranceExpiryDate: contract.value.insuranceExpiryDate || ''
    }
  }
  showInsuranceModal.value = true
}

const submitInsurance = async () => {
  if (!contract.value) return
  submittingInsurance.value = true
  try {
    if (hasInsurance.value) {
      await insuranceApi.updateInsurance(contract.value.id, insuranceForm.value)
    } else {
      await insuranceApi.addInsurance(contract.value.id, insuranceForm.value)
    }
    await loadContract()
    closeInsuranceModal()
    alert('Страхование успешно сохранено')
  } catch (error) {
    console.error('Failed to save insurance:', error)
    alert('Ошибка при сохранении страхования')
  } finally {
    submittingInsurance.value = false
  }
}

const insuranceTypeLabel = (type: string | undefined) => {
  if (!type) return '—'
  const labels: Record<string, string> = {
    FULL: 'Полное',
    PARTIAL: 'Частичное',
    THEFT_ONLY: 'Только от кражи',
    DAMAGE_ONLY: 'Только от повреждений'
  }
  return labels[type] || type
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
    CANCELLED: 'Отменен'
  }
  return labels[status] || status
}

const scheduleStatusClass = (status: string) => {
  const classes: Record<string, string> = {
    PENDING: 'badge bg-secondary',
    PAID: 'badge bg-success',
    OVERDUE: 'badge bg-danger',
    PARTIAL: 'badge bg-warning text-dark'
  }
  return classes[status] || 'badge bg-secondary'
}

const scheduleStatusLabel = (status: string) => {
  const labels: Record<string, string> = {
    PENDING: 'Ожидает',
    PAID: 'Оплачен',
    OVERDUE: 'Просрочен',
    PARTIAL: 'Частично'
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
  loadContract()
})
</script>

<style scoped>
.contract-detail-page {
  padding: 1rem;
}

.modal {
  background-color: rgba(0, 0, 0, 0.5);
}
</style>
