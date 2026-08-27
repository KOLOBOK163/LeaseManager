<template>
  <div id="app">
    <Header v-if="isAuthenticated" />
    <main :class="{ 'container-fluid py-4': isAuthenticated }">
      <router-view />
    </main>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import Header from '@/components/Header.vue'
import { useAuthStore } from '@/stores/auth'

const authStore = useAuthStore()
const isAuthenticated = computed(() => authStore.isAuthenticated)
</script>

<style>
#app {
  min-height: 100vh;
  background-color: #f8f9fa;
}

main.container-fluid {
  max-width: 1400px;
}
</style>
