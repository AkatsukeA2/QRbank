package backend_api.Qrbank.repository;

import backend_api.Qrbank.model.Account;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Mono;

public interface AccountRepository extends ReactiveCrudRepository<Account, Long> {
    Mono<Account>  findByUserID(Long userID);
}
