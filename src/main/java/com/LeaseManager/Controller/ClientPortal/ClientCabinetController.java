package com.LeaseManager.Controller.ClientPortal;

import com.LeaseManager.Dto.Client.ClientResponse;
import com.LeaseManager.Dto.Equipment.EquipmentResponse;
import com.LeaseManager.Entity.Equipment;
import com.LeaseManager.Entity.User;
import com.LeaseManager.Security.UserDetailsImpl;
import com.LeaseManager.Service.ClientPortal.EquipmentService.EquipmentService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("api/client-portal")
public class ClientCabinetController {

    private final EquipmentService equipmentService;

    public ClientCabinetController(EquipmentService equipmentService) {
        this.equipmentService = equipmentService;
    }

    @GetMapping("/equipment")
     public ResponseEntity<List<EquipmentResponse>> getEquipment(@AuthenticationPrincipal UserDetailsImpl userDetails)
    {
        Long clientId = userDetails.getClientId();
        return ResponseEntity.ok(equipmentService.getAllEquipment(clientId));
    }
}
