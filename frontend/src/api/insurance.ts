import axios from './axios';
import type { Insurance, InsuranceRequest } from '@/types/insurance';
import type { Contract } from '@/types/contract';

export const insuranceApi = {
  // Добавить страхование к договору
  addInsurance(contractId: number, data: InsuranceRequest) {
    return axios.post<Contract>(`/api/insurance/contract/${contractId}`, data);
  },

  // Обновить страхование
  updateInsurance(contractId: number, data: InsuranceRequest) {
    return axios.put<Contract>(`/api/insurance/contract/${contractId}`, data);
  },

  // Получить информацию о страховании
  getInsurance(contractId: number) {
    return axios.get<Insurance>(`/api/insurance/contract/${contractId}`);
  },

  // Рассчитать страховую премию для оборудования
  calculatePremium(equipmentId: number) {
    return axios.get<number>(`/api/insurance/calculate-premium/equipment/${equipmentId}`);
  },

  // Рассчитать ежемесячную премию
  calculateMonthlyPremium(annualPremium: number) {
    return axios.get<number>(`/api/insurance/calculate-monthly-premium`, {
      params: { annualPremium }
    });
  },

  // Получить договоры с истекающей страховкой
  getExpiringInsurance(daysAhead: number = 30) {
    return axios.get<Contract[]>(`/api/insurance/expiring`, {
      params: { daysAhead }
    });
  },

  // Получить договоры с просроченной страховкой
  getExpiredInsurance() {
    return axios.get<Contract[]>(`/api/insurance/expired`);
  }
};
