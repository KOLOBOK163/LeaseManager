<template>
  <div class="payment-schedules-page">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h2>График платежей по договору № {{ contractNumber }}</h2>
      <div>
        <button class="btn btn-primary me-2" @click="showRegisterPaymentModal = true">
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" class="me-1">
            <path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4z"/>
          </svg>
          Регистрация платежа
        </button>
        <button class="btn btn-outline-secondary" @click="$router.push('/contracts')">
          Назад к договорам
        </button>
      </div>
    </div>

    <!-- Сводка -->
    <div class="row g-4 mb-4">
      <div class="col-md-3">
        <div class="card stat-card border-success">
          <div class="card-body">
            <h6 class="card-subtitle text-muted">Всего платежей</h6>
            <h3 class="card-title mb-0">{{ schedules.length }}</h3>
          </div>
        </div>
      </div>
      <div class="col-md-3">
        <div class="card stat-card border-success">
          <div class="card-body">
            <h6 class="card-subtitle text-muted">Оплачено</h6>
            <h3 class="card-title mb-0">{{ paidCount }}</h3>
          </div>
        </div>
      </div>
      <div class="col-md-3">
        <div class="card stat-card border-warning">
          <div class="card-body">
            <h6 class="card-subtitle text-muted">Ожидают оплаты</h6>
            <h3 class="card-title mb-0">{{ pendingCount }}</h3>
          </div>
        </div>
      </div>
      <div class="col-md-3">
        <div class="card stat-card border-danger">
          <div class="card-body">
            <h6 class="card-subtitle text-muted">Просрочено</h6>
            <h3 class="card-title mb-0">{{ overdueCount }}</h3>
          </div>
        </div>
      </div>
    </div>

    <!-- Таблица платежей -->
    <div class="card">
      <div class="card-body">
        <div v-if="loading" class="text-center py-5">
          <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Загрузка...</span>
          </div>
        </div>
        <div v-else-if="schedules.length === 0" class="text-center py-5 text-muted">
          График платежей не найден
        </div>
        <table v-else class="table table-hover">
          <thead>
            <tr>
              <th>№</th>
              <th>Дата платежа</th>
              <th>Сумма</th>
              <th>Основной долг</th>
              <th>Проценты</th>
              <th>Статус</th>
              <th class="text-end">Действия</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="schedule in schedules" :key="schedule.id" :class="{ 'table-warning': schedule.overdue }">
              <td><strong>{{ schedule.periodNumber }}</strong></td>
              <td :class="{ 'text-danger fw-bold': schedule.overdue && !isPaid(schedule.status) }">
                {{ formatDate(schedule.paymentDate) }}
                <span v-if="schedule.overdue && !isPaid(schedule.status)" class="badge bg-danger ms-1">Просрочено</span>
              </td>
              <td>{{ formatMoney(schedule.totalAmount) }}</td>
              <td>{{ formatMoney(schedule.principalPart) }}</td>
              <td>{{ formatMoney(schedule.interestPart) }}</td>
              <td>
                <span :class="statusBadgeClass(schedule.status)">
                  {{ statusLabel(schedule.status) }}
                </span>
              </td>
              <td class="text-end">
                <button 
                  v-if="!isPaid(schedule.status) && !isCancelled(schedule.status)" 
                  class="btn btn-sm btn-success" 
                  @click="markAsPaid(schedule)"
                  :disabled="submittingId === schedule.id"
                >
                  <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" class="me-1">
                    <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zm-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/>
                  </svg>
                  {{ submittingId === schedule.id ? '...' : 'Оплатить' }}
                </button>
                <button 
                  v-if="!isPaid(schedule.status) && !isCancelled(schedule.status)" 
                  class="btn btn-sm btn-outline-secondary ms-1" 
                  @click="cancelSchedule(schedule)"
                  :disabled="submittingId === schedule.id"
                >
                  Отменить
                </button>
              </td>
            </tr>
          </tbody>
          <tfoot>
            <tr class="table-secondary fw-bold">
              <td>Итого:</td>
              <td></td>
              <td>{{ formatMoney(totalAmount) }}</td>
              <td>{{ formatMoney(totalPrincipal) }}</td>
              <td>{{ formatMoney(totalInterest) }}</td>
              <td></td>
              <td></td>
            </tr>
          </tfoot>
        </table>
      </div>
    </div>

    <!-- Модальное окно оплаты -->
    <div v-if="showPaymentModal" class="modal fade show d-block" tabindex="-1">
      <div class="modal-dialog modal-sm">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Подтверждение оплаты</h5>
            <button type="button" class="btn-close" @click="showPaymentModal = false"></button>
          </div>
          <div class="modal-body">
            <p class="mb-2">Платёж № <strong>{{ selectedSchedule?.periodNumber }}</strong></p>
            <p class="mb-2">Сумма: <strong>{{ formatMoney(selectedSchedule?.totalAmount || 0) }}</strong></p>
            <div class="mb-3">
              <label class="form-label">Комментарий (необязательно)</label>
              <textarea class="form-control" v-model="paymentComment" rows="3" placeholder="Введите комментарий"></textarea>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" @click="showPaymentModal = false">Отмена</button>
            <button type="button" class="btn btn-success" @click="confirmPayment" :disabled="submitting">
              {{ submitting ? 'Сохранение...' : 'Подтвердить оплату' }}
            </button>
          </div>
        </div>
      </div>
    </div>
    <div v-if="showPaymentModal" class="modal-backdrop fade show"></div>

    <!-- Модальное окно регистрации платежа -->
    <div v-if="showRegisterPaymentModal" class="modal fade show d-block" tabindex="-1">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Регистрация платежа от лизингополучателя</h5>
            <button type="button" class="btn-close" @click="showRegisterPaymentModal = false"></button>
          </div>
          <div class="modal-body">
            <form @submit.prevent="submitRegisteredPayment">
              <div class="mb-3">
                <label class="form-label">График платежа *</label>
                <select class="form-select" v-model="registerForm.scheduleId" required>
                  <option value="" disabled>Выберите график</option>
                  <option v-for="s in pendingSchedules" :key="s.id" :value="s.id">
                    № {{ s.periodNumber }} от {{ formatDate(s.paymentDate) }} - {{ formatMoney(s.totalAmount) }}
                  </option>
                </select>
              </div>
              <div class="mb-3">
                <label class="form-label">Сумма платежа *</label>
                <input type="number" step="0.01" class="form-control" v-model="registerForm.amount" required />
              </div>
              <div class="mb-3">
                <label class="form-label">Дата поступления *</label>
                <input type="datetime-local" class="form-control" v-model="registerForm.paymentDate" required />
              </div>
              <div class="mb-3">
                <label class="form-label">Тип платежа</label>
                <select class="form-select" v-model="registerForm.paymentType">
                  <option value="PRINCIPAL">Основной долг</option>
                  <option value="INTEREST">Проценты</option>
                  <option value="PENALTY">Штраф/пеня</option>
                  <option value="ADDITIONAL">Дополнительно</option>
                </select>
              </div>
              <div class="mb-3">
                <label class="form-label">Способ оплаты</label>
                <select class="form-select" v-model="registerForm.paymentMethod">
                  <option value="BANK_TRANSFER">Безналичный расчёт</option>
                  <option value="CASH">Наличные</option>
                  <option value="CARD">Банковская карта</option>
                </select>
              </div>
              <div class="mb-3">
                <label class="form-label">Номер документа</label>
                <input type="text" class="form-control" v-model="registerForm.documentNumber" placeholder="Платёжное поручение №..." />
              </div>
              <div class="mb-3">
                <label class="form-label">Комментарий</label>
                <textarea class="form-control" v-model="registerForm.comment" rows="3" placeholder="Комментарий к платежу"></textarea>
              </div>
            </form>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" @click="showRegisterPaymentModal = false">Отмена</button>
            <button type="button" class="btn btn-primary" @click="submitRegisteredPayment" :disabled="submittingRegister">
              {{ submittingRegister ? 'Сохранение...' : 'Зарегистрировать платёж' }}
            </button>
          </div>
        </div>
      </div>
    </div>
    <div v-if="showRegisterPaymentModal" class="modal-backdrop fade show"></div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { paymentScheduleApi, type PaymentSchedule, type PaymentScheduleStatus, type MarkAsPaidRequest, type PaymentType, type PaymentMethod } from '@/types/payment-schedule'

