<template>
  <div class="dashboard-container">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h2>Панель управления</h2>
    </div>

    <!-- Счётчики -->
    <div class="row g-4 mb-4">
      <div class="col-12 col-md-6 col-xl-3">
        <div class="card stat-card border-primary">
          <div class="card-body">
            <div class="d-flex justify-content-between align-items-center">
              <div>
                <h6 class="card-subtitle text-muted">Активных договоров</h6>
                <h3 class="card-title mb-0">{{ stats.activeContracts }}</h3>
              </div>
              <div class="stat-icon bg-primary-subtle text-primary">
                <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="currentColor" viewBox="0 0 16 16">
                  <path d="M14 4.5V14a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V2a2 2 0 0 1 2-2h5.5L14 4.5zm-3 0A1.5 1.5 0 0 1 9.5 3V1H4a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1V4.5h-2z"/>
                </svg>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="col-12 col-md-6 col-xl-3">
        <div class="card stat-card border-success">
          <div class="card-body">
            <div class="d-flex justify-content-between align-items-center">
              <div>
                <h6 class="card-subtitle text-muted">Клиентов</h6>
                <h3 class="card-title mb-0">{{ stats.totalClients }}</h3>
              </div>
              <div class="stat-icon bg-success-subtle text-success">
                <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="currentColor" viewBox="0 0 16 16">
                  <path d="M11 6a3 3 0 1 1-6 0 3 3 0 0 1 6 0z"/>
                  <path d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8zm8-7a7 7 0 0 0-5.468 11.37C3.242 11.226 4.805 10 8 10s4.757 1.225 5.468 2.37A7 7 0 0 0 8 1z"/>
                </svg>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="col-12 col-md-6 col-xl-3">
        <div class="card stat-card border-danger">
          <div class="card-body">
            <div class="d-flex justify-content-between align-items-center">
              <div>
                <h6 class="card-subtitle text-muted">Просроченных платежей</h6>
                <h3 class="card-title mb-0">{{ stats.overduePayments }}</h3>
              </div>
              <div class="stat-icon bg-danger-subtle text-danger">
                <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="currentColor" viewBox="0 0 16 16">
                  <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
                  <path d="M7.002 11a1 1 0 1 1 2 0 1 1 0 0 1-2 0zM7.1 4.995a.905.905 0 1 1 1.8 0l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 4.995z"/>
                </svg>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="col-12 col-md-6 col-xl-3">
        <div class="card stat-card border-info">
          <div class="card-body">
            <div class="d-flex justify-content-between align-items-center">
              <div>
                <h6 class="card-subtitle text-muted">Свободного оборудования</h6>
                <h3 class="card-title mb-0">{{ stats.freeEquipment }}</h3>
              </div>
              <div class="stat-icon bg-info-subtle text-info">
                <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="currentColor" viewBox="0 0 16 16">
                  <path d="M0 1.5A.5.5 0 0 1 .5 1H1a.5.5 0 0 1 .5.5v.514L2 2.014V1.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v.514l.5-.014V1.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v.514l.5-.014V1.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v13a.5.5 0 0 1-.5.5h-13a.5.5 0 0 1-.5-.5v-13zm1 9a.5.5 0 0 0 0 1h1a.5.5 0 0 0 0-1H1zm0-4a.5.5 0 0 0 0 1h1a.5.5 0 0 0 0-1H1zm0-4a.5.5 0 0 0 0 1h1a.5.5 0 0 0 0-1H1z"/>
                </svg>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- График -->
    <div class="row mb-4">
      <div class="col-12">
        <div class="card">
          <div class="card-header bg-white">
            <h5 class="mb-0">Поступления по месяцам</h5>
          </div>
          <div class="card-body">
            <div v-if="loading" class="text-center py-5">
              <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Загрузка...</span>
              </div>
            </div>
            <div v-else-if="error" class="alert alert-danger" role="alert">
              {{ error }}
            </div>
            <div v-else class="chart-container">
              <Line :data="chartData" :options="chartOptions" />
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Ближайшие платежи -->
    <div class="row">
      <div class="col-12">
        <div class="card">
          <div class="card-header bg-white">
            <h5 class="mb-0">Ближайшие платежи на этой неделе</h5>
          </div>
          <div class="card-body">
            <div v-if="loadingPayments" class="text-center py-5">
              <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Загрузка...</span>
              </div>
            </div>
            <div v-else-if="upcomingPayments.length === 0" class="text-center py-5 text-muted">
              Нет платежей на этой неделе
            </div>
            <div v-else class="table-responsive">
              <table class="table table-hover">
                <thead>
                  <tr>
                    <th>Дата</th>
                    <th>Договор</th>
                    <th>Клиент</th>
                    <th>Сумма</th>
                    <th>Статус</th>
                    <th class="text-end">Действия</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="payment in upcomingPayments" :key="payment.paymentScheduleId">
                    <td>{{ formatDate(payment.paymentDate) }}</td>
                    <td>
                      <router-link :to="`/contracts/${payment.contractId}`" class="text-decoration-none">
                        {{ payment.contractNumber }}
                      </router-link>
                    </td>
                    <td>{{ payment.clientName }}</td>
                    <td><strong>{{ formatCurrency(payment.amount) }}</strong></td>
                    <td>
                      <span :class="getStatusBadgeClass(payment.status)">
                        {{ getStatusLabel(payment.status) }}
                      </span>
                    </td>
                    <td class="text-end">
                      <router-link
                        :to="`/contracts/${payment.contractId}/payments`"
                        class="btn btn-sm btn-outline-primary"
                      >
                        Перейти
                      </router-link>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue'
