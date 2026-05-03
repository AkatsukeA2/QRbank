package backend_api.Qrbank.repository;

import backend_api.Qrbank.model.entities.Ledger;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Repository
public interface LedgerRepository extends ReactiveCrudRepository<Ledger, Long> {

    @Query("""
    SELECT *
    FROM ledger
    WHERE account_id = :accountId
    ORDER BY created_at DESC, id DESC
    LIMIT 1
""")
    Mono<Ledger> findFirstByAccountIdOrderByCreatedAtDesc(Long accountId);
    @Query("""
    SELECT * FROM ledger
    WHERE account_id = :accountId
    ORDER BY created_at DESC
""")
    Flux<Ledger> findStatement(Long accountId);
}
