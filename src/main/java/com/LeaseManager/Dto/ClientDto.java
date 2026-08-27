package com.LeaseManager.Dto;

import com.LeaseManager.Entity.Client;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
public class ClientDto {
    private Long id;

    private String fullName;

    private String phoneNumber;

    private String email;

    private String companyName;

    private String inn;

    private String kpp;

    private String legalAddress;

    private Client.ClientType clientType;
}
