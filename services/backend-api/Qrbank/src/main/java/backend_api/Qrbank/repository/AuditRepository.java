package backend_api.Qrbank.repository;

import backend_api.Qrbank.dto.AuditResponseDTO;
import backend_api.Qrbank.model.entities.Audit;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;

@Repository
public interface AuditRepository extends ReactiveCrudRepository<Audit, Long> {
    Flux<AuditResponseDTO> findByUserId(Long userId);
}