import { Line } from 'vue-chartjs'
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend,
  Filler
} from 'chart.js'
import { dashboardApi, type DashboardStats, type UpcomingPayment } from '@/api/dashboard'

ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend,
  Filler
)

const stats = reactive<DashboardStats>({
  activeContracts: 0,
  totalClients: 0,
  overduePayments: 0,
  freeEquipment: 0
})

const loading = ref(true)
const error = ref('')
const loadingPayments = ref(true)
const upcomingPayments = ref<UpcomingPayment[]>([])

const chartData = computed(() => ({
  labels: chartMonths.value,
  datasets: [
    {
      label: 'Поступления (руб.)',
      data: chartAmounts.value,
      borderColor: 'rgb(13, 110, 253)',
      backgroundColor: 'rgba(13, 110, 253, 0.1)',
      fill: true,
      tension: 0.4
    }
  ]
}))

const chartOptions: any = {
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: {
      display: true,
      position: 'top'
    },
    tooltip: {
      callbacks: {
        label: (context: any) => {
          return new Intl.NumberFormat('ru-RU', {
            style: 'currency',
            currency: 'RUB',
            minimumFractionDigits: 0
          }).format(context.parsed.y)
        }
      }
    }
  },
  scales: {
    y: {
      beginAtZero: true,
      ticks: {
        callback: (value: any) => {
          return new Intl.NumberFormat('ru-RU', {
            style: 'currency',
            currency: 'RUB',
            minimumFractionDigits: 0,
            notation: 'compact'
          }).format(value)
        }
      },
      grid: {
        color: 'rgba(0, 0, 0, 0.05)'
      }
    },
    x: {
      grid: {
        display: false
      }
    }
  }
}

const chartMonths = ref<string[]>([])
const chartAmounts = ref<number[]>([])

const loadStats = async () => {
  try {
    const data = await dashboardApi.getStats()
    stats.activeContracts = data.activeContracts
    stats.totalClients = data.totalClients
    stats.overduePayments = data.overduePayments
    stats.freeEquipment = data.freeEquipment
  } catch (e) {
    console.error('Failed to load stats:', e)
  }
}

const loadChartData = async () => {
  try {
    const data = await dashboardApi.getPaymentChart()
    chartMonths.value = data.months
    chartAmounts.value = data.amounts
    error.value = ''
  } catch (e) {
    error.value = 'Не удалось загрузить данные графика'
    console.error('Failed to load chart data:', e)
  } finally {
    loading.value = false
  }
}

const loadUpcomingPayments = async () => {
  try {
    upcomingPayments.value = await dashboardApi.getUpcomingPayments()
  } catch (e) {
    console.error('Failed to load upcoming payments:', e)
  } finally {
    loadingPayments.value = false
  }
}

const formatDate = (dateString: string) => {
  const date = new Date(dateString)
  return new Intl.DateTimeFormat('ru-RU', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric'
  }).format(date)
}

const formatCurrency = (amount: number) => {
  return new Intl.NumberFormat('ru-RU', {
    style: 'currency',
    currency: 'RUB',
    minimumFractionDigits: 0
  }).format(amount)
}

const getStatusBadgeClass = (status: string) => {
  switch (status) {
    case 'PENDING':
      return 'badge bg-warning'
    case 'OVERDUE':
      return 'badge bg-danger'
    case 'PAID':
      return 'badge bg-success'
    default:
      return 'badge bg-secondary'
  }
}

const getStatusLabel = (status: string) => {
  switch (status) {
    case 'PENDING':
      return 'Ожидается'
    case 'OVERDUE':
      return 'Просрочен'
    case 'PAID':
      return 'Оплачен'
    default:
      return status
  }
}

onMounted(() => {
  loadStats()
  loadChartData()
  loadUpcomingPayments()
})
</script>

<style scoped>
.dashboard-container {
  min-height: 100vh;
  background-color: #f8f9fa;
}

.stat-card {
  transition: transform 0.2s, box-shadow 0.2s;
  border-width: 1px;
}

.stat-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.stat-icon {
  width: 60px;
  height: 60px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.chart-container {
  height: 350px;
  position: relative;
}
</style>
