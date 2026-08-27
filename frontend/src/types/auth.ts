export interface LoginRequest {
  username: string
  password: string
}

export interface RegisterRequest {
  username: string
  password: string
  email: string
  role?: string
}

export interface AuthResponse {
  accessToken: string
  tokenType: string
  userId: number
  username: string
  role: string
}
