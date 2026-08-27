import api from '../api/axios'

export interface AuditLog {
  id: number
  userId: number | null
  username: string
  action: 'CREATE' | 'UPDATE' | 'DELETE' | 'LOGIN' | 'LOGOUT' | 'STATUS_CHANGE' | 'APPROVE' | 'REJECT' | 'EXPORT' | 'VIEW'
  entityType: string | null
  entityId: number | null
  description: string | null
  oldValue: string | null
  newValue: string | null
  ipAddress: string | null
  timestamp: string
}

export interface AuditLogResponse {
  logs: AuditLog[]
  currentPage: number
  totalItems: number
  totalPages: number
}

export const auditApi = {
  async getLogs(page: number = 0, size: number = 50): Promise<AuditLogResponse> {
    const response = await api.get<AuditLogResponse>('/audit', {
      params: { page, size }
    })
    return response.data
  },

  async getLogsWithFilters(
    filters: {
      userId?: number
      action?: string
      entityType?: string
      startDate?: string
      endDate?: string
    },
    page: number = 0,
    size: number = 50
  ): Promise<AuditLogResponse> {
    const response = await api.get<AuditLogResponse>('/audit/filter', {
      params: { ...filters, page, size }
    })
    return response.data
  },

  async getLogsByUser(userId: number): Promise<AuditLog[]> {
    const response = await api.get<AuditLog[]>(`/audit/user/${userId}`)
    return response.data
  },

  async getLogsByEntity(entityType: string, entityId: number): Promise<AuditLog[]> {
    const response = await api.get<AuditLog[]>(`/audit/entity/${entityType}/${entityId}`)
    return response.data
  }
}
