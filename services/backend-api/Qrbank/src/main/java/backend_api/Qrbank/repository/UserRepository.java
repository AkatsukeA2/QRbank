package backend_api.Qrbank.repository;


import backend_api.Qrbank.model.entities.User;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.Locale;

@Repository
public interface UserRepository extends ReactiveCrudRepository<User, Long> {

   Mono<Boolean> existsByGuardianID(Long id);

    Mono<User> findByEmail(String email);

    Mono<User> findByPhoneNumber(String phoneNumber);

    Flux<User> findAllByGuardianId(Long guardianId);
}
