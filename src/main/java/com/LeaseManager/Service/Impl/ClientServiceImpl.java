package com.LeaseManager.Service.Impl;

import com.LeaseManager.Dto.Client.ClientResponse;
import com.LeaseManager.Dto.Client.CreateClientRequest;
import com.LeaseManager.Dto.Client.UpdateClientRequest;
import com.LeaseManager.Entity.Client;
import com.LeaseManager.Entity.Contract;
import com.LeaseManager.Mapper.EntityMapper;
import com.LeaseManager.Repository.ClientRepository;
import com.LeaseManager.Repository.ContractRepository;
import com.LeaseManager.Service.ClientService;
import com.LeaseManager.Service.Scoring.ScoringService;
import com.LeaseManager.Service.Validation.InnValidator;
import com.LeaseManager.Service.Validation.BankAccountValidator;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class ClientServiceImpl implements ClientService {

    private final ClientRepository clientRepository;
    private final EntityMapper entityMapper;
    private final ContractRepository contractRepository;
    private final InnValidator innValidator;
    private final BankAccountValidator bankAccountValidator;
    private final ScoringService scoringService;

    public ClientServiceImpl(ClientRepository clientRepository,
                            EntityMapper entityMapper,
                            ContractRepository contractRepository,
                            InnValidator innValidator,
                            BankAccountValidator bankAccountValidator,
                            ScoringService scoringService) {
        this.clientRepository = clientRepository;
        this.entityMapper = entityMapper;
        this.contractRepository = contractRepository;
        this.innValidator = innValidator;
        this.bankAccountValidator = bankAccountValidator;
        this.scoringService = scoringService;
    }

    @Override
    @Transactional(readOnly = true)
    public List<ClientResponse> getAllClients(String searchQuery) {
        List<Client> clients;
        
        if (searchQuery != null && !searchQuery.isBlank()) {
            clients = clientRepository.searchClients(searchQuery.toLowerCase());
        } else {
            clients = clientRepository.findAll();
        }
        
        return clients.stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public ClientResponse getClientById(Long clientId) {
        Client client = clientRepository.findById(clientId)
                .orElseThrow(() -> new EntityNotFoundException("Клиент не найден с id: " + clientId));
        return toResponseWithContracts(client);
    }

    @Override
    @Transactional
    public ClientResponse createClient(CreateClientRequest request) {
        // Валидация ИНН
        if (request.getInn() != null && !request.getInn().isEmpty()) {
            if (!innValidator.isValid(request.getInn())) {
                throw new IllegalArgumentException(innValidator.getErrorMessage(request.getInn()));
            }
        }

        // Валидация банковских реквизитов
        if (request.getBankAccount() != null && !request.getBankAccount().isEmpty()) {
            if (request.getBik() == null || request.getBik().isEmpty()) {
                throw new IllegalArgumentException("БИК обязателен при указании расчётного счёта");
            }
            if (!bankAccountValidator.isValidBik(request.getBik())) {
                throw new IllegalArgumentException(bankAccountValidator.getBikErrorMessage(request.getBik()));
            }
            if (!bankAccountValidator.isValidAccount(request.getBankAccount(), request.getBik())) {
                throw new IllegalArgumentException(bankAccountValidator.getAccountErrorMessage(request.getBankAccount()));
            }
        }

        Client client = Client.builder()
                .fullName(request.getFullName())
                .phoneNumber(request.getPhoneNumber())
                .email(request.getEmail())
                .clientType(request.getClientType())
                .inn(request.getInn())
                // Поля для физических лиц
                .passportSeries(request.getPassportSeries())
                .passportNumber(request.getPassportNumber())
                .passportIssuedBy(request.getPassportIssuedBy())
                .passportIssueDate(request.getPassportIssueDate())
                .passportDepartmentCode(request.getPassportDepartmentCode())
                .registrationAddress(request.getRegistrationAddress())
                .birthDate(request.getBirthDate())
                // Поля для юридических лиц
                .companyName(request.getCompanyName())
                .kpp(request.getKpp())
                .ogrn(request.getOgrn())
                .legalAddress(request.getLegalAddress())
                .actualAddress(request.getActualAddress())
                .contactPersonPosition(request.getContactPersonPosition())
                // Банковские реквизиты
                .bankAccount(request.getBankAccount())
                .bik(request.getBik())
                .bankName(request.getBankName())
                .createdDate(LocalDateTime.now())
                .build();

        Client savedClient = clientRepository.save(client);

        // Автоматический скоринг для нового клиента
        try {
            scoringService.performScoring(savedClient);
        } catch (Exception e) {
            // Логируем ошибку, но не прерываем создание клиента
            System.err.println("Ошибка при автоматическом скоринге клиента: " + e.getMessage());
        }

        return toResponse(savedClient);
    }

    @Override
    @Transactional
    public ClientResponse updateClient(Long clientId, UpdateClientRequest request) {
        Client client = clientRepository.findById(clientId)
                .orElseThrow(() -> new EntityNotFoundException("Клиент не найден с id: " + clientId));

        // Валидация ИНН только если он изменился
        if (request.getInn() != null && !request.getInn().isEmpty()) {
            String oldInn = client.getInn() != null ? client.getInn().trim() : "";
            String newInn = request.getInn().trim();

            if (!oldInn.equals(newInn)) {
                if (!innValidator.isValid(newInn)) {
                    throw new IllegalArgumentException(innValidator.getErrorMessage(newInn));
                }
            }
        }

        // Валидация банковских реквизитов только если они изменились
        if (request.getBankAccount() != null && !request.getBankAccount().isEmpty()) {
            String oldAccount = client.getBankAccount() != null ? client.getBankAccount().trim() : "";
            String newAccount = request.getBankAccount().trim();
            String oldBik = client.getBik() != null ? client.getBik().trim() : "";
            String newBik = request.getBik() != null ? request.getBik().trim() : "";

            if (!oldAccount.equals(newAccount) || !oldBik.equals(newBik)) {
                if (request.getBik() == null || request.getBik().isEmpty()) {
                    throw new IllegalArgumentException("БИК обязателен при указании расчётного счёта");
                }
                if (!bankAccountValidator.isValidBik(newBik)) {
                    throw new IllegalArgumentException(bankAccountValidator.getBikErrorMessage(newBik));
                }
                if (!bankAccountValidator.isValidAccount(newAccount, newBik)) {
                    throw new IllegalArgumentException(bankAccountValidator.getAccountErrorMessage(newAccount));
                }
            }
        }

        client.setFullName(request.getFullName());
        client.setPhoneNumber(request.getPhoneNumber());
        client.setEmail(request.getEmail());
        client.setClientType(request.getClientType());
        client.setInn(request.getInn());

        // Поля для физических лиц
        client.setPassportSeries(request.getPassportSeries());
        client.setPassportNumber(request.getPassportNumber());
        client.setPassportIssuedBy(request.getPassportIssuedBy());
        client.setPassportIssueDate(request.getPassportIssueDate());
        client.setPassportDepartmentCode(request.getPassportDepartmentCode());
        client.setRegistrationAddress(request.getRegistrationAddress());
        client.setBirthDate(request.getBirthDate());

        // Поля для юридических лиц
        client.setCompanyName(request.getCompanyName());
        client.setKpp(request.getKpp());
        client.setOgrn(request.getOgrn());
        client.setLegalAddress(request.getLegalAddress());
        client.setActualAddress(request.getActualAddress());
        client.setContactPersonPosition(request.getContactPersonPosition());

        // Банковские реквизиты
        client.setBankAccount(request.getBankAccount());
        client.setBik(request.getBik());
        client.setBankName(request.getBankName());
        client.setUpdatedDate(LocalDateTime.now());

        Client updatedClient = clientRepository.save(client);
        return toResponse(updatedClient);
    }

    @Override
    @Transactional
    public void delete(Long clientId) {
        if (!clientRepository.existsById(clientId)) {
            throw new EntityNotFoundException("Клиент не найден с id: " + clientId);
        }

        // Проверка наличия договоров
        List<Contract> contracts = contractRepository.findByClientId(clientId);
        if (!contracts.isEmpty()) {
            throw new IllegalStateException("Невозможно удалить клиента, у которого есть договоры");
        }

        clientRepository.deleteById(clientId);
    }

    private ClientResponse toResponse(Client client) {
        return ClientResponse.builder()
                .id(client.getId())
                .fullName(client.getFullName())
                .phoneNumber(client.getPhoneNumber())
                .email(client.getEmail())
                .clientType(client.getClientType())
                .inn(client.getInn())
                // Поля для физических лиц
                .passportSeries(client.getPassportSeries())
                .passportNumber(client.getPassportNumber())
                .passportIssuedBy(client.getPassportIssuedBy())
                .passportIssueDate(client.getPassportIssueDate())
                .passportDepartmentCode(client.getPassportDepartmentCode())
                .registrationAddress(client.getRegistrationAddress())
                .birthDate(client.getBirthDate())
                // Поля для юридических лиц
                .companyName(client.getCompanyName())
                .kpp(client.getKpp())
                .ogrn(client.getOgrn())
                .legalAddress(client.getLegalAddress())
                .actualAddress(client.getActualAddress())
                .contactPersonPosition(client.getContactPersonPosition())
                // Банковские реквизиты
                .bankAccount(client.getBankAccount())
                .bik(client.getBik())
                .bankName(client.getBankName())
                .createdDate(client.getCreatedDate())
                .updatedDate(client.getUpdatedDate())
                .build();
    }

    private ClientResponse toResponseWithContracts(Client client) {
        List<Contract> contracts = contractRepository.findByClientId(client.getId());
        List<ClientResponse.ContractInfo> contractInfos = contracts.stream()
                .map(c -> ClientResponse.ContractInfo.builder()
                        .id(c.getId())
                        .contractNumber(c.getContractNumber())
                        .startDate(c.getStartDate())
                        .endDate(c.getEndDate())
                        .totalAmount(c.getTotalAmount())
                        .status(c.getStatus())
                        .build())
                .collect(Collectors.toList());

        ClientResponse response = toResponse(client);
        response.setContracts(contractInfos);
        return response;
    }
}
