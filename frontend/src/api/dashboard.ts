import api from './axios'

export interface DashboardStats {
  activeContracts: number
  totalClients: number
  overduePayments: number
  freeEquipment: number
}

export interface PaymentChart {
  months: string[]
  amounts: number[]
}

export interface UpcomingPayment {
  paymentScheduleId: number
  contractId: number
  contractNumber: string
  clientName: string
  paymentDate: string
  amount: number
  status: string
}

export const dashboardApi = {
  async getStats(): Promise<DashboardStats> {
    const response = await api.get<DashboardStats>('/dashboard/stats')
    return response.data
  },

  async getPaymentChart(): Promise<PaymentChart> {
    const response = await api.get<PaymentChart>('/dashboard/payment-chart')
    return response.data
  },

  async getUpcomingPayments(): Promise<UpcomingPayment[]> {
    const response = await api.get<UpcomingPayment[]>('/dashboard/upcoming-payments')
    return response.data
  }
}
