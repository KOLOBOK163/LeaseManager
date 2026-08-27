<template>
  <div class="users-page">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h2>Управление пользователями</h2>
      <button class="btn btn-primary" @click="showCreateModal = true">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" class="me-1">
          <path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4z"/>
        </svg>
        Добавить пользователя
      </button>
    </div>

    <!-- Таблица пользователей -->
    <div class="card">
      <div class="card-body">
        <div v-if="loading" class="text-center py-5">
          <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Загрузка...</span>
          </div>
        </div>
        <div v-else-if="users.length === 0" class="text-center py-5 text-muted">
          Пользователи не найдены
        </div>
        <table v-else class="table table-hover">
          <thead>
            <tr>
              <th>ID</th>
              <th>Имя пользователя</th>
              <th>ФИО</th>
              <th>Email</th>
              <th>Роль</th>
              <th>Статус</th>
              <th class="text-end">Действия</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="user in users" :key="user.id">
              <td>{{ user.id }}</td>
              <td><strong>{{ user.username }}</strong></td>
              <td>{{ user.fullName }}</td>
              <td>{{ user.email }}</td>
              <td>
                <span :class="roleBadgeClass(user.role)">
                  {{ roleLabel(user.role) }}
                </span>
              </td>
              <td>
                <span :class="user.active ? 'badge bg-success' : 'badge bg-secondary'">
                  {{ user.active ? 'Активен' : 'Заблокирован' }}
                </span>
              </td>
              <td class="text-end">
                <div class="btn-group btn-group-sm">
                  <button
                    :class="user.active ? 'btn btn-outline-warning' : 'btn btn-outline-success'"
                    @click="toggleUserActive(user)"
                    :title="user.active ? 'Заблокировать' : 'Разблокировать'">
                    <svg v-if="user.active" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                      <path d="M8 1a2 2 0 0 1 2 2v4H6V3a2 2 0 0 1 2-2zm3 6V3a3 3 0 0 0-6 0v4a2 2 0 0 0-2 2v5a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2z"/>
                    </svg>
                    <svg v-else xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                      <path d="M11 1a2 2 0 0 0-2 2v4a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V9a2 2 0 0 1 2-2h5V3a3 3 0 0 1 6 0v4a.5.5 0 0 1-1 0V3a2 2 0 0 0-2-2z"/>
                    </svg>
                  </button>
                  <button class="btn btn-outline-primary" @click="showChangePasswordModal(user)" title="Сменить пароль">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                      <path d="M8 1a2 2 0 0 1 2 2v2H6V3a2 2 0 0 1 2-2zm3 4V3a3 3 0 1 0-6 0v2H3.36a1.5 1.5 0 0 0-1.483 1.277L.85 13.13A1.5 1.5 0 0 0 2.34 15h11.32a1.5 1.5 0 0 0 1.488-1.87l-1.04-4.853A1.5 1.5 0 0 0 12.64 5H11zm-4 7a1 1 0 1 1-2 0 1 1 0 0 1 2 0zm3-1a1 1 0 1 0 0 2 1 1 0 0 0 0-2z"/>
                    </svg>
                  </button>
                  <button class="btn btn-outline-secondary" @click="editUser(user)" title="Редактировать">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                      <path d="M12.146.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1 0 .708l-10 10a.5.5 0 0 1-.168.11l-5 2a.5.5 0 0 1-.65-.65l2-5a.5.5 0 0 1 .11-.168l10-10zM11.207 2.5 13.5 4.793 14.793 3.5 12.5 1.207 11.207 2.5zm1.586 3L10.5 3.207 4 9.707V10h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.293l6.5-6.5zm-9.761 5.175-.106.106-1.528 3.821 3.821-1.528.106-.106A.5.5 0 0 1 5 12.5V12h-.5a.5.5 0 0 1-.5-.5V11h-.5a.5.5 0 0 1-.468-.325z"/>
                    </svg>
                  </button>
                  <button class="btn btn-outline-danger" @click="confirmDeleteUser(user)" title="Удалить" :disabled="user.username === currentUser?.username">
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
      <div class="modal-dialog modal-sm">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">{{ showCreateModal ? 'Новый пользователь' : 'Редактирование пользователя' }}</h5>
            <button type="button" class="btn-close" @click="closeModal"></button>
          </div>
          <div class="modal-body">
            <form @submit.prevent="submitForm">
              <div class="mb-3">
                <label class="form-label">Имя пользователя *</label>
                <input type="text" class="form-control" v-model="form.username" required />
              </div>
              <div class="mb-3">
                <label class="form-label">ФИО *</label>
                <input type="text" class="form-control" v-model="form.fullName" :required="showCreateModal" />
              </div>
              <div class="mb-3">
                <label class="form-label">Email *</label>
                <input type="email" class="form-control" v-model="form.email" :required="showCreateModal" />
              </div>
              <div class="mb-3">
                <label class="form-label">Пароль {{ showEditModal ? '(оставьте пустым, чтобы не менять)' : '*' }}</label>
                <input type="password" class="form-control" :required="showCreateModal" v-model="form.password" />
              </div>
              <div class="mb-3">
                <label class="form-label">Роль *</label>
                <select class="form-select" v-model="form.role" required>
                  <option value="MANAGER">Менеджер</option>
                  <option value="ADMIN">Администратор</option>
                </select>
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

    <!-- Модальное окно смены пароля -->
    <div v-if="showPasswordModal" class="modal fade show d-block" tabindex="-1">
      <div class="modal-dialog modal-sm">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Смена пароля</h5>
            <button type="button" class="btn-close" @click="showPasswordModal = false"></button>
          </div>
          <div class="modal-body">
            <p class="mb-2"><strong>{{ selectedUser?.username }}</strong></p>
            <div class="mb-3">
              <label class="form-label">Новый пароль *</label>
              <input type="password" class="form-control" v-model="newPassword" minlength="6" required />
              <small class="text-muted">Минимум 6 символов</small>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" @click="showPasswordModal = false">Отмена</button>
            <button type="button" class="btn btn-primary" @click="submitPasswordChange" :disabled="submittingPassword">
              {{ submittingPassword ? 'Сохранение...' : 'Применить' }}
            </button>
          </div>
        </div>
      </div>
    </div>
    <div v-if="showPasswordModal" class="modal-backdrop fade show"></div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue'
