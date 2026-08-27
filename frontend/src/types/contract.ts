import api from '../api/axios'

export type ContractStatus = 'DRAFT' | 'ACTIVE' | 'SUSPENDED' | 'CLOSED' | 'CANCELLED'

export interface PaymentSchedule {
  id: number
  periodNumber: number
  paymentDate: string
  totalAmount: number
  principalPart: number
  interestPart: number
  status: string
}

export interface Contract {
  id: number
  contractNumber: string
  client: { id: number; fullName: string }
  equipment: { id: number; name: string }
  startDate: string
  endDate: string
  totalAmount: number
  interestRate: number
  paymentPeriodMonths: number
  status: ContractStatus
  createdDate: string
  description: string
  paymentSchedules?: PaymentSchedule[]
  insurancePolicyNumber?: string
  insuranceCompany?: string
  insurancePremiumAnnual?: number
  insurancePremiumMonthly?: number
  insuranceStartDate?: string
  insuranceExpiryDate?: string
  insuranceCoverageAmount?: number
  insuranceType?: string
  maintenanceProvider?: string
  maintenanceFeeMonthly?: number
  maintenanceIncluded?: boolean
}

export interface CreateContractRequest {
  contractNumber: string
  clientId: number
  equipmentId: number
  startDate: string
  endDate: string
  totalAmount: number
  interestRate?: number
  periodMonths?: number
  description?: string
}

export interface UpdateContractRequest {
  contractNumber: string
  clientId: number
  equipmentId: number
  startDate: string
  endDate: string
  totalAmount: number
  interestRate?: number
  periodMonths?: number
  description?: string
}

export interface ChangeStatusRequest {
  status: ContractStatus
}

export interface ContractStatistics {
  totalAmount: number
  paidAmount: number
  remainingAmount: number
  totalPayments: number
  paidPayments: number
  overduePayments: number
}

export const contractApi = {
  async getContracts(status?: string, search?: string): Promise<Contract[]> {
    const params: any = {}
    if (status) params.status = status
    if (search) params.search = search
    const response = await api.get<Contract[]>('/contracts', { params })
    return response.data
  },

  async getContractById(id: number): Promise<Contract> {
    const response = await api.get<Contract>(`/contracts/${id}`)
    return response.data
  },

  async createContract(request: CreateContractRequest): Promise<Contract> {
    const response = await api.post<Contract>('/contracts', request)
    return response.data
  },

  async updateContract(id: number, request: UpdateContractRequest): Promise<Contract> {
    const response = await api.put<Contract>(`/contracts/${id}`, request)
    return response.data
  },

  async changeStatus(id: number, status: ContractStatus): Promise<Contract> {
    const response = await api.patch<Contract>(`/contracts/${id}/status`, { status })
    return response.data
  },

  async deleteContract(id: number): Promise<void> {
    await api.delete(`/contracts/${id}`)
  },

  async getClients(): Promise<Client[]> {
    const response = await api.get<Client[]>('/clients')
    return response.data
  },

  async getEquipment(): Promise<Equipment[]> {
    const response = await api.get<Equipment[]>('/equipment')
    return response.data
  },

  async getContractStatistics(id: number): Promise<ContractStatistics> {
    const response = await api.get<ContractStatistics>(`/contracts/${id}/statistics`)
    return response.data
  },

  async generatePaymentSchedule(contractId: number, periods?: number): Promise<PaymentSchedule[]> {
    const response = await api.post<PaymentSchedule[]>(`/contracts/${contractId}/payment-schedule/generate`,
      periods ? { periods } : {})
    return response.data
  }
}

export interface Client {
  id: number
  fullName: string
  companyName: string
}

export interface Equipment {
  id: number
  name: string
  status: string
  price: number
}
