import api from '../api/axios'

export type UserRole = 'ADMIN' | 'MANAGER'

export interface User {
  id: number
  username: string
  role: UserRole
  fullName: string
  email: string
  active: boolean
}

export interface CreateUserRequest {
  username: string
  password: string
  role: UserRole
  fullName: string
  email: string
  active?: boolean
}

export interface UpdateUserRequest {
  username?: string
  password?: string
  role?: UserRole
  fullName?: string
  email?: string
  active?: boolean
}

export const usersApi = {
  async getAllUsers(): Promise<User[]> {
    const response = await api.get<User[]>('/admin/users')
    return response.data
  },

  async getUserById(id: number): Promise<User> {
    const response = await api.get<User>(`/admin/users/${id}`)
    return response.data
  },

  async createUser(request: CreateUserRequest): Promise<User> {
    const response = await api.post<User>('/admin/users', request)
    return response.data
  },

  async updateUser(id: number, request: UpdateUserRequest): Promise<User> {
    const response = await api.put<User>(`/admin/users/${id}`, request)
    return response.data
  },

  async deleteUser(id: number): Promise<void> {
    await api.delete(`/admin/users/${id}`)
  },

  async changePassword(id: number, newPassword: string): Promise<{ message: string }> {
    const response = await api.post<{ message: string }>(`/admin/users/${id}/change-password`, {
      newPassword
    })
    return response.data
  },

  async toggleActive(id: number, active: boolean): Promise<User> {
    const response = await api.put<User>(`/admin/users/${id}`, { active })
    return response.data
  }
}
