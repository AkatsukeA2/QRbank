package backend_api.Qrbank.repository;


import backend_api.Qrbank.dto.AuthResponseDTO;
import backend_api.Qrbank.model.User;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Mono;

@Repository
public interface UserRepository extends ReactiveCrudRepository<User, Long> {

   Mono<Boolean> existsByGuardianID(Long id);

    Mono<User> findByEmail(String email);

    Mono<User> findByPhoneNumber(String phoneNumber);
}
