export interface Incident {
  id: number;
  equipmentId: number;
  equipmentName: string;
  contractId: number | null;
  contractNumber: string | null;
  incidentType: IncidentType;
  incidentDate: string;
  description: string;
  responsibleParty: ResponsibleParty;
  estimatedCost: number | null;
  actualCost: number | null;
  status: IncidentStatus;
  resolutionNotes: string | null;
  resolvedDate: string | null;
  policeReportNumber: string | null;
  insuranceClaimNumber: string | null;
  compensationAmount: number | null;
  reportedByUsername: string | null;
  resolvedByUsername: string | null;
  requiresCompensation: boolean;
  critical: boolean;
}

export enum IncidentType {
  BREAKDOWN = 'BREAKDOWN',
  DAMAGE = 'DAMAGE',
  THEFT = 'THEFT',
  FORCE_MAJEURE = 'FORCE_MAJEURE',
  LOSS = 'LOSS'
}

export enum ResponsibleParty {
  LESSOR = 'LESSOR',
  LESSEE = 'LESSEE',
  INSURANCE = 'INSURANCE',
  FORCE_MAJEURE = 'FORCE_MAJEURE',
  UNDER_INVESTIGATION = 'UNDER_INVESTIGATION'
}

export enum IncidentStatus {
  REPORTED = 'REPORTED',
  UNDER_INVESTIGATION = 'UNDER_INVESTIGATION',
  REPAIR_SCHEDULED = 'REPAIR_SCHEDULED',
  IN_REPAIR = 'IN_REPAIR',
  RESOLVED = 'RESOLVED',
  CLOSED = 'CLOSED',
  CANCELLED = 'CANCELLED'
}

export interface CreateIncidentRequest {
  equipmentId: number;
  contractId?: number;
  incidentType: IncidentType;
  incidentDate?: string;
  description: string;
  responsibleParty?: ResponsibleParty;
  estimatedCost?: number;
  policeReportNumber?: string;
  insuranceClaimNumber?: string;
}

export interface UpdateIncidentRequest {
  description?: string;
  responsibleParty?: ResponsibleParty;
  estimatedCost?: number;
  actualCost?: number;
  status?: IncidentStatus;
  resolutionNotes?: string;
  policeReportNumber?: string;
  insuranceClaimNumber?: string;
  compensationAmount?: number;
}
