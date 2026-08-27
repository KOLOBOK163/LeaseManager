<template>
  <div class="scoring-page">
    <h2 class="mb-4">Скоринг клиентов</h2>

    <div class="card">
      <div class="card-header">
        <h5 class="mb-0">Требуют ручной проверки</h5>
      </div>
      <div class="card-body">
        <div v-if="loading" class="text-center py-5">
          <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Загрузка...</span>
          </div>
        </div>
        <div v-else-if="pendingReviews.length === 0" class="text-center py-5 text-muted">
          Нет скорингов, требующих проверки
        </div>
        <table v-else class="table table-hover">
          <thead>
            <tr>
              <th>Клиент</th>
              <th>Балл</th>
              <th>Дата проверки</th>
              <th>Действия</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in pendingReviews" :key="item.id">
              <td>
                <router-link :to="`/clients/${item.clientId}`" class="text-decoration-none">
                  {{ item.clientName }}
                </router-link>
              </td>
              <td>
                <span :class="scoreBadgeClass(item.score)" class="fw-bold">
                  {{ item.score }}
                </span>
              </td>
              <td>{{ formatDate(item.checkedDate) }}</td>
              <td>
                <button class="btn btn-sm btn-success me-2" @click="approve(item)">
                  Одобрить
                </button>
                <button class="btn btn-sm btn-danger" @click="reject(item)">
                  Отклонить
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { scoringApi, type Scoring } from '@/types/scoring'

const pendingReviews = ref<Scoring[]>([])
const loading = ref(false)

const loadPendingReviews = async () => {
  loading.value = true
  try {
    pendingReviews.value = await scoringApi.getPendingReviews()
  } catch (error) {
    console.error('Failed to load pending reviews:', error)
  } finally {
    loading.value = false
  }
}

const approve = async (scoring: Scoring) => {
  const comment = prompt('Комментарий к одобрению:')
  if (!comment) return

  try {
    await scoringApi.approve(scoring.id, comment)
    alert('Скоринг одобрен')
    loadPendingReviews()
  } catch (error) {
    console.error('Failed to approve:', error)
    alert('Ошибка при одобрении')
  }
}

const reject = async (scoring: Scoring) => {
  const reason = prompt('Причина отказа:')
  if (!reason) return

  try {
    await scoringApi.reject(scoring.id, reason)
    alert('Скоринг отклонён')
    loadPendingReviews()
  } catch (error) {
    console.error('Failed to reject:', error)
    alert('Ошибка при отклонении')
  }
}

const scoreBadgeClass = (score: number) => {
  if (score >= 70) return 'text-success'
  if (score >= 50) return 'text-warning'
  return 'text-danger'
}

const formatDate = (dateString: string) => {
  return new Date(dateString).toLocaleString('ru-RU')
}

onMounted(() => {
  loadPendingReviews()
})
</script>

<style scoped>
.scoring-page {
  padding: 1rem;
}
</style>
