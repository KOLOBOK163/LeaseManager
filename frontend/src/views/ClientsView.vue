<template>
  <div class="clients-page">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h2>Клиенты</h2>
      <button class="btn btn-primary" @click="showCreateModal = true">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" class="me-1">
          <path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4z"/>
        </svg>
        Добавить клиента
      </button>
    </div>

    <!-- Поиск -->
    <div class="card mb-4">
      <div class="card-body">
        <div class="row g-3">
          <div class="col-md-6">
            <input
              type="text"
              class="form-control"
              placeholder="Поиск по ФИО, наименованию организации, телефону, email, ИНН..."
              v-model="searchQuery"
              @input="debouncedSearch"
            />
          </div>
        </div>
      </div>
    </div>

    <!-- Таблица клиентов -->
    <div class="card">
      <div class="card-body">
        <div v-if="loading" class="text-center py-5">
          <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Загрузка...</span>
          </div>
        </div>
        <div v-else-if="clients.length === 0" class="text-center py-5 text-muted">
          Клиенты не найдены
        </div>
        <table v-else class="table table-hover">
          <thead>
            <tr>
              <th>ФИО / Наименование организации</th>
              <th>Телефон</th>
              <th>Email</th>
              <th>ИНН</th>
              <th>Тип</th>
              <th class="text-end">Действия</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="client in clients" :key="client.id">
              <td>
                <router-link :to="`/clients/${client.id}`" class="text-decoration-none">
                  <strong>{{ getClientDisplayName(client) }}</strong>
                </router-link>
              </td>
              <td>{{ client.phoneNumber || '—' }}</td>
              <td>{{ client.email || '—' }}</td>
              <td>{{ client.inn || '—' }}</td>
              <td>
                <span :class="clientBadgeClass(client.clientType)">
                  {{ clientTypeLabel(client.clientType) }}
                </span>
              </td>
              <td class="text-end">
                <button class="btn btn-sm btn-outline-primary me-1" @click="editClient(client)">
                  <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                    <path d="M12.146.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1 0 .708l-10 10a.5.5 0 0 1-.168.11l-5 2a.5.5 0 0 1-.65-.65l2-5a.5.5 0 0 1 .11-.168l10-10zM11.207 2.5 13.5 4.793 14.793 3.5 12.5 1.207 11.207 2.5zm1.586 3L10.5 3.207 4 9.707V10h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.293l6.5-6.5zm-9.761 5.175-.106.106-1.528 3.821 3.821-1.528.106-.106A.5.5 0 0 1 5 12.5V12h-.5a.5.5 0 0 1-.5-.5V11h-.5a.5.5 0 0 1-.468-.325z"/>
                  </svg>
                </button>
                <button class="btn btn-sm btn-outline-danger" @click="deleteClient(client)">
                  <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                    <path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0V6z"/>
                    <path d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118zM2.5 3V2h11v1h-11z"/>
                  </svg>
                </button>
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
            <h5 class="modal-title">{{ showCreateModal ? 'Новый клиент' : 'Редактирование клиента' }}</h5>
            <button type="button" class="btn-close" @click="closeModal"></button>
          </div>
          <div class="modal-body">
            <form @submit.prevent="submitForm">
              <div class="row g-3">
                <!-- Общие поля -->
                <div class="col-12">
                  <h6 class="border-bottom pb-2">Общая информация</h6>
                </div>
                <div class="col-md-6">
                  <label class="form-label">Тип клиента *</label>
                  <select class="form-select" v-model="form.clientType" required>
                    <option value="INDIVIDUAL">Физическое лицо</option>
                    <option value="LEGAL_ENTITY">Юридическое лицо</option>
                  </select>
                </div>
                <div class="col-md-6">
                  <label class="form-label">ФИО {{ form.clientType === 'LEGAL_ENTITY' ? '(контактное лицо)' : '' }} *</label>
                  <input type="text" class="form-control" v-model="form.fullName" required />
                </div>
                <div class="col-md-6">
                  <label class="form-label">Телефон</label>
                  <input type="text" class="form-control" v-model="form.phoneNumber" placeholder="+7 (999) 123-45-67" />
                </div>
                <div class="col-md-6">
                  <label class="form-label">Email</label>
                  <input type="email" class="form-control" v-model="form.email" />
                </div>
                <div class="col-md-6">
                  <label class="form-label">ИНН</label>
                  <input type="text" class="form-control" v-model="form.inn"
                         :placeholder="form.clientType === 'INDIVIDUAL' ? '12 цифр' : '10 цифр'"
                         :maxlength="form.clientType === 'INDIVIDUAL' ? 12 : 10" />
                </div>

                <!-- Поля для физических лиц -->
                <template v-if="form.clientType === 'INDIVIDUAL'">
                  <div class="col-12 mt-3">
                    <h6 class="border-bottom pb-2">Паспортные данные</h6>
                  </div>
                  <div class="col-md-3">
                    <label class="form-label">Серия</label>
                    <input type="text" class="form-control" v-model="form.passportSeries"
                           placeholder="1234" maxlength="4" />
                  </div>
                  <div class="col-md-3">
                    <label class="form-label">Номер</label>
                    <input type="text" class="form-control" v-model="form.passportNumber"
                           placeholder="123456" maxlength="6" />
                  </div>
                  <div class="col-md-6">
                    <label class="form-label">Дата рождения</label>
                    <input type="date" class="form-control" v-model="form.birthDate" />
                  </div>
                  <div class="col-md-8">
                    <label class="form-label">Кем выдан</label>
                    <input type="text" class="form-control" v-model="form.passportIssuedBy"
                           placeholder="ОУФМС России по..." />
                  </div>
                  <div class="col-md-4">
                    <label class="form-label">Дата выдачи</label>
                    <input type="date" class="form-control" v-model="form.passportIssueDate" />
                  </div>
                  <div class="col-md-4">
                    <label class="form-label">Код подразделения</label>
                    <input type="text" class="form-control" v-model="form.passportDepartmentCode"
                           placeholder="123-456" maxlength="7" />
                  </div>
                  <div class="col-md-8">
                    <label class="form-label">Адрес регистрации</label>
                    <input type="text" class="form-control" v-model="form.registrationAddress"
                           placeholder="г. Москва, ул. Ленина, д. 1, кв. 1" />
                  </div>
                </template>

                <!-- Поля для юридических лиц -->
                <template v-if="form.clientType === 'LEGAL_ENTITY'">
                  <div class="col-12 mt-3">
                    <h6 class="border-bottom pb-2">Реквизиты организации</h6>
                  </div>
                  <div class="col-md-6">
                    <label class="form-label">Наименование организации</label>
                    <input type="text" class="form-control" v-model="form.companyName"
                           placeholder="ООО &quot;Рога и копыта&quot;" />
                  </div>
                  <div class="col-md-3">
                    <label class="form-label">КПП</label>
                    <input type="text" class="form-control" v-model="form.kpp"
                           placeholder="9 цифр" maxlength="9" />
                  </div>
                  <div class="col-md-3">
                    <label class="form-label">ОГРН</label>
                    <input type="text" class="form-control" v-model="form.ogrn"
                           placeholder="13 или 15 цифр" maxlength="15" />
                  </div>
                  <div class="col-md-6">
                    <label class="form-label">Юридический адрес</label>
                    <input type="text" class="form-control" v-model="form.legalAddress" />
                  </div>
                  <div class="col-md-6">
                    <label class="form-label">Фактический адрес</label>
                    <input type="text" class="form-control" v-model="form.actualAddress"
                           placeholder="Если отличается от юридического" />
                  </div>
                  <div class="col-md-6">
                    <label class="form-label">Должность контактного лица</label>
                    <input type="text" class="form-control" v-model="form.contactPersonPosition"
                           placeholder="Генеральный директор" />
                  </div>
                </template>

                <!-- Банковские реквизиты -->
                <div class="col-12 mt-3">
                  <h6 class="border-bottom pb-2">Банковские реквизиты</h6>
                </div>
                <div class="col-md-6">
                  <label class="form-label">Расчётный счёт</label>
                  <input type="text" class="form-control" v-model="form.bankAccount"
                         placeholder="20 цифр" maxlength="20" />
                </div>
                <div class="col-md-6">
                  <label class="form-label">БИК банка</label>
                  <input type="text" class="form-control" v-model="form.bik"
                         placeholder="9 цифр" maxlength="9" />
                </div>
                <div class="col-md-12">
                  <label class="form-label">Название банка</label>
                  <input type="text" class="form-control" v-model="form.bankName"
                         placeholder="ПАО Сбербанк" />
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
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { clientApi, type Client, type CreateClientRequest, type UpdateClientRequest } from '@/types/client'
import { scoringApi } from '@/types/scoring'

