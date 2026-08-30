package com.LeaseManager.Controller;

import com.LeaseManager.Dto.Scoring.ManualReviewRequest;
import com.LeaseManager.Dto.Scoring.ScoringResponse;
import com.LeaseManager.Entity.Client;
import com.LeaseManager.Entity.ClientScoring;
import com.LeaseManager.Repository.ClientRepository;
import com.LeaseManager.Service.Scoring.ScoringService;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/scoring")
@CrossOrigin(origins = "*")
public class ScoringController {

    private final ScoringService scoringService;
    private final ClientRepository clientRepository;

    public ScoringController(ScoringService scoringService, ClientRepository clientRepository) {
        this.scoringService = scoringService;
        this.clientRepository = clientRepository;
    }

    @PostMapping("/check/{clientId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
    public ResponseEntity<ScoringResponse> performScoring(@PathVariable Long clientId) {
        Client client = clientRepository.findById(clientId)
                .orElseThrow(() -> new EntityNotFoundException("Клиент не найден"));

        ClientScoring scoring = scoringService.performScoring(client);
        return ResponseEntity.ok(toResponse(scoring));
    }

    @GetMapping("/client/{clientId}/latest")
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
    public ResponseEntity<ScoringResponse> getLatestScoring(@PathVariable Long clientId) {
        ClientScoring scoring = scoringService.getLatestScoring(clientId);
        if (scoring == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(toResponse(scoring));
    }

    @GetMapping("/client/{clientId}/history")
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
    public ResponseEntity<List<ScoringResponse>> getScoringHistory(@PathVariable Long clientId) {
        List<ClientScoring> scorings = scoringService.getClientScoringHistory(clientId);
        List<ScoringResponse> responses = scorings.stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
        return ResponseEntity.ok(responses);
    }

    @GetMapping("/pending-reviews")
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
    public ResponseEntity<List<ScoringResponse>> getPendingReviews() {
        List<ClientScoring> scorings = scoringService.getPendingManualReviews();
        List<ScoringResponse> responses = scorings.stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
        return ResponseEntity.ok(responses);
    }

    @PostMapping("/{scoringId}/approve")
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
    public ResponseEntity<ScoringResponse> approveManually(
            @PathVariable Long scoringId,
            @RequestBody ManualReviewRequest request) {
        // TODO: получить ID текущего пользователя из SecurityContext
        Long managerId = 1L;
        ClientScoring scoring = scoringService.approveManually(scoringId, managerId, request.getComment());
        return ResponseEntity.ok(toResponse(scoring));
    }

    @PostMapping("/{scoringId}/reject")
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
    public ResponseEntity<ScoringResponse> rejectManually(
            @PathVariable Long scoringId,
            @RequestBody ManualReviewRequest request) {
        // TODO: получить ID текущего пользователя из SecurityContext
        Long managerId = 1L;
        ClientScoring scoring = scoringService.rejectManually(scoringId, managerId, request.getRejectionReason());
        return ResponseEntity.ok(toResponse(scoring));
    }

    private ScoringResponse toResponse(ClientScoring scoring) {
        String clientName = scoring.getClient().getFullName();
        if (clientName == null || clientName.isEmpty()) {
            clientName = scoring.getClient().getCompanyName();
        }

        return ScoringResponse.builder()
                .id(scoring.getId())
                .clientId(scoring.getClient().getId())
                .clientName(clientName)
                .score(scoring.getScore())
                .status(scoring.getStatus())
                .autoApproved(scoring.getAutoApproved())
                .manualReviewRequired(scoring.getManualReviewRequired())
                .checkedDate(scoring.getCheckedDate())
                .reviewedBy(scoring.getReviewedBy() != null ? scoring.getReviewedBy().getId() : null)
                .reviewDate(scoring.getReviewDate())
                .reviewComment(scoring.getReviewComment())
                .rejectionReason(scoring.getRejectionReason())
                .build();
    }
}
