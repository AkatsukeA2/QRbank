package backend_api.Qrbank.repository;

import backend_api.Qrbank.model.entities.Account;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Mono;
@Repository
public interface AccountRepository extends ReactiveCrudRepository<Account, Long> {

    @Query("""
        UPDATE accounts
        SET balance = balance - :amount
        WHERE id = :acountId
        AND balance >= : amount
    """)
    Mono<Integer>  debitIfEnough(Long accountId, Double amount);

    @Query("""
        UPDATE accounts
        SET balance = balance + :amount
        WHERE id = :acountId
    """)
    Mono<Integer>  credit(Long accountId, Double amount);

    @Query("""
        UPDATE accounts
        SET balance = balance - :amount
        WHERE id = :acountId
    """)
    Mono<Integer>  withdraw(Long accountId, Double amount);


    Mono<Account>  findByUserId(Long userID);
}
