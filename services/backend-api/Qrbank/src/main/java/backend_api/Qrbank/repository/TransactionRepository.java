package backend_api.Qrbank.repository;

import backend_api.Qrbank.model.entities.Transaction;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;

@Repository
public interface TransactionRepository extends ReactiveCrudRepository<Transaction, Long> {

    Flux<Transaction> findAllBySenderAccountId(Long id);
}
