package com.LeaseManager.Repository;

import com.LeaseManager.Entity.Contract;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Репозиторий для работы с договорами
 */
@Repository
public interface ContractRepository extends JpaRepository<Contract, Long> {

    /**
     * Поиск договоров по клиенту
     */
    List<Contract> findByClientId(Long clientId);

    /**
     * Поиск договоров по статусу
     */
    List<Contract> findByStatus(Contract.ContractStatus status);

    /**
     * Поиск договора по номеру
     */
    Contract findByContractNumber(String contractNumber);

    /**
     * Поиск активных договоров
     */
    @Query("SELECT c FROM Contract c WHERE c.status = :status ORDER BY c.createdDate DESC")
    List<Contract> findActiveContracts(@Param("status") Contract.ContractStatus status);

    /**
     * Поиск договоров по оборудованию
     */
    List<Contract> findByEquipmentId(Long equipmentId);

    /**
     * Поиск договоров по шаблону номера (для автогенерации)
     */
    @Query("SELECT c FROM Contract c WHERE c.contractNumber LIKE :pattern ORDER BY c.contractNumber DESC")
    List<Contract> findByContractNumberPattern(@Param("pattern") String pattern);

    /**
     * Поиск договоров по различным критериям
     */
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
