package backend_api.Qrbank.repository;

import backend_api.Qrbank.model.entities.Account;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.math.BigDecimal;

@Repository
public interface AccountRepository extends ReactiveCrudRepository<Account, Long> {

    @Query("""
        UPDATE accounts
        SET balance = balance - :amount
        WHERE id = :accountId
        AND balance >= :amount
    """)
    Mono<Integer>  debitIfEnough(Long accountId, BigDecimal amount);

    @Query("""
        UPDATE accounts
        SET balance = balance + :amount
        WHERE id = :accountId
    """)
    Mono<Integer>  credit(Long accountId, BigDecimal amount);

    @Query("""
        UPDATE accounts
        SET balance = balance - :amount
        WHERE id = :accountId
    """)
    Mono<Integer>  withdraw(Long accountId, BigDecimal amount);


    Mono<Account>  findByUserId(Long userID);

    Mono<Account> findByIban(String iban);
}
