import api from '../api/axios'

export type PaymentScheduleStatus = 'PENDING' | 'PAID' | 'OVERDUE' | 'PARTIAL' | 'CANCELLED'

export interface PaymentSchedule {
  id: number
  contractId: number
  periodNumber: number
  paymentDate: string
  totalAmount: number
  principalPart: number
  interestPart: number
  status: PaymentScheduleStatus
  overdue: boolean
}

export interface MarkAsPaidRequest {
  comment?: string
}

export const paymentScheduleApi = {
  async getSchedulesByContractId(contractId: number): Promise<PaymentSchedule[]> {
    const response = await api.get<PaymentSchedule[]>(`/payment-schedules/contract/${contractId}`)
    return response.data
  },

  async getOverdueSchedules(): Promise<PaymentSchedule[]> {
    const response = await api.get<PaymentSchedule[]>('/payment-schedules/overdue')
    return response.data
  },

  async markAsPaid(id: number, request?: MarkAsPaidRequest): Promise<PaymentSchedule> {
    const response = await api.post<PaymentSchedule>(`/payment-schedules/${id}/pay`, request || {})
    return response.data
  },

  async cancelSchedule(id: number): Promise<PaymentSchedule> {
    const response = await api.post<PaymentSchedule>(`/payment-schedules/${id}/cancel`)
    return response.data
  }
}

// Типы для регистрации платежей
export type PaymentType = 'PRINCIPAL' | 'INTEREST' | 'PENALTY' | 'ADDITIONAL'
export type PaymentStatus = 'PENDING' | 'PAID' | 'CANCELLED' | 'PARTIAL'
export type PaymentMethod = 'BANK_TRANSFER' | 'CASH' | 'CARD'

export interface Payment {
  id: number
  scheduleId: number
  contractId: number
  contractNumber: string
  periodNumber: number
  amount: number
  dueDate: string
  paidDate: string | null
  paymentType: PaymentType
  paymentMethod: PaymentMethod | null
  status: PaymentStatus
  comment: string | null
}

export interface RegisterPaymentRequest {
  scheduleId: number
  amount: number
  paymentDate: string
  paymentType?: PaymentType
  paymentMethod?: PaymentMethod
  comment?: string
  documentNumber?: string
}

export const paymentApi = {
  async getPaymentsByContractId(contractId: number): Promise<Payment[]> {
    const response = await api.get<Payment[]>(`/payments/contract/${contractId}`)
    return response.data
  },

  async registerPayment(request: RegisterPaymentRequest): Promise<Payment> {
    const response = await api.post<Payment>('/payments/register', request)
    return response.data
  },

  async markAsPaid(id: number): Promise<Payment> {
    const response = await api.put<Payment>(`/payments/${id}/pay`)
    return response.data
  },

  async deletePayment(id: number): Promise<void> {
    await api.delete(`/payments/${id}`)
  }
}
