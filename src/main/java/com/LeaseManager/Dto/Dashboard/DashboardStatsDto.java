package com.LeaseManager.Dto.Dashboard;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class DashboardStatsDto {
    private int activeContracts;
    private int totalClients;
    private int overduePayments;
    private int freeEquipment;
}
