package com.LeaseManager.Controller;

import com.LeaseManager.Dto.Dashboard.DashboardStatsDto;
import com.LeaseManager.Dto.Dashboard.PaymentChartDto;
import com.LeaseManager.Dto.Dashboard.UpcomingPaymentDto;
import com.LeaseManager.Service.Dashboard.DashboardService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/dashboard")
public class DashboardController {

    private final DashboardService dashboardService;

    public DashboardController(DashboardService dashboardService) {
        this.dashboardService = dashboardService;
    }

    @GetMapping("/stats")
    public ResponseEntity<DashboardStatsDto> getStats() {
        return ResponseEntity.ok(dashboardService.getStats());
    }

    @GetMapping("/payment-chart")
    public ResponseEntity<PaymentChartDto> getPaymentChart() {
        return ResponseEntity.ok(dashboardService.getPaymentChart());
    }

    @GetMapping("/upcoming-payments")
    public ResponseEntity<List<UpcomingPaymentDto>> getUpcomingPayments() {
        return ResponseEntity.ok(dashboardService.getUpcomingPayments());
    }
}
