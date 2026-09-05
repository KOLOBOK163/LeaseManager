package com.LeaseManager.Service.Contract;

import com.LeaseManager.Dto.Contract.ContractResponse;
import com.LeaseManager.Entity.Client;
import com.LeaseManager.Entity.Contract;
import com.LeaseManager.Entity.Equipment;
import com.LeaseManager.Repository.*;
import jakarta.persistence.EntityNotFoundException;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
public class ContractServiceTest {

    @Mock
    ContractRepository contractRepository;

    @Mock
    ClientRepository clientRepository;

    @Mock
    EquipmentRepository equipmentRepository;

    @Mock
    PaymentScheduleRepository paymentScheduleRepository;

    @InjectMocks
    ContractService contractService;

    @Test
    void returnContractById()
    {
        Client client = Client.builder().id(1L).fullName("Иванов Пётр").build();
        Equipment equipment = Equipment.builder().id(1L).name("Принтер").build();
        Contract contract = Contract.builder()
                .id(1L)
                .contractNumber("ЛД-2026-001")
                .client(client)
                .equipment(equipment)
                .totalAmount(BigDecimal.valueOf(100000))
                .status(Contract.ContractStatus.DRAFT)
                .startDate(LocalDate.now())
                .endDate(LocalDate.now().plusMonths(12))
                .paymentPeriodMonths(12)
                .build();

        when(contractRepository.findById(1L)).thenReturn(Optional.of(contract));

        ContractResponse response = contractService.getContractById(1L);

        assertEquals("ЛД-2026-001", response.getContractNumber());
        assertEquals("Иванов Пётр", response.getClientName());
    }

    @Test
    void shouldThrowWhenContractNotFound() {
        when(contractRepository.findById(999L)).thenReturn(Optional.empty());

        assertThrows(EntityNotFoundException.class, () -> contractService.getContractById(999L));
    }
}
