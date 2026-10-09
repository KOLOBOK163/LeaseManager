package com.LeaseManager.Service.ClientPortal.Equipment;

import com.LeaseManager.Dto.ClientPortal.Equipment.ClientEquipmentResponse;
import com.LeaseManager.Entity.Contract;
import com.LeaseManager.Repository.ContractRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ClientEquipmentService {

    private final ContractRepository contractRepository;

    public ClientEquipmentService(ContractRepository contractRepository) {
        this.contractRepository = contractRepository;
    }

    public List<ClientEquipmentResponse> getAll(Long clientId)
    {
        if(clientId == null)
        {
            throw new IllegalArgumentException("ClientId can't be null");
        }

        List<Contract> contracts = contractRepository.findCo

    }


}
