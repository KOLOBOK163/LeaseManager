import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { AuthResponse } from '@/types/auth'

export const useAuthStore = defineStore('auth', () => {
  const accessToken = ref<string | null>(localStorage.getItem('accessToken'))
  const user = ref<{
    userId: number
    username: string
    role: string
  } | null>(null)

  const isAuthenticated = computed(() => !!accessToken.value)
  const userRole = computed(() => user.value?.role || null)
  const username = computed(() => user.value?.username || null)

  function setAuth(authResponse: AuthResponse) {
    accessToken.value = authResponse.accessToken
    user.value = {
      userId: authResponse.userId,
      username: authResponse.username,
      role: authResponse.role
    }
    localStorage.setItem('accessToken', authResponse.accessToken)
    localStorage.setItem('user', JSON.stringify(user.value))
  }

  function logout() {
    accessToken.value = null
    user.value = null
    localStorage.removeItem('accessToken')
    localStorage.removeItem('user')
  }

  function initAuth() {
    const token = localStorage.getItem('accessToken')
    const userStr = localStorage.getItem('user')
    if (token && !user.value) {
      accessToken.value = token
      if (userStr) {
        try {
          user.value = JSON.parse(userStr)
        } catch {
          // Invalid user data
        }
      }
    }
  }

  return {
    accessToken,
    user,
    userRole,
    username,
    isAuthenticated,
    setAuth,
    logout,
    initAuth
  }
})
