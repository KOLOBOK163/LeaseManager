<template>
  <div class="client-detail-page">
    <div v-if="loading" class="text-center py-5">
      <div class="spinner-border text-primary" role="status">
        <span class="visually-hidden">Загрузка...</span>
      </div>
    </div>

    <div v-else-if="!client" class="alert alert-danger">
      Клиент не найден
    </div>

    <template v-else>
      <!-- Заголовок -->
      <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
          <nav aria-label="breadcrumb" class="mb-2">
            <ol class="breadcrumb">
              <li class="breadcrumb-item"><router-link to="/clients">Клиенты</router-link></li>
              <li class="breadcrumb-item active">{{ client.fullName }}</li>
            </ol>
          </nav>
          <h2>{{ client.fullName }}</h2>
        </div>
        <div>
          <button class="btn btn-primary me-2" @click="editClient">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" class="me-1">
              <path d="M12.146.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1 0 .708l-10 10a.5.5 0 0 1-.168.11l-5 2a.5.5 0 0 1-.65-.65l2-5a.5.5 0 0 1 .11-.168l10-10z"/>
            </svg>
            Редактировать
          </button>
          <button class="btn btn-outline-secondary" @click="$router.push('/clients')">
            Назад
          </button>
        </div>
      </div>

      <div class="row">
        <!-- Информация о клиенте -->
        <div class="col-lg-4 mb-4">
          <div class="card">
            <div class="card-header bg-white">
              <h5 class="mb-0">Общая информация</h5>
            </div>
            <div class="card-body">
              <div class="mb-3">
                <label class="text-muted small">Тип клиента</label>
                <div>
                  <span :class="clientBadgeClass(client.clientType)">
                    {{ clientTypeLabel(client.clientType) }}
                  </span>
                </div>
              </div>
              <div class="mb-3">
                <label class="text-muted small">Телефон</label>
                <div>{{ client.phoneNumber || '—' }}</div>
              </div>
              <div class="mb-3">
                <label class="text-muted small">Email</label>
                <div>{{ client.email || '—' }}</div>
              </div>
              <div class="mb-3" v-if="client.inn">
                <label class="text-muted small">ИНН</label>
                <div>{{ client.inn }}</div>
              </div>
              <div class="mb-3">
                <label class="text-muted small">Дата создания</label>
                <div>{{ formatDate(client.createdDate) }}</div>
              </div>
              <div class="mb-3" v-if="client.updatedDate">
                <label class="text-muted small">Обновлено</label>
                <div>{{ formatDate(client.updatedDate) }}</div>
              </div>
            </div>
          </div>

          <!-- Паспортные данные для физических лиц -->
          <div class="card mt-3" v-if="client.clientType === 'INDIVIDUAL'">
            <div class="card-header bg-white">
              <h5 class="mb-0">Паспортные данные</h5>
            </div>
            <div class="card-body">
              <div class="mb-3" v-if="client.passportSeries || client.passportNumber">
                <label class="text-muted small">Серия и номер</label>
                <div>{{ client.passportSeries }} {{ client.passportNumber }}</div>
              </div>
              <div class="mb-3" v-if="client.birthDate">
                <label class="text-muted small">Дата рождения</label>
                <div>{{ formatDate(client.birthDate) }}</div>
              </div>
              <div class="mb-3" v-if="client.passportIssuedBy">
                <label class="text-muted small">Кем выдан</label>
                <div>{{ client.passportIssuedBy }}</div>
              </div>
              <div class="mb-3" v-if="client.passportIssueDate">
                <label class="text-muted small">Дата выдачи</label>
                <div>{{ formatDate(client.passportIssueDate) }}</div>
              </div>
              <div class="mb-3" v-if="client.passportDepartmentCode">
                <label class="text-muted small">Код подразделения</label>
                <div>{{ client.passportDepartmentCode }}</div>
              </div>
              <div class="mb-3" v-if="client.registrationAddress">
                <label class="text-muted small">Адрес регистрации</label>
                <div>{{ client.registrationAddress }}</div>
              </div>
            </div>
          </div>

          <!-- Реквизиты для юридических лиц -->
          <div class="card mt-3" v-if="client.clientType === 'LEGAL_ENTITY'">
            <div class="card-header bg-white">
              <h5 class="mb-0">Реквизиты организации</h5>
            </div>
            <div class="card-body">
              <div class="mb-3" v-if="client.companyName">
                <label class="text-muted small">Наименование</label>
                <div>{{ client.companyName }}</div>
              </div>
              <div class="mb-3" v-if="client.kpp">
                <label class="text-muted small">КПП</label>
                <div>{{ client.kpp }}</div>
              </div>
              <div class="mb-3" v-if="client.ogrn">
                <label class="text-muted small">ОГРН</label>
                <div>{{ client.ogrn }}</div>
              </div>
              <div class="mb-3" v-if="client.legalAddress">
                <label class="text-muted small">Юридический адрес</label>
                <div>{{ client.legalAddress }}</div>
              </div>
              <div class="mb-3" v-if="client.actualAddress">
                <label class="text-muted small">Фактический адрес</label>
                <div>{{ client.actualAddress }}</div>
              </div>
              <div class="mb-3" v-if="client.contactPersonPosition">
                <label class="text-muted small">Должность контактного лица</label>
                <div>{{ client.contactPersonPosition }}</div>
              </div>
            </div>
          </div>

          <!-- Банковские реквизиты -->
          <div class="card mt-3" v-if="client.bankAccount || client.bik || client.bankName">
            <div class="card-header bg-white">
              <h5 class="mb-0">Банковские реквизиты</h5>
            </div>
            <div class="card-body">
              <div class="mb-3" v-if="client.bankAccount">
                <label class="text-muted small">Расчётный счёт</label>
                <div>{{ client.bankAccount }}</div>
              </div>
              <div class="mb-3" v-if="client.bik">
                <label class="text-muted small">БИК</label>
                <div>{{ client.bik }}</div>
              </div>
              <div class="mb-3" v-if="client.bankName">
                <label class="text-muted small">Банк</label>
                <div>{{ client.bankName }}</div>
              </div>
            </div>
          </div>
        </div>

        <!-- Договоры -->
        <div class="col-lg-8">
          <div class="card">
            <div class="card-header bg-white d-flex justify-content-between align-items-center">
              <h5 class="mb-0">Договоры</h5>
              <span class="badge bg-secondary">{{ client.contracts?.length || 0 }}</span>
            </div>
            <div class="card-body">
              <div v-if="!client.contracts || client.contracts.length === 0" class="text-center py-5 text-muted">
                У клиента нет договоров
              </div>
              <table v-else class="table table-hover">
                <thead>
                  <tr>
                    <th>Номер</th>
                    <th>Оборудование</th>
                    <th>Сумма</th>
                    <th>Период</th>
                    <th>Статус</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="contract in client.contracts" :key="contract.id">
                    <td>
                      <strong>{{ contract.contractNumber }}</strong>
                    </td>
                    <td>{{ contract.equipmentName || '—' }}</td>
                    <td>{{ formatMoney(contract.totalAmount) }}</td>
                    <td>
                      {{ formatDate(contract.startDate) }} — {{ formatDate(contract.endDate) }}
                    </td>
                    <td>
                      <span :class="contractStatusClass(contract.status)">
                        {{ contractStatusLabel(contract.status) }}
                      </span>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </template>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { clientApi, type Client } from '@/types/client'

