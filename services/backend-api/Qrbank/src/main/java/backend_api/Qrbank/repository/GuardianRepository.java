package backend_api.Qrbank.repository;

import backend_api.Qrbank.model.Guardian;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Mono;

@Repository
public interface GuardianRepository extends ReactiveCrudRepository<Guardian, Long> {
    Mono<Boolean> existsByEmail(String email);

    Mono<Guardian> findByEmail(String email);
}
