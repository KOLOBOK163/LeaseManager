package com.LeaseManager.Dto.Scoring;

import com.LeaseManager.Entity.ClientScoring;
import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ScoringResponse {
    private Long id;
    private Long clientId;
    private String clientName;
    private Integer score;
    private ClientScoring.ScoringStatus status;
    private Boolean autoApproved;
    private Boolean manualReviewRequired;
    private LocalDateTime checkedDate;
    private Long reviewedBy;
    private LocalDateTime reviewDate;
    private String reviewComment;
    private String rejectionReason;
}