import { usersApi, type User, type UserRole, type CreateUserRequest, type UpdateUserRequest } from '@/types/user'

const users = ref<User[]>([])
const loading = ref(true)
const submitting = ref(false)
const submittingPassword = ref(false)
const showCreateModal = ref(false)
const showEditModal = ref(false)
const showPasswordModal = ref(false)
const editingUserId = ref<number | null>(null)
const selectedUser = ref<User | null>(null)
const newPassword = ref('')

// Получение текущего пользователя из localStorage
const currentUser = computed(() => {
  const userStr = localStorage.getItem('user')
  if (userStr) {
    try {
      return JSON.parse(userStr)
    } catch {
      return null
    }
  }
  return null
})

const form = reactive<CreateUserRequest>({
  username: '',
  password: '',
  role: 'MANAGER',
  fullName: '',
  email: ''
})

const loadUsers = async () => {
  loading.value = true
  try {
    users.value = await usersApi.getAllUsers()
  } catch (error) {
    console.error('Failed to load users:', error)
    alert('Ошибка при загрузке пользователей')
  } finally {
    loading.value = false
  }
}

const toggleUserActive = async (user: User) => {
  const action = user.active ? 'заблокировать' : 'разблокировать'
  if (!confirm(`Вы уверены, что хотите ${action} пользователя "${user.username}"?`)) return

  try {
    await usersApi.toggleActive(user.id, !user.active)
    loadUsers()
  } catch (error: any) {
    console.error('Failed to toggle user active status:', error)
    const message = error.response?.data?.message || 'Ошибка при изменении статуса пользователя'
    alert(message)
  }
}

const editUser = (user: User) => {
  editingUserId.value = user.id
  form.username = user.username
  form.password = ''
  form.role = user.role
  form.fullName = user.fullName
  form.email = user.email
  showEditModal.value = true
}

const submitForm = async () => {
  submitting.value = true
  try {
    if (editingUserId.value) {
      const updateData: UpdateUserRequest = {
        username: form.username || undefined,
        role: form.role || undefined,
        fullName: form.fullName || undefined,
        email: form.email || undefined
      }
      if (form.password && form.password.length > 0) {
        updateData.password = form.password
      }
      await usersApi.updateUser(editingUserId.value, updateData)
    } else {
      await usersApi.createUser(form as CreateUserRequest)
    }
    closeModal()
    loadUsers()
  } catch (error: any) {
    console.error('Failed to save user:', error)
    const message = error.response?.data?.message || 'Ошибка при сохранении пользователя'
    alert(message)
  } finally {
    submitting.value = false
  }
}

const showChangePasswordModal = (user: User) => {
  selectedUser.value = user
  newPassword.value = ''
  showPasswordModal.value = true
}

const submitPasswordChange = async () => {
  if (!selectedUser.value || newPassword.value.length < 6) {
    alert('Пароль должен быть не менее 6 символов')
    return
  }
  submittingPassword.value = true
  try {
    await usersApi.changePassword(selectedUser.value.id, newPassword.value)
    showPasswordModal.value = false
    alert('Пароль успешно изменён')
  } catch (error: any) {
    console.error('Failed to change password:', error)
    const message = error.response?.data?.message || 'Ошибка при смене пароля'
    alert(message)
  } finally {
    submittingPassword.value = false
  }
}

const confirmDeleteUser = async (user: User) => {
  if (!confirm(`Удалить пользователя "${user.username}"?`)) return
  try {
    await usersApi.deleteUser(user.id)
    loadUsers()
  } catch (error: any) {
    console.error('Failed to delete user:', error)
    const message = error.response?.data?.message || 'Ошибка при удалении пользователя'
    alert(message)
  }
}

const closeModal = () => {
  showCreateModal.value = false
  showEditModal.value = false
  editingUserId.value = null
  form.username = ''
  form.password = ''
  form.role = 'MANAGER'
  form.fullName = ''
  form.email = ''
}

const roleBadgeClass = (role: string) => {
  return role === 'ADMIN' ? 'badge bg-danger' : 'badge bg-primary'
}

const roleLabel = (role: string) => {
  return role === 'ADMIN' ? 'Администратор' : 'Менеджер'
}

onMounted(() => {
  loadUsers()
})
</script>

<style scoped>
.users-page {
  padding: 1rem;
}

.modal {
  background-color: rgba(0, 0, 0, 0.5);
}
</style>
