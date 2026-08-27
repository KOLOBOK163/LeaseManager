package com.LeaseManager.Mapper;

import com.LeaseManager.Dto.ClientDto;
import com.LeaseManager.Dto.PaymentDto;
import com.LeaseManager.Entity.Client;
import com.LeaseManager.Entity.Payment;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface EntityMapper {

    // Client
    Client toEntity(ClientDto dto);

    ClientDto toDto(Client entity);

    void updateEntityFromDto(ClientDto dto, @MappingTarget Client entity);

    // Payment
    @Mapping(target = "contract", ignore = true)
    @Mapping(target = "schedule", ignore = true)
    Payment toEntity(PaymentDto dto);

    @Mapping(target = "contractId", source = "contract.id")
    @Mapping(target = "scheduleId", source = "schedule.id")
    PaymentDto toDto(Payment entity);
}
