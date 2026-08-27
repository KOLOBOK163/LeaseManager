package com.LeaseManager.Dto.Scoring;

import lombok.*;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ManualReviewRequest {
    private String comment;
    private String rejectionReason;
}
