<template>
  <div class="auth-container">
    <div class="auth-card">
      <h2 class="auth-title">Вход в систему</h2>
      
      <form @submit.prevent="handleSubmit">
        <div class="mb-3">
          <label for="username" class="form-label">Имя пользователя или Email</label>
          <input
            type="text"
            class="form-control"
            id="username"
            v-model="form.username"
            placeholder="Введите имя пользователя или email"
            required
          />
        </div>

        <div class="mb-3">
          <label for="password" class="form-label">Пароль</label>
          <input
            type="password"
            class="form-control"
            id="password"
            v-model="form.password"
            placeholder="Введите пароль"
            required
          />
        </div>

        <div v-if="error" class="alert alert-danger" role="alert">
          {{ error }}
        </div>

        <button type="submit" class="btn btn-primary w-100" :disabled="isLoading">
          <span v-if="isLoading" class="spinner-border spinner-border-sm me-2"></span>
          {{ isLoading ? 'Вход...' : 'Войти' }}
        </button>
      </form>

      <div class="auth-footer">
        <p>Нет аккаунта? <router-link to="/register">Зарегистрироваться</router-link></p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { authApi } from '@/api/auth'

const router = useRouter()
const authStore = useAuthStore()

const form = reactive({
  username: '',
  password: ''
})

const error = ref('')
const isLoading = ref(false)

const handleSubmit = async () => {
  error.value = ''
  isLoading.value = true

  try {
    const response = await authApi.login({
      username: form.username,
      password: form.password
    })
    
    authStore.setAuth(response)
    router.push('/dashboard')
  } catch (err: unknown) {
    if (err instanceof Error) {
      error.value = err.message || 'Ошибка при входе'
    } else if (typeof err === 'object' && err !== null && 'message' in err) {
      error.value = (err as { message: string }).message || 'Ошибка при входе'
    } else {
      error.value = 'Ошибка при входе'
    }
  } finally {
    isLoading.value = false
  }
}
</script>

<style scoped>
.auth-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 2rem;
}

.auth-card {
  background: white;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  padding: 2.5rem;
  width: 100%;
  max-width: 400px;
}

.auth-title {
  text-align: center;
  margin-bottom: 2rem;
  color: #333;
  font-weight: 600;
}

.auth-footer {
  margin-top: 1.5rem;
  text-align: center;
  color: #666;
}

.auth-footer a {
  color: #0d6efd;
  text-decoration: none;
  font-weight: 500;
}

.auth-footer a:hover {
  text-decoration: underline;
}
</style>
