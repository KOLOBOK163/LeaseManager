import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/',
      redirect: '/dashboard'
    },
    {
      path: '/login',
      name: 'Login',
      component: () => import('@/views/LoginView.vue'),
      meta: { guest: true }
    },
    {
      path: '/register',
      name: 'Register',
      component: () => import('@/views/RegisterView.vue'),
      meta: { guest: true }
    },
    {
      path: '/dashboard',
      name: 'Dashboard',
      component: () => import('@/views/DashboardView.vue'),
      meta: { requiresAuth: true }
    },
    {
      path: '/clients',
      name: 'Clients',
      component: () => import('@/views/ClientsView.vue'),
      meta: { requiresAuth: true }
    },
    {
      path: '/clients/:id',
      name: 'ClientDetail',
      component: () => import('@/views/ClientDetailView.vue'),
      meta: { requiresAuth: true }
    },
    {
      path: '/equipment',
      name: 'Equipment',
      component: () => import('@/views/EquipmentView.vue'),
      meta: { requiresAuth: true }
    },
    {
      path: '/equipment/:id',
      name: 'EquipmentDetail',
      component: () => import('@/views/EquipmentDetailView.vue'),
      meta: { requiresAuth: true }
    },
    {
      path: '/contracts',
      name: 'Contracts',
      component: () => import('@/views/ContractsView.vue'),
      meta: { requiresAuth: true }
    },
    {
      path: '/contracts/:id',
      name: 'ContractDetail',
      component: () => import('@/views/ContractDetailView.vue'),
      meta: { requiresAuth: true }
    },
    {
      path: '/contracts/:contractId/payments',
      name: 'PaymentSchedules',
      component: () => import('@/views/PaymentSchedulesView.vue'),
      meta: { requiresAuth: true }
    },
    {
      path: '/admin/users',
      name: 'Users',
      component: () => import('@/views/UsersView.vue'),
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/scoring',
      name: 'Scoring',
      component: () => import('@/views/ScoringView.vue'),
      meta: { requiresAuth: true }
    },
    {
      path: '/audit',
      name: 'AuditLog',
      component: () => import('@/views/AuditLogView.vue'),
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/incidents',
      name: 'Incidents',
      component: () => import('@/views/IncidentsView.vue'),
      meta: { requiresAuth: true }
    }
  ]
})

// Навигационный хук для защиты роутов
router.beforeEach((to, _from, next) => {
  const authStore = useAuthStore()
  authStore.initAuth()

  const isAuthenticated = authStore.isAuthenticated
  const userRole = authStore.userRole

  if (to.meta.requiresAuth && !isAuthenticated) {
    next('/login')
  } else if (to.meta.guest && isAuthenticated) {
    next('/dashboard')
  } else if (to.meta.requiresAdmin && userRole !== 'ADMIN') {
    // Доступ только для администраторов
    next('/dashboard')
  } else {
    next()
  }
})

export default router
