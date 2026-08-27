package com.LeaseManager.Repository;

import com.LeaseManager.Entity.ClientScoring;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ClientScoringRepository extends JpaRepository<ClientScoring, Long> {

    List<ClientScoring> findByClientId(Long clientId);

    Optional<ClientScoring> findFirstByClientIdOrderByCheckedDateDesc(Long clientId);

    List<ClientScoring> findByStatus(ClientScoring.ScoringStatus status);
}
