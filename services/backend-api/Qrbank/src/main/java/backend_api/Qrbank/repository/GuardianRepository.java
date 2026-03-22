package backend_api.Qrbank.repository;

import backend_api.Qrbank.model.Guardian;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;

public interface GuardianRepository extends ReactiveCrudRepository<Guardian, Long> {
}
