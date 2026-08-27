package com.LeaseManager.Dto.Contract;

import com.LeaseManager.Entity.Contract;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class ChangeContractStatusRequest {
    private Contract.ContractStatus status;
}