const router = useRouter()

const clients = ref<Client[]>([])
const loading = ref(false)
const searchQuery = ref('')
const showCreateModal = ref(false)
const showEditModal = ref(false)
const submitting = ref(false)
const editingClientId = ref<number | null>(null)

const form = reactive<CreateClientRequest>({
  fullName: '',
  phoneNumber: '',
  email: '',
  clientType: 'INDIVIDUAL',
  inn: '',
  // Поля для физических лиц
  passportSeries: '',
  passportNumber: '',
  passportIssuedBy: '',
  passportIssueDate: '',
  passportDepartmentCode: '',
  registrationAddress: '',
  birthDate: '',
  // Поля для юридических лиц
  companyName: '',
  kpp: '',
  ogrn: '',
  legalAddress: '',
  actualAddress: '',
  contactPersonPosition: '',
  // Банковские реквизиты
  bankAccount: '',
  bik: '',
  bankName: ''
})

const loadClients = async (search?: string) => {
  loading.value = true
  try {
    clients.value = await clientApi.getClients(search)
  } catch (error) {
    console.error('Failed to load clients:', error)
  } finally {
    loading.value = false
  }
}

let searchTimeout: ReturnType<typeof setTimeout>
const debouncedSearch = () => {
  clearTimeout(searchTimeout)
  searchTimeout = setTimeout(() => {
    loadClients(searchQuery.value || undefined)
  }, 300)
}

