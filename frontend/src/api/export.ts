import api from './axios'

export const exportApi = {
  /**
   * Экспорт одного договора в Excel
   */
  async exportContract(contractId: number): Promise<Blob> {
    const response = await api.get(`/export/contract/${contractId}/excel`, {
      responseType: 'blob'
    })
    return response.data
  },

  /**
   * Экспорт всех договоров в Excel
   */
  async exportAllContracts(): Promise<Blob> {
    const response = await api.get('/export/contracts/excel', {
      responseType: 'blob'
    })
    return response.data
  }
}

/**
 * Вспомогательная функция для скачивания файла
 */
export function downloadFile(blob: Blob, filename: string) {
  const url = window.URL.createObjectURL(blob)
  const link = document.createElement('a')
  link.href = url
  link.download = filename
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
  window.URL.revokeObjectURL(url)
}
