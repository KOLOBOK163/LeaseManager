package com.LeaseManager.Service.Scoring;

import com.LeaseManager.Entity.Client;
import com.LeaseManager.Entity.ClientScoring;
import com.LeaseManager.Entity.Contract;
import com.LeaseManager.Entity.PaymentSchedule;
import com.LeaseManager.Entity.PaymentScheduleStatus;
import com.LeaseManager.Repository.ClientScoringRepository;
import com.LeaseManager.Repository.ContractRepository;
import com.LeaseManager.Repository.PaymentScheduleRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Сервис скоринга клиентов
 * Оценивает кредитоспособность на основе истории платежей и других факторов
 */
@Service
public class ScoringService {

    private final ClientScoringRepository scoringRepository;
    private final ContractRepository contractRepository;
    private final PaymentScheduleRepository paymentScheduleRepository;

    // Пороговые значения для скоринга
    private static final int AUTO_APPROVE_THRESHOLD = 70;
    private static final int MANUAL_REVIEW_THRESHOLD = 50;

    public ScoringService(ClientScoringRepository scoringRepository,
                         ContractRepository contractRepository,
                         PaymentScheduleRepository paymentScheduleRepository) {
        this.scoringRepository = scoringRepository;
        this.contractRepository = contractRepository;
        this.paymentScheduleRepository = paymentScheduleRepository;
    }

    /**
     * Выполнить скоринг клиента
     */
    @Transactional
    public ClientScoring performScoring(Client client) {
        int score = calculateScore(client);

        ClientScoring.ScoringStatus status;
        boolean autoApproved = false;
        boolean manualReviewRequired = false;

        if (score >= AUTO_APPROVE_THRESHOLD) {
            status = ClientScoring.ScoringStatus.AUTO_APPROVED;
            autoApproved = true;
        } else if (score >= MANUAL_REVIEW_THRESHOLD) {
            status = ClientScoring.ScoringStatus.MANUAL_REVIEW;
            manualReviewRequired = true;
        } else {
            status = ClientScoring.ScoringStatus.REJECTED;
        }

        ClientScoring scoring = ClientScoring.builder()
                .client(client)
                .score(score)
                .status(status)
                .autoApproved(autoApproved)
                .manualReviewRequired(manualReviewRequired)
                .checkedDate(LocalDateTime.now())
                .build();

        if (status == ClientScoring.ScoringStatus.REJECTED) {
            scoring.setRejectionReason("Недостаточный скоринговый балл: " + score + " (минимум: " + MANUAL_REVIEW_THRESHOLD + ")");
        }

        return scoringRepository.save(scoring);
    }

    /**
     * Расчёт скорингового балла (0-100)
     */
    private int calculateScore(Client client) {
        int score = 50; // Базовый балл для новых клиентов

        // 1. Проверка наличия ИНН (+10 баллов)
        if (client.getInn() != null && !client.getInn().isEmpty()) {
            score += 10;
        }

        // 2. Проверка типа клиента (юрлица надёжнее)
        if (client.getClientType() == Client.ClientType.LEGAL_ENTITY) {
            score += 10;
        }

        // 3. Проверка наличия банковских реквизитов (+5 баллов)
        if (client.getBankAccount() != null && !client.getBankAccount().isEmpty()) {
            score += 5;
        }

        // 4. Анализ истории договоров
        List<Contract> contracts = contractRepository.findByClientId(client.getId());
        if (!contracts.isEmpty()) {
            score += analyzeContractHistory(contracts);
        }

        // Ограничиваем диапазон 0-100
        return Math.max(0, Math.min(100, score));
    }

    /**
     * Анализ истории договоров клиента
     */
    private int analyzeContractHistory(List<Contract> contracts) {
        int historyScore = 0;

        // Количество завершённых договоров (+5 баллов за каждый, максимум 15)
        long closedContracts = contracts.stream()
                .filter(c -> c.getStatus() == Contract.ContractStatus.CLOSED)
                .count();
        historyScore += Math.min(15, closedContracts * 5);

        // Проверка просрочек
        int overdueCount = 0;
        int totalPayments = 0;

        for (Contract contract : contracts) {
            List<PaymentSchedule> schedules = paymentScheduleRepository.findByContractId(contract.getId());
            totalPayments += schedules.size();

            long overdue = schedules.stream()
                    .filter(s -> s.getStatus() == PaymentScheduleStatus.OVERDUE)
                    .count();
            overdueCount += overdue;
        }

        // Штраф за просрочки (-5 баллов за каждую просрочку, максимум -20)
        if (overdueCount > 0) {
            historyScore -= Math.min(20, overdueCount * 5);
        }

        // Бонус за отсутствие просрочек при наличии платежей (+10 баллов)
        if (totalPayments > 0 && overdueCount == 0) {
            historyScore += 10;
        }

        return historyScore;
    }

    /**
     * Получить последний скоринг клиента
     */
    @Transactional(readOnly = true)
    public ClientScoring getLatestScoring(Long clientId) {
        return scoringRepository.findFirstByClientIdOrderByCheckedDateDesc(clientId)
                .orElse(null);
    }

    /**
     * Получить все скоринги клиента
     */
    @Transactional(readOnly = true)
    public List<ClientScoring> getClientScoringHistory(Long clientId) {
        return scoringRepository.findByClientId(clientId);
    }

    /**
     * Ручное одобрение менеджером
     */
    @Transactional
    public ClientScoring approveManually(Long scoringId, Long managerId, String comment) {
        ClientScoring scoring = scoringRepository.findById(scoringId)
                .orElseThrow(() -> new IllegalArgumentException("Скоринг не найден"));

        scoring.setStatus(ClientScoring.ScoringStatus.APPROVED);
        scoring.setReviewDate(LocalDateTime.now());
        scoring.setReviewComment(comment);
        // Здесь можно добавить связь с User если нужно
        // scoring.setReviewedBy(userRepository.findById(managerId).orElse(null));

        return scoringRepository.save(scoring);
    }

    /**
     * Ручное отклонение менеджером
     */
    @Transactional
    public ClientScoring rejectManually(Long scoringId, Long managerId, String reason) {
        ClientScoring scoring = scoringRepository.findById(scoringId)
                .orElseThrow(() -> new IllegalArgumentException("Скоринг не найден"));

        scoring.setStatus(ClientScoring.ScoringStatus.REJECTED);
        scoring.setReviewDate(LocalDateTime.now());
        scoring.setRejectionReason(reason);

        return scoringRepository.save(scoring);
    }

    /**
     * Получить список скорингов, требующих ручной проверки
     */
    @Transactional(readOnly = true)
    public List<ClientScoring> getPendingManualReviews() {
        return scoringRepository.findByStatus(ClientScoring.ScoringStatus.MANUAL_REVIEW);
    }
}