const editClient = (client: Client) => {
  editingClientId.value = client.id
  form.fullName = client.fullName
  form.phoneNumber = client.phoneNumber || ''
  form.email = client.email || ''
  form.clientType = client.clientType
  form.inn = client.inn || ''
  // Поля для физических лиц
  form.passportSeries = client.passportSeries || ''
  form.passportNumber = client.passportNumber || ''
  form.passportIssuedBy = client.passportIssuedBy || ''
  form.passportIssueDate = client.passportIssueDate || ''
  form.passportDepartmentCode = client.passportDepartmentCode || ''
  form.registrationAddress = client.registrationAddress || ''
  form.birthDate = client.birthDate || ''
  // Поля для юридических лиц
  form.companyName = client.companyName || ''
  form.kpp = client.kpp || ''
  form.ogrn = client.ogrn || ''
  form.legalAddress = client.legalAddress || ''
  form.actualAddress = client.actualAddress || ''
  form.contactPersonPosition = client.contactPersonPosition || ''
  // Банковские реквизиты
  form.bankAccount = client.bankAccount || ''
  form.bik = client.bik || ''
  form.bankName = client.bankName || ''
  showEditModal.value = true
}

const submitForm = async () => {
  submitting.value = true
  try {
    if (editingClientId.value) {
      await clientApi.updateClient(editingClientId.value, form as UpdateClientRequest)
      closeModal()
      loadClients(searchQuery.value || undefined)
    } else {
      const createdClient = await clientApi.createClient(form)
      closeModal()
      loadClients(searchQuery.value || undefined)

      // Проверяем скоринг нового клиента
      try {
        // Небольшая задержка, чтобы скоринг успел выполниться на backend
        await new Promise(resolve => setTimeout(resolve, 500))
        const scoring = await scoringApi.getLatestScoring(createdClient.id)

        if (scoring.status === 'MANUAL_REVIEW') {
          const goToScoring = confirm(
            `⚠️ Клиент "${createdClient.fullName}" требует ручной проверки!\n\n` +
            `Скоринговый балл: ${scoring.score}\n` +
            `Статус: Требует проверки менеджером\n\n` +
            `Перейти на страницу скоринга для проверки?`
          )
          if (goToScoring) {
            router.push('/scoring')
          }
        } else if (scoring.status === 'REJECTED') {
          alert(
            `❌ Клиент "${createdClient.fullName}" отклонён системой скоринга\n\n` +
            `Скоринговый балл: ${scoring.score}\n` +
            `Причина: ${scoring.rejectionReason || 'Недостаточный балл'}`
          )
        } else if (scoring.status === 'AUTO_APPROVED') {
          alert(
            `✅ Клиент "${createdClient.fullName}" автоматически одобрен!\n\n` +
            `Скоринговый балл: ${scoring.score}`
          )
        }
      } catch (scoringError) {
        console.error('Failed to check scoring:', scoringError)
        // Не показываем ошибку пользователю, так как клиент уже создан
      }
    }
  } catch (error) {
    console.error('Failed to save client:', error)
    alert('Ошибка при сохранении клиента')
  } finally {
    submitting.value = false
  }
}

const deleteClient = async (client: Client) => {
  if (!confirm(`Удалить клиента "${client.fullName}"?`)) return
  try {
    await clientApi.deleteClient(client.id)
    loadClients(searchQuery.value || undefined)
  } catch (error) {
    console.error('Failed to delete client:', error)
    alert('Ошибка при удалении клиента')
  }
}

const closeModal = () => {
  showCreateModal.value = false
  showEditModal.value = false
  editingClientId.value = null
  Object.assign(form, {
    fullName: '',
    phoneNumber: '',
    email: '',
    clientType: 'INDIVIDUAL',
    inn: '',
    // Поля для физических лиц
    passportSeries: '',
    passportNumber: '',
    passportIssuedBy: '',
    passportIssueDate: '',
    passportDepartmentCode: '',
    registrationAddress: '',
    birthDate: '',
    // Поля для юридических лиц
    companyName: '',
    kpp: '',
    ogrn: '',
    legalAddress: '',
    actualAddress: '',
    contactPersonPosition: '',
    // Банковские реквизиты
    bankAccount: '',
    bik: '',
    bankName: ''
  })
}

const clientBadgeClass = (type: string) => {
  return type === 'INDIVIDUAL' ? 'badge bg-info' : 'badge bg-primary'
}

const clientTypeLabel = (type: string) => {
  return type === 'INDIVIDUAL' ? 'Физ. лицо' : 'Юр. лицо'
}

const getClientDisplayName = (client: Client) => {
  if (client.clientType === 'LEGAL_ENTITY' && client.companyName) {
    return client.companyName
  }
  return client.fullName
}

onMounted(() => {
  loadClients()
})
</script>

<style scoped>
.clients-page {
  padding: 1rem;
}

.modal {
  background-color: rgba(0, 0, 0, 0.5);
}
</style>
