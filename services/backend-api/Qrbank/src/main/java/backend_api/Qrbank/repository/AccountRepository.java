package backend_api.Qrbank.repository;

import backend_api.Qrbank.model.Account;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Mono;
@Repository
public interface AccountRepository extends ReactiveCrudRepository<Account, Long> {
    Mono<Account>  findByUserId(Long userID);
}
