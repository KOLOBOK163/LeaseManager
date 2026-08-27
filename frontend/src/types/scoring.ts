import api from '../api/axios'

export interface Scoring {
  id: number
  clientId: number
  clientName: string
  score: number
  status: 'PENDING' | 'AUTO_APPROVED' | 'MANUAL_REVIEW' | 'APPROVED' | 'REJECTED'
  autoApproved: boolean
  manualReviewRequired: boolean
  checkedDate: string
  reviewedBy: number | null
  reviewDate: string | null
  reviewComment: string | null
  rejectionReason: string | null
}

export interface ManualReviewRequest {
  comment?: string
  rejectionReason?: string
}

export const scoringApi = {
  async performScoring(clientId: number): Promise<Scoring> {
    const response = await api.post<Scoring>(`/scoring/check/${clientId}`)
    return response.data
  },

  async getLatestScoring(clientId: number): Promise<Scoring> {
    const response = await api.get<Scoring>(`/scoring/client/${clientId}/latest`)
    return response.data
  },

  async getScoringHistory(clientId: number): Promise<Scoring[]> {
    const response = await api.get<Scoring[]>(`/scoring/client/${clientId}/history`)
    return response.data
  },

  async getPendingReviews(): Promise<Scoring[]> {
    const response = await api.get<Scoring[]>('/scoring/pending-reviews')
    return response.data
  },

  async approve(scoringId: number, comment: string): Promise<Scoring> {
    const response = await api.post<Scoring>(`/scoring/${scoringId}/approve`, { comment })
    return response.data
  },

  async reject(scoringId: number, rejectionReason: string): Promise<Scoring> {
    const response = await api.post<Scoring>(`/scoring/${scoringId}/reject`, { rejectionReason })
    return response.data
  }
}
