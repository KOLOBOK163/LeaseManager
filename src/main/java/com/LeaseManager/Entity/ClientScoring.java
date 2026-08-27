package com.LeaseManager.Entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

/**
 * Результат скоринга клиента
 */
@Entity
@Table(name = "client_scoring")
@Builder
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ClientScoring {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "client_id", nullable = false, foreignKey = @ForeignKey(name = "fk_scoring_client"))
    private Client client;

    @Column(name = "score", nullable = false)
    private Integer score;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private ScoringStatus status;

    @Column(name = "auto_approved")
    private Boolean autoApproved;

    @Column(name = "manual_review_required")
    private Boolean manualReviewRequired;

    @Column(name = "checked_date", nullable = false)
    @Builder.Default
    private LocalDateTime checkedDate = LocalDateTime.now();

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "reviewed_by", foreignKey = @ForeignKey(name = "fk_scoring_reviewer"))
    private User reviewedBy;

    @Column(name = "review_date")
    private LocalDateTime reviewDate;

    @Column(name = "review_comment", length = 1000)
    private String reviewComment;

    @Column(name = "rejection_reason", length = 500)
    private String rejectionReason;

    /**
     * Статусы скоринга
     */
    public enum ScoringStatus {
        PENDING,        // Ожидает проверки
        AUTO_APPROVED,  // Автоматически одобрен
        MANUAL_REVIEW,  // Требует ручной проверки
        APPROVED,       // Одобрен менеджером
        REJECTED        // Отклонён
    }
}
