package backend_api.Qrbank.repository;

import backend_api.Qrbank.model.entities.Kyc;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface KycRepository extends ReactiveCrudRepository<Kyc, Long> {
}
