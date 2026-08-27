import api from '../api/axios'

export type EquipmentStatus = 'AVAILABLE' | 'LEASED' | 'MAINTENANCE' | 'SOLD' | 'WRITE_OFF'

export type EquipmentType = 
  | 'REFRIGERATOR'      // Холодильник
  | 'FREEZER'           // Морозильник
  | 'SHOWCASE'          // Витрина
  | 'CASH_REGISTER'     // Кассовый аппарат
  | 'SCALE'             // Весы
  | 'SHELVING'          // Стеллажи
  | 'COOLER'            // Охладитель
  | 'HEAT_DISPLAY'      // Тепловая витрина
  | 'SLICER'            // Слайсер
  | 'PACKAGING_MACHINE' // Упаковочная машина
  | 'TERMINAL'          // Платёжный терминал
  | 'SCANNER'           // Сканер штрих-кодов
  | 'OTHER'             // Другое

export interface Equipment {
  id: number
  name: string
  categoryId: number
  categoryName: string
  price: number
  model: string
  manufacturer: string
  serialNumber: string
  yearOfManufacture: number
  status: EquipmentStatus
  description: string
  
  // Характеристики торгового оборудования
  equipmentType?: EquipmentType
  dimensions?: string
  weight?: number
  powerConsumption?: number
  voltage?: number
  minTemperature?: number
  maxTemperature?: number
  volume?: number
  bodyMaterial?: string
  installationAddress?: string
  installationDate?: string
  nextMaintenanceDate?: string
  warrantyMonths?: number
  serviceContractNumber?: string
  energyClass?: string
  countryOfOrigin?: string
  lastMaintenanceDate?: string
  maintenanceNotes?: string
}

export interface CreateEquipmentRequest {
  name: string
  categoryId: number
  price: number
  model?: string
  manufacturer?: string
  serialNumber?: string
  yearOfManufacture?: number
  status?: EquipmentStatus
  description?: string
  
  // Характеристики торгового оборудования
  equipmentType?: EquipmentType
  dimensions?: string
  weight?: number
  powerConsumption?: number
  voltage?: number
  minTemperature?: number
  maxTemperature?: number
  volume?: number
  bodyMaterial?: string
  installationAddress?: string
  installationDate?: string
  nextMaintenanceDate?: string
  warrantyMonths?: number
  serviceContractNumber?: string
  energyClass?: string
  countryOfOrigin?: string
  lastMaintenanceDate?: string
  maintenanceNotes?: string
}

export interface UpdateEquipmentRequest {
  name: string
  categoryId: number
  price: number
  model?: string
  manufacturer?: string
  serialNumber?: string
  yearOfManufacture?: number
  status?: EquipmentStatus
  description?: string
  
  // Характеристики торгового оборудования
  equipmentType?: EquipmentType
  dimensions?: string
  weight?: number
  powerConsumption?: number
  voltage?: number
  minTemperature?: number
  maxTemperature?: number
  volume?: number
  bodyMaterial?: string
  installationAddress?: string
  installationDate?: string
  nextMaintenanceDate?: string
  warrantyMonths?: number
  serviceContractNumber?: string
  energyClass?: string
  countryOfOrigin?: string
  lastMaintenanceDate?: string
  maintenanceNotes?: string
}

export interface ChangeStatusRequest {
  status: EquipmentStatus
}

export const equipmentApi = {
  async getEquipment(status?: string): Promise<Equipment[]> {
    const params = status ? { status } : {}
    const response = await api.get<Equipment[]>('/equipment', { params })
    return response.data
  },

  async getEquipmentById(id: number): Promise<Equipment> {
    const response = await api.get<Equipment>(`/equipment/${id}`)
    return response.data
  },

  async createEquipment(request: CreateEquipmentRequest): Promise<Equipment> {
    const response = await api.post<Equipment>('/equipment', request)
    return response.data
  },

  async updateEquipment(id: number, request: UpdateEquipmentRequest): Promise<Equipment> {
    const response = await api.put<Equipment>(`/equipment/${id}`, request)
    return response.data
  },

  async changeStatus(id: number, status: EquipmentStatus): Promise<Equipment> {
    const response = await api.patch<Equipment>(`/equipment/${id}/status`, { status })
    return response.data
  },

  async deleteEquipment(id: number): Promise<void> {
    await api.delete(`/equipment/${id}`)
  },

  async getCategories(): Promise<Category[]> {
    const response = await api.get<Category[]>('/categories')
    return response.data
  }
}

export interface Category {
  id: number
  name: string
  description: string
}
