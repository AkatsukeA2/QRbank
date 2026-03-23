package backend_api.Qrbank.repository;


import backend_api.Qrbank.model.User;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Mono;

@Repository
public interface UserRepository extends ReactiveCrudRepository<User, Long> {

   Mono<Boolean> existsByGuardianID(Long id);
}
