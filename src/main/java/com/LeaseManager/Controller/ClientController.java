package com.LeaseManager.Controller;

import com.LeaseManager.Dto.Client.ClientResponse;
import com.LeaseManager.Dto.Client.CreateClientRequest;
import com.LeaseManager.Dto.Client.UpdateClientRequest;
import com.LeaseManager.Entity.AuditLog;
import com.LeaseManager.Service.Audit.AuditService;
import com.LeaseManager.Service.Client.ClientService;
import com.LeaseManager.Util.AuditUtil;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/clients")
public class ClientController {

    private final ClientService clientService;
    private final AuditService auditService;

    public ClientController(ClientService clientService, AuditService auditService) {
        this.clientService = clientService;
        this.auditService = auditService;
    }

    @GetMapping
    public ResponseEntity<List<ClientResponse>> getAllClients(
            @RequestParam(required = false) String search) {
        return ResponseEntity.ok(clientService.getAllClients(search));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ClientResponse> getClientById(@PathVariable Long id) {
        ClientResponse client = clientService.getClientById(id);
        return ResponseEntity.ok(client);
    }

    @PostMapping
    public ResponseEntity<ClientResponse> createClient(@Valid @RequestBody CreateClientRequest request) {
        ClientResponse created = clientService.createClient(request);
        auditService.log(
            AuditUtil.getCurrentUserId(),
            AuditLog.AuditAction.CREATE,
            "Client",
            created.getId(),
            "Создан клиент: " + created.getFullName(),
            AuditUtil.getClientIp()
        );
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    @PutMapping("/{id}")
    public ResponseEntity<ClientResponse> updateClient(@PathVariable Long id, @Valid @RequestBody UpdateClientRequest request) {
        ClientResponse updated = clientService.updateClient(id, request);
        auditService.log(
                AuditUtil.getCurrentUserId(),
                AuditLog.AuditAction.UPDATE,
                "Client",
                id,
                "Обновлен клиент: " + updated.getFullName(),
                AuditUtil.getClientIp()
        );
        return ResponseEntity.ok(updated);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteClient(@PathVariable Long id) {
        ClientResponse client = clientService.getClientById(id);
        clientService.delete(id);
        auditService.log(
                AuditUtil.getCurrentUserId(),
                AuditLog.AuditAction.DELETE,
                "Client",
                id,
                "Удален клиент: " + client.getFullName(),
                AuditUtil.getClientIp()
            );
        return ResponseEntity.noContent().build();
    }
}