const route = useRoute()
const contractId = computed(() => Number(route.params.contractId))
const contractNumber = ref('')

const schedules = ref<PaymentSchedule[]>([])
const loading = ref(true)
const submittingId = ref<number | null>(null)
const submitting = ref(false)
const submittingRegister = ref(false)
const showPaymentModal = ref(false)
const showRegisterPaymentModal = ref(false)
const selectedSchedule = ref<PaymentSchedule | null>(null)
const paymentComment = ref('')

const registerForm = reactive({
  scheduleId: 0,
  amount: 0,
  paymentDate: new Date().toISOString().slice(0, 16),
  paymentType: 'PRINCIPAL' as PaymentType,
  paymentMethod: 'BANK_TRANSFER' as PaymentMethod,
  documentNumber: '',
  comment: ''
})

const pendingSchedules = computed(() => {
  return schedules.value.filter(s => s.status === 'PENDING' || s.status === 'OVERDUE')
})

const loadSchedules = async () => {
  loading.value = true
  try {
    // Загружаем график платежей
    schedules.value = await paymentScheduleApi.getSchedulesByContractId(contractId.value)

    // Загружаем информацию о договоре для получения номера
    const { contractApi } = await import('@/types/contract')
    const contract = await contractApi.getContractById(contractId.value)
    contractNumber.value = contract.contractNumber
  } catch (error) {
    console.error('Failed to load payment schedules:', error)
  } finally {
    loading.value = false
  }
}

