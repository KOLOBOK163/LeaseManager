<template>
  <div class="audit-page">
    <h2 class="mb-4">Журнал аудита</h2>

    <!-- Фильтры -->
    <div class="card mb-4">
      <div class="card-body">
        <div class="row g-3">
          <div class="col-md-3">
            <label class="form-label">Действие</label>
            <select class="form-select" v-model="filters.action">
              <option value="">Все действия</option>
              <option value="CREATE">Создание</option>
              <option value="UPDATE">Обновление</option>
              <option value="DELETE">Удаление</option>
              <option value="LOGIN">Вход</option>
              <option value="LOGOUT">Выход</option>
              <option value="STATUS_CHANGE">Смена статуса</option>
            </select>
          </div>
          <div class="col-md-3">
            <label class="form-label">Дата от</label>
            <input type="date" class="form-control" v-model="filters.startDate" />
          </div>
          <div class="col-md-3">
            <label class="form-label">Дата до</label>
            <input type="date" class="form-control" v-model="filters.endDate" />
          </div>
          <div class="col-md-3">
            <label class="form-label">&nbsp;</label>
            <button class="btn btn-primary w-100" @click="() => loadLogs()">
              Применить фильтры
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Таблица логов -->
    <div class="card">
      <div class="card-body">
        <div v-if="loading" class="text-center py-5">
          <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Загрузка...</span>
          </div>
        </div>
        <div v-else-if="logs.length === 0" class="text-center py-5 text-muted">
          Записи не найдены
        </div>
        <div v-else>
          <table class="table table-sm table-hover">
            <thead>
              <tr>
                <th style="width: 180px">Дата/Время</th>
                <th style="width: 150px">Пользователь</th>
                <th style="width: 120px">Действие</th>
                <th style="width: 120px">Сущность</th>
                <th>Описание</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="log in logs" :key="log.id">
                <td>{{ formatDateTime(log.timestamp) }}</td>
                <td>{{ log.username }}</td>
                <td>
                  <span :class="actionBadgeClass(log.action)" class="badge">
                    {{ actionLabel(log.action) }}
                  </span>
                </td>
                <td>{{ log.entityType || '—' }}</td>
                <td>{{ log.description || '—' }}</td>
              </tr>
            </tbody>
          </table>

          <!-- Пагинация -->
          <div class="d-flex justify-content-between align-items-center mt-3">
            <div class="text-muted">
              Показано {{ logs.length }} из {{ totalItems }} записей
            </div>
            <nav>
              <ul class="pagination mb-0">
                <li class="page-item" :class="{ disabled: currentPage === 0 }">
                  <button class="page-link" @click="changePage(currentPage - 1)">
                    Назад
                  </button>
                </li>
                <li class="page-item active">
                  <span class="page-link">{{ currentPage + 1 }}</span>
                </li>
                <li class="page-item" :class="{ disabled: currentPage >= totalPages - 1 }">
                  <button class="page-link" @click="changePage(currentPage + 1)">
                    Вперёд
                  </button>
                </li>
              </ul>
            </nav>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { auditApi, type AuditLog } from '@/types/audit'

const logs = ref<AuditLog[]>([])
const loading = ref(false)
const currentPage = ref(0)
const totalPages = ref(0)
const totalItems = ref(0)

const filters = reactive({
  action: '',
  startDate: '',
  endDate: ''
})

const loadLogs = async (page: number = 0) => {
  loading.value = true
  try {
    // Всегда используем фильтры, даже если они пустые
    const response = await auditApi.getLogsWithFilters(
      {
        action: filters.action && filters.action.trim() !== '' ? filters.action : undefined,
        // Конвертируем даты в ISO DateTime формат только если они заполнены
        startDate: filters.startDate && filters.startDate.trim() !== '' ? `${filters.startDate}T00:00:00` : undefined,
        endDate: filters.endDate && filters.endDate.trim() !== '' ? `${filters.endDate}T23:59:59` : undefined
      },
      page
    )

    logs.value = response.logs
    currentPage.value = response.currentPage
    totalPages.value = response.totalPages
    totalItems.value = response.totalItems
  } catch (error) {
    console.error('Failed to load audit logs:', error)
  } finally {
    loading.value = false
  }
}

const changePage = (page: number) => {
  if (page >= 0 && page < totalPages.value) {
    loadLogs(page)
  }
}

const actionLabel = (action: string) => {
  const labels: Record<string, string> = {
    CREATE: 'Создание',
    UPDATE: 'Обновление',
    DELETE: 'Удаление',
    LOGIN: 'Вход',
    LOGOUT: 'Выход',
    STATUS_CHANGE: 'Смена статуса',
    APPROVE: 'Одобрение',
    REJECT: 'Отклонение',
    EXPORT: 'Экспорт',
    VIEW: 'Просмотр'
  }
  return labels[action] || action
}

const actionBadgeClass = (action: string) => {
  const classes: Record<string, string> = {
    CREATE: 'bg-success',
    UPDATE: 'bg-primary',
    DELETE: 'bg-danger',
    LOGIN: 'bg-info',
    LOGOUT: 'bg-secondary',
    STATUS_CHANGE: 'bg-warning',
    APPROVE: 'bg-success',
    REJECT: 'bg-danger',
    EXPORT: 'bg-info',
    VIEW: 'bg-secondary'
  }
  return classes[action] || 'bg-secondary'
}

const formatDateTime = (dateString: string) => {
  return new Date(dateString).toLocaleString('ru-RU', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit'
  })
}

onMounted(() => {
  loadLogs()
})
</script>

<style scoped>
.audit-page {
  padding: 1rem;
}

.table-sm td,
.table-sm th {
  padding: 0.5rem;
  font-size: 0.875rem;
}
</style>
