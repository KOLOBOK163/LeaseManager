import api from '../api/axios'

export interface Client {
  id: number
  fullName: string
  phoneNumber: string
  email: string
  clientType: 'INDIVIDUAL' | 'LEGAL_ENTITY'
  inn: string

  // Поля для физических лиц
  passportSeries?: string
  passportNumber?: string
  passportIssuedBy?: string
  passportIssueDate?: string
  passportDepartmentCode?: string
  registrationAddress?: string
  birthDate?: string

  // Поля для юридических лиц
  companyName?: string
  kpp?: string
  ogrn?: string
  legalAddress?: string
  actualAddress?: string
  contactPersonPosition?: string

  // Банковские реквизиты
  bankAccount?: string
  bik?: string
  bankName?: string

  createdDate: string
  updatedDate: string
  contracts?: Contract[]
}

export interface Contract {
  id: number
  contractNumber: string
  clientId: number
  clientName: string
  equipmentId: number
  equipmentName: string
  startDate: string
  endDate: string
  totalAmount: number
  interestRate: number
  paymentPeriodMonths: number
  status: 'DRAFT' | 'ACTIVE' | 'SUSPENDED' | 'CLOSED' | 'CANCELLED'
  description: string
}

export interface CreateClientRequest {
  fullName: string
  phoneNumber: string
  email: string
  clientType: 'INDIVIDUAL' | 'LEGAL_ENTITY'
  inn?: string

  // Поля для физических лиц
  passportSeries?: string
  passportNumber?: string
  passportIssuedBy?: string
  passportIssueDate?: string
  passportDepartmentCode?: string
  registrationAddress?: string
  birthDate?: string

  // Поля для юридических лиц
  companyName?: string
  kpp?: string
  ogrn?: string
  legalAddress?: string
  actualAddress?: string
  contactPersonPosition?: string

  // Банковские реквизиты
  bankAccount?: string
  bik?: string
  bankName?: string
}

export interface UpdateClientRequest {
  fullName: string
  phoneNumber: string
  email: string
  clientType: 'INDIVIDUAL' | 'LEGAL_ENTITY'
  inn?: string

  // Поля для физических лиц
  passportSeries?: string
  passportNumber?: string
  passportIssuedBy?: string
  passportIssueDate?: string
  passportDepartmentCode?: string
  registrationAddress?: string
  birthDate?: string

  // Поля для юридических лиц
  companyName?: string
  kpp?: string
  ogrn?: string
  legalAddress?: string
  actualAddress?: string
  contactPersonPosition?: string

  // Банковские реквизиты
  bankAccount?: string
  bik?: string
  bankName?: string
}

export const clientApi = {
  async getClients(search?: string): Promise<Client[]> {
    const params = search ? { search } : {}
    const response = await api.get<Client[]>('/clients', { params })
    return response.data
  },

  async getClientById(id: number): Promise<Client> {
    const response = await api.get<Client>(`/clients/${id}`)
    return response.data
  },

  async createClient(request: CreateClientRequest): Promise<Client> {
    const response = await api.post<Client>('/clients', request)
    return response.data
  },

  async updateClient(id: number, request: UpdateClientRequest): Promise<Client> {
    const response = await api.put<Client>(`/clients/${id}`, request)
    return response.data
  },

  async deleteClient(id: number): Promise<void> {
    await api.delete(`/clients/${id}`)
  }
}
