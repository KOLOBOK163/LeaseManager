<template>
  <div class="incidents-page">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h2>Инциденты с оборудованием</h2>
      <button class="btn btn-primary" @click="showCreateModal = true">
        <i class="bi bi-plus-circle me-2"></i>
        Зарегистрировать инцидент
      </button>
    </div>

    <!-- Фильтры -->
    <div class="card mb-4">
      <div class="card-body">
        <div class="row g-3">
          <div class="col-md-3">
            <label class="form-label">Тип инцидента</label>
            <select v-model="filters.type" class="form-select">
              <option value="">Все</option>
              <option value="BREAKDOWN">Поломка</option>
              <option value="DAMAGE">Повреждение</option>
              <option value="THEFT">Кража</option>
              <option value="FORCE_MAJEURE">Форс-мажор</option>
              <option value="LOSS">Утрата</option>
            </select>
          </div>
          <div class="col-md-3">
            <label class="form-label">Статус</label>
            <select v-model="filters.status" class="form-select">
              <option value="">Все</option>
              <option value="REPORTED">Зарегистрирован</option>
              <option value="UNDER_INVESTIGATION">Расследуется</option>
              <option value="IN_REPAIR">В ремонте</option>
              <option value="RESOLVED">Решён</option>
              <option value="CLOSED">Закрыт</option>
            </select>
          </div>
          <div class="col-md-3">
            <label class="form-label">Ответственная сторона</label>
            <select v-model="filters.responsible" class="form-select">
              <option value="">Все</option>
              <option value="LESSOR">Лизингодатель</option>
              <option value="LESSEE">Лизингополучатель</option>
              <option value="INSURANCE">Страховая</option>
            </select>
          </div>
          <div class="col-md-3 d-flex align-items-end">
            <button class="btn btn-outline-secondary w-100" @click="resetFilters">
              Сбросить
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Список инцидентов -->
    <div v-if="loading" class="text-center py-5">
      <div class="spinner-border text-primary"></div>
    </div>

    <div v-else-if="filteredIncidents.length === 0" class="alert alert-info">
      Инциденты не найдены
    </div>

    <div v-else class="row">
      <div v-for="incident in filteredIncidents" :key="incident.id" class="col-md-6 mb-3">
        <div class="card h-100">
          <div class="card-body">
            <div class="d-flex justify-content-between align-items-start mb-3">
              <h5 class="card-title mb-0">
                {{ incidentTypeLabel(incident.incidentType) }}
                <span v-if="incident.critical" class="badge bg-danger ms-2">Критический</span>
              </h5>
              <span :class="statusBadgeClass(incident.status)">
                {{ statusLabel(incident.status) }}
              </span>
            </div>

            <div class="mb-2">
              <strong>Оборудование:</strong> {{ incident.equipmentName }}
            </div>
            <div class="mb-2" v-if="incident.contractNumber">
              <strong>Договор:</strong> {{ incident.contractNumber }}
            </div>
            <div class="mb-2">
              <strong>Дата:</strong> {{ formatDate(incident.incidentDate) }}
            </div>
            <div class="mb-2">
              <strong>Ответственный:</strong> {{ responsibleLabel(incident.responsibleParty) }}
            </div>
            <div class="mb-2" v-if="incident.estimatedCost">
              <strong>Оценка ущерба:</strong> {{ formatMoney(incident.estimatedCost) }}
            </div>
            <div class="mb-3">
              <strong>Описание:</strong>
              <p class="text-muted mb-0">{{ incident.description }}</p>
            </div>

            <div class="d-flex gap-2">
              <button class="btn btn-sm btn-outline-primary" @click="viewIncident(incident)">
                Подробнее
              </button>
              <button
                v-if="incident.requiresCompensation && !incident.compensationAmount"
                class="btn btn-sm btn-warning"
                @click="calculateCompensation(incident.id)">
                Рассчитать компенсацию
              </button>
              <button
                v-if="incident.status !== 'RESOLVED' && incident.status !== 'CLOSED'"
                class="btn btn-sm btn-success"
                @click="resolveIncident(incident)">
                Закрыть
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Модальное окно создания инцидента -->
    <div class="modal" :class="{ show: showCreateModal }" @click.self="showCreateModal = false">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Зарегистрировать инцидент</h5>
            <button type="button" class="btn-close" @click="showCreateModal = false"></button>
          </div>
          <div class="modal-body">
            <form @submit.prevent="createIncident">
              <div class="mb-3">
                <label class="form-label">Оборудование *</label>
                <input v-model.number="newIncident.equipmentId" type="number" class="form-control" required>
              </div>
              <div class="mb-3">
                <label class="form-label">Договор (опционально)</label>
                <input v-model.number="newIncident.contractId" type="number" class="form-control">
              </div>
              <div class="mb-3">
                <label class="form-label">Тип инцидента *</label>
                <select v-model="newIncident.incidentType" class="form-select" required>
                  <option value="BREAKDOWN">Поломка</option>
                  <option value="DAMAGE">Повреждение</option>
                  <option value="THEFT">Кража</option>
                  <option value="FORCE_MAJEURE">Форс-мажор</option>
                  <option value="LOSS">Утрата</option>
                </select>
              </div>
              <div class="mb-3">
                <label class="form-label">Описание *</label>
                <textarea v-model="newIncident.description" class="form-control" rows="3" required></textarea>
              </div>
              <div class="mb-3">
                <label class="form-label">Ответственная сторона</label>
                <select v-model="newIncident.responsibleParty" class="form-select">
                  <option value="UNDER_INVESTIGATION">Расследуется</option>
                  <option value="LESSOR">Лизингодатель</option>
                  <option value="LESSEE">Лизингополучатель</option>
                  <option value="INSURANCE">Страховая</option>
                </select>
              </div>
              <div class="mb-3">
                <label class="form-label">Оценка ущерба (₽)</label>
                <input v-model.number="newIncident.estimatedCost" type="number" class="form-control">
              </div>
              <div class="d-flex justify-content-end gap-2">
                <button type="button" class="btn btn-secondary" @click="showCreateModal = false">
                  Отмена
                </button>
                <button type="submit" class="btn btn-primary">
                  Зарегистрировать
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import { incidentApi } from '@/api/incident';
import type { Incident, CreateIncidentRequest } from '@/types/incident';

