export interface Insurance {
  insurancePolicyNumber: string;
  insuranceCompany: string;
  insurancePremiumAnnual: number;
  insurancePremiumMonthly: number;
  insuranceStartDate: string;
  insuranceExpiryDate: string;
  insuranceCoverageAmount: number;
  insuranceType: string;
}

export interface InsuranceRequest {
  insurancePolicyNumber: string;
  insuranceCompany: string;
  insurancePremiumAnnual: number;
  insurancePremiumMonthly: number;
  insuranceStartDate: string;
  insuranceExpiryDate: string;
  insuranceCoverageAmount: number;
  insuranceType: string;
}