const markAsPaid = (schedule: PaymentSchedule) => {
  selectedSchedule.value = schedule
  paymentComment.value = ''
  showPaymentModal.value = true
}

const confirmPayment = async () => {
  if (!selectedSchedule.value) return
  submitting.value = true
  try {
    const request: MarkAsPaidRequest = paymentComment.value ? { comment: paymentComment.value } : {}
    await paymentScheduleApi.markAsPaid(selectedSchedule.value.id, request)
    showPaymentModal.value = false
    await loadSchedules()
  } catch (error) {
    console.error('Failed to mark as paid:', error)
    alert('Ошибка при подтверждении оплаты')
  } finally {
    submitting.value = false
  }
}

const cancelSchedule = async (schedule: PaymentSchedule) => {
  if (!confirm(`Отменить платёж № ${schedule.periodNumber}?`)) return
  submittingId.value = schedule.id
  try {
    await paymentScheduleApi.cancelSchedule(schedule.id)
    await loadSchedules()
  } catch (error) {
    console.error('Failed to cancel schedule:', error)
    alert('Ошибка при отмене платежа')
  } finally {
    submittingId.value = null
  }
}

const submitRegisteredPayment = async () => {
  submittingRegister.value = true
  try {
    const { paymentApi } = await import('@/types/payment-schedule')
    await paymentApi.registerPayment({
      scheduleId: registerForm.scheduleId,
      amount: registerForm.amount,
      paymentDate: registerForm.paymentDate,
      paymentType: registerForm.paymentType,
      paymentMethod: registerForm.paymentMethod,
      documentNumber: registerForm.documentNumber || undefined,
      comment: registerForm.comment || undefined
    })
    showRegisterPaymentModal.value = false
    // Сброс формы
    registerForm.scheduleId = 0
    registerForm.amount = 0
    registerForm.documentNumber = ''
    registerForm.comment = ''
    await loadSchedules()
    alert('Платёж успешно зарегистрирован')
  } catch (error) {
    console.error('Failed to register payment:', error)
    alert('Ошибка при регистрации платежа')
  } finally {
    submittingRegister.value = false
  }
}

const isPaid = (status: string) => status === 'PAID'
const isCancelled = (status: string) => status === 'CANCELLED'

const paidCount = computed(() => schedules.value.filter(s => s.status === 'PAID').length)
const pendingCount = computed(() => schedules.value.filter(s => s.status === 'PENDING').length)
const overdueCount = computed(() => schedules.value.filter(s => s.overdue || s.status === 'OVERDUE').length)

const totalAmount = computed(() => schedules.value.reduce((sum, s) => sum + s.totalAmount, 0))
const totalPrincipal = computed(() => schedules.value.reduce((sum, s) => sum + s.principalPart, 0))
const totalInterest = computed(() => schedules.value.reduce((sum, s) => sum + s.interestPart, 0))

const statusBadgeClass = (status: string) => {
  const classes: Record<string, string> = {
    PENDING: 'badge bg-secondary',
    PAID: 'badge bg-success',
    OVERDUE: 'badge bg-danger',
    PARTIAL: 'badge bg-warning text-dark',
    CANCELLED: 'badge bg-dark'
  }
  return classes[status] || 'badge bg-secondary'
}

const statusLabel = (status: string) => {
  const labels: Record<string, string> = {
    PENDING: 'Ожидает',
    PAID: 'Оплачен',
    OVERDUE: 'Просрочен',
    PARTIAL: 'Частично',
    CANCELLED: 'Отменен'
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
  loadSchedules()
})
</script>

<style scoped>
.payment-schedules-page {
  padding: 1rem;
}

.stat-card {
  transition: transform 0.2s;
}

.stat-card:hover {
  transform: translateY(-2px);
}

.modal {
  background-color: rgba(0, 0, 0, 0.5);
}
</style>
