<template>
  <div class="equipment-detail-view">
    <div class="container-fluid py-4">
      <div v-if="loading" class="text-center py-5">
        <div class="spinner-border text-primary" role="status">
          <span class="visually-hidden">Загрузка...</span>
        </div>
      </div>

      <div v-else-if="error" class="alert alert-danger">
        {{ error }}
      </div>

      <EquipmentDetailCard
        v-else-if="equipment"
        :equipment="equipment"
        @close="goBack"
        @edit="editEquipment"
        @create-contract="createContract"
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import EquipmentDetailCard from '@/components/EquipmentDetailCard.vue'
import { equipmentApi, type Equipment } from '@/types/equipment'

const route = useRoute()
const router = useRouter()

const equipment = ref<Equipment | null>(null)
const loading = ref(true)
const error = ref('')

const loadEquipment = async () => {
  loading.value = true
  error.value = ''
  try {
    const id = Number(route.params.id)
    const allEquipment = await equipmentApi.getEquipment()
    equipment.value = allEquipment.find(e => e.id === id) || null

    if (!equipment.value) {
      error.value = 'Оборудование не найдено'
    }
  } catch (err) {
    console.error('Failed to load equipment:', err)
    error.value = 'Ошибка загрузки данных'
  } finally {
    loading.value = false
  }
}

const goBack = () => {
  router.push('/equipment')
}

const editEquipment = (item: Equipment) => {
  router.push(`/equipment/${item.id}/edit`)
}

const createContract = (item: Equipment) => {
  router.push({
    path: '/contracts',
    query: { equipmentId: item.id }
  })
}

onMounted(() => {
  loadEquipment()
})
</script>

<style scoped>
.equipment-detail-view {
  min-height: 100vh;
  background: #f8f9fa;
}
</style>
