package backend_api.Qrbank.repository;

import backend_api.Qrbank.model.entities.Kyc;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Repository
public interface KycRepository extends ReactiveCrudRepository<Kyc, Long> {
    Mono<Kyc> findByAccountId(Long accountId);
}
