package com.LeaseManager.Service.Scoring;

import com.LeaseManager.Entity.Client;
import com.LeaseManager.Entity.ClientScoring;
import com.LeaseManager.Repository.ClientScoringRepository;
import com.LeaseManager.Repository.ContractRepository;
import com.LeaseManager.Repository.PaymentScheduleRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.ArrayList;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ScoringServiceTest {

    @Mock
    private ClientScoringRepository scoringRepository;

    @Mock
    private ContractRepository contractRepository;

    @Mock
    private PaymentScheduleRepository paymentScheduleRepository;

    @InjectMocks
    private ScoringService scoringService;

    private Client testClient;

    @BeforeEach
    void setUp() {
        testClient = Client.builder()
                .id(1L)
                .fullName("Тестовый Клиент")
                .inn("7707083893")
                .clientType(Client.ClientType.LEGAL_ENTITY)
                .bankAccount("40817810099910004312")
                .build();
    }

    @Test
    void testPerformScoring_NewClient_WithAllData() {
        when(contractRepository.findByClientId(1L)).thenReturn(new ArrayList<>());
        when(scoringRepository.save(any(ClientScoring.class))).thenAnswer(i -> i.getArguments()[0]);

        ClientScoring result = scoringService.performScoring(testClient);

        assertNotNull(result);
        assertTrue(result.getScore() >= 50); // Базовый балл + бонусы
        assertEquals(ClientScoring.ScoringStatus.AUTO_APPROVED, result.getStatus());
        assertTrue(result.getAutoApproved());
        verify(scoringRepository, times(1)).save(any(ClientScoring.class));
    }

    @Test
    void testPerformScoring_NewClient_MinimalData() {
        Client minimalClient = Client.builder()
                .id(2L)
                .fullName("Минимальный Клиент")
                .clientType(Client.ClientType.INDIVIDUAL)
                .build();

        when(contractRepository.findByClientId(2L)).thenReturn(new ArrayList<>());
        when(scoringRepository.save(any(ClientScoring.class))).thenAnswer(i -> i.getArguments()[0]);

        ClientScoring result = scoringService.performScoring(minimalClient);

        assertNotNull(result);
        assertEquals(50, result.getScore()); // Только базовый балл
        assertEquals(ClientScoring.ScoringStatus.MANUAL_REVIEW, result.getStatus());
        assertTrue(result.getManualReviewRequired());
    }

    @Test
    void testApproveManually() {
        ClientScoring scoring = ClientScoring.builder()
                .id(1L)
                .client(testClient)
                .score(60)
                .status(ClientScoring.ScoringStatus.MANUAL_REVIEW)
                .build();

        when(scoringRepository.findById(1L)).thenReturn(java.util.Optional.of(scoring));
        when(scoringRepository.save(any(ClientScoring.class))).thenAnswer(i -> i.getArguments()[0]);

        ClientScoring result = scoringService.approveManually(1L, 1L, "Одобрено менеджером");

        assertEquals(ClientScoring.ScoringStatus.APPROVED, result.getStatus());
        assertEquals("Одобрено менеджером", result.getReviewComment());
        assertNotNull(result.getReviewDate());
    }

    @Test
    void testRejectManually() {
        ClientScoring scoring = ClientScoring.builder()
                .id(1L)
                .client(testClient)
                .score(60)
                .status(ClientScoring.ScoringStatus.MANUAL_REVIEW)
                .build();

        when(scoringRepository.findById(1L)).thenReturn(java.util.Optional.of(scoring));
        when(scoringRepository.save(any(ClientScoring.class))).thenAnswer(i -> i.getArguments()[0]);

        ClientScoring result = scoringService.rejectManually(1L, 1L, "Недостаточно документов");

        assertEquals(ClientScoring.ScoringStatus.REJECTED, result.getStatus());
        assertEquals("Недостаточно документов", result.getRejectionReason());
        assertNotNull(result.getReviewDate());
    }
}