const incidents = ref<Incident[]>([]);
const loading = ref(false);
const showCreateModal = ref(false);

const filters = ref({
  type: '',
  status: '',
  responsible: ''
});

const newIncident = ref<CreateIncidentRequest>({
  equipmentId: 0,
  incidentType: 'BREAKDOWN',
  description: '',
  responsibleParty: 'UNDER_INVESTIGATION'
});

const filteredIncidents = computed(() => {
  return incidents.value.filter(incident => {
    if (filters.value.type && incident.incidentType !== filters.value.type) return false;
    if (filters.value.status && incident.status !== filters.value.status) return false;
    if (filters.value.responsible && incident.responsibleParty !== filters.value.responsible) return false;
    return true;
  });
});

const loadIncidents = async () => {
  loading.value = true;
  try {
    const response = await incidentApi.getAllIncidents();
    incidents.value = response.data;
  } catch (error) {
    console.error('Ошибка загрузки инцидентов:', error);
  } finally {
    loading.value = false;
  }
};

const createIncident = async () => {
  try {
    await incidentApi.createIncident(newIncident.value);
    showCreateModal.value = false;
    await loadIncidents();
    alert('Инцидент зарегистрирован');
  } catch (error) {
    console.error('Ошибка создания инцидента:', error);
    alert('Ошибка при регистрации инцидента');
  }
};

const calculateCompensation = async (id: number) => {
  try {
    const response = await incidentApi.calculateCompensation(id);
    alert(`Расчётная компенсация: ${formatMoney(response.data)}`);
  } catch (error) {
    console.error('Ошибка расчёта компенсации:', error);
  }
};

const resolveIncident = async (incident: Incident) => {
  if (!confirm('Закрыть инцидент?')) return;
  try {
    await incidentApi.updateIncident(incident.id, {
      status: 'RESOLVED',
      resolutionNotes: 'Инцидент решён'
    });
    await loadIncidents();
  } catch (error) {
    console.error('Ошибка закрытия инцидента:', error);
  }
};

const viewIncident = (incident: Incident) => {
  alert(`Инцидент #${incident.id}\n\n${JSON.stringify(incident, null, 2)}`);
};

const resetFilters = () => {
  filters.value = { type: '', status: '', responsible: '' };
};

const incidentTypeLabel = (type: string) => {
  const labels: Record<string, string> = {
    BREAKDOWN: 'Поломка',
    DAMAGE: 'Повреждение',
    THEFT: 'Кража',
    FORCE_MAJEURE: 'Форс-мажор',
    LOSS: 'Утрата'
  };
  return labels[type] || type;
};

const statusLabel = (status: string) => {
  const labels: Record<string, string> = {
    REPORTED: 'Зарегистрирован',
    UNDER_INVESTIGATION: 'Расследуется',
    REPAIR_SCHEDULED: 'Запланирован ремонт',
    IN_REPAIR: 'В ремонте',
    RESOLVED: 'Решён',
    CLOSED: 'Закрыт',
    CANCELLED: 'Отменён'
  };
  return labels[status] || status;
};

const responsibleLabel = (party: string) => {
  const labels: Record<string, string> = {
    LESSOR: 'Лизингодатель',
    LESSEE: 'Лизингополучатель',
    INSURANCE: 'Страховая',
    FORCE_MAJEURE: 'Форс-мажор',
    UNDER_INVESTIGATION: 'Расследуется'
  };
  return labels[party] || party;
};

const statusBadgeClass = (status: string) => {
  const classes: Record<string, string> = {
    REPORTED: 'badge bg-info',
    UNDER_INVESTIGATION: 'badge bg-warning',
    IN_REPAIR: 'badge bg-primary',
    RESOLVED: 'badge bg-success',
    CLOSED: 'badge bg-secondary',
    CANCELLED: 'badge bg-danger'
  };
  return classes[status] || 'badge bg-secondary';
};

const formatDate = (date: string) => {
  return new Date(date).toLocaleDateString('ru-RU');
};

const formatMoney = (amount: number) => {
  return new Intl.NumberFormat('ru-RU', {
    style: 'currency',
    currency: 'RUB'
  }).format(amount);
};

onMounted(() => {
  loadIncidents();
});
</script>

<style scoped>
.modal.show {
  display: block;
  background: rgba(0, 0, 0, 0.5);
}
</style>