const route = useRoute()
const client = ref<Client | null>(null)
const loading = ref(true)

const loadClient = async () => {
  loading.value = true
  try {
    const id = Number(route.params.id)
    client.value = await clientApi.getClientById(id)
  } catch (error) {
    console.error('Failed to load client:', error)
  } finally {
    loading.value = false
  }
}

const editClient = () => {
  // Можно открыть модалку или перейти на страницу редактирования
  alert('Функционал редактирования в разработке')
}

const clientBadgeClass = (type: string) => {
  return type === 'INDIVIDUAL' ? 'badge bg-info' : 'badge bg-primary'
}

const clientTypeLabel = (type: string) => {
  return type === 'INDIVIDUAL' ? 'Физ. лицо' : 'Юр. лицо'
}

const contractStatusClass = (status: string) => {
  const classes: Record<string, string> = {
    DRAFT: 'badge bg-secondary',
    ACTIVE: 'badge bg-success',
    SUSPENDED: 'badge bg-warning text-dark',
    CLOSED: 'badge bg-dark',
    CANCELLED: 'badge bg-danger'
  }
  return classes[status] || 'badge bg-secondary'
}

const contractStatusLabel = (status: string) => {
  const labels: Record<string, string> = {
    DRAFT: 'Черновик',
    ACTIVE: 'Активен',
    SUSPENDED: 'Приостановлен',
    CLOSED: 'Закрыт',
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
  loadClient()
})
</script>

<style scoped>
.client-detail-page {
  padding: 1rem;
}
</style>
