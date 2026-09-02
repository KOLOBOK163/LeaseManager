package com.LeaseManager.Repository;

import com.LeaseManager.Entity.Contract;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ContractRepository extends JpaRepository<Contract, Long> {

    List<Contract> findByClientId(Long clientId);

    List<Contract> findByStatus(Contract.ContractStatus status);

    Contract findByContractNumber(String contractNumber);

    @Query("SELECT c FROM Contract c WHERE c.status = :status ORDER BY c.createdDate DESC")
    List<Contract> findActiveContracts(@Param("status") Contract.ContractStatus status);

    List<Contract> findByEquipmentId(Long equipmentId);

    @Query("SELECT c FROM Contract c WHERE c.contractNumber LIKE :pattern ORDER BY c.contractNumber DESC")
    List<Contract> findByContractNumberPattern(@Param("pattern") String pattern);

    @Query("SELECT c FROM Contract c " +
           "LEFT JOIN c.client cl " +
           "LEFT JOIN c.equipment e " +
           "WHERE LOWER(c.contractNumber) LIKE LOWER(CONCAT('%', :searchQuery, '%')) " +
           "OR LOWER(cl.fullName) LIKE LOWER(CONCAT('%', :searchQuery, '%')) " +
           "OR LOWER(cl.companyName) LIKE LOWER(CONCAT('%', :searchQuery, '%')) " +
           "OR LOWER(e.name) LIKE LOWER(CONCAT('%', :searchQuery, '%')) " +
           "ORDER BY c.createdDate DESC")
    List<Contract> searchContracts(@Param("searchQuery") String searchQuery);
}
