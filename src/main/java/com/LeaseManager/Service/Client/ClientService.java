package com.LeaseManager.Service.Client;

import com.LeaseManager.Dto.Client.ClientResponse;
import com.LeaseManager.Dto.Client.CreateClientRequest;
import com.LeaseManager.Dto.Client.UpdateClientRequest;

import java.util.List;

public interface ClientService {
    List<ClientResponse> getAllClients(String searchQuery);

    ClientResponse getClientById(Long clientId);

    ClientResponse createClient(CreateClientRequest request);

    ClientResponse updateClient(Long clientId, UpdateClientRequest request);

    void delete(Long clientId);
}
