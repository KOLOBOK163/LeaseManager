package com.LeaseManager.Service;

import com.LeaseManager.Dto.Client.ClientResponse;
import com.LeaseManager.Dto.Client.CreateClientRequest;
import com.LeaseManager.Dto.Client.UpdateClientRequest;
import com.LeaseManager.Entity.Client;

import java.util.List;

public interface ClientService {
    List<ClientResponse> getAllClients(String searchQuery);

    ClientResponse getClientById(Long clientId);

    ClientResponse createClient(CreateClientRequest request);

    ClientResponse updateClient(Long clientId, UpdateClientRequest request);

    void delete(Long clientId);
}
