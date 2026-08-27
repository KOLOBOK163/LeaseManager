import axios from './axios';
import type { Incident, CreateIncidentRequest, UpdateIncidentRequest } from '@/types/incident';

export const incidentApi = {
  // Создать инцидент
  createIncident(data: CreateIncidentRequest) {
    return axios.post<Incident>('/incidents', data);
  },

  // Получить инцидент по ID
  getIncidentById(id: number) {
    return axios.get<Incident>(`/incidents/${id}`);
  },

  // Получить все инциденты
  getAllIncidents() {
    return axios.get<Incident[]>('/incidents');
  },

  // Получить инциденты по оборудованию
  getIncidentsByEquipment(equipmentId: number) {
    return axios.get<Incident[]>(`/incidents/equipment/${equipmentId}`);
  },

  // Получить инциденты по договору
  getIncidentsByContract(contractId: number) {
    return axios.get<Incident[]>(`/incidents/contract/${contractId}`);
  },

  // Получить активные инциденты
  getActiveIncidents() {
    return axios.get<Incident[]>('/incidents/active');
  },

  // Получить инциденты, требующие компенсации
  getIncidentsRequiringCompensation() {
    return axios.get<Incident[]>('/incidents/requiring-compensation');
  },

  // Обновить инцидент
  updateIncident(id: number, data: UpdateIncidentRequest) {
    return axios.put<Incident>(`/incidents/${id}`, data);
  },

  // Рассчитать компенсацию
  calculateCompensation(id: number) {
    return axios.get<number>(`/incidents/${id}/calculate-compensation`);
  },

  // Удалить инцидент
  deleteIncident(id: number) {
    return axios.delete(`/incidents/${id}`);
  }
};
