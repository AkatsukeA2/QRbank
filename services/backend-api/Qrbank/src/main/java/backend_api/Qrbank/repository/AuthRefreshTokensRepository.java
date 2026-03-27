package backend_api.Qrbank.repository;

import backend_api.Qrbank.model.AuthRefreshTokens;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Mono;

public interface AuthRefreshTokensRepository extends ReactiveCrudRepository <AuthRefreshTokens, Long> {
    Mono<AuthRefreshTokens> findByToken(String token);
    Mono<Void> deleteByUserID(Long id);

    Mono<Void> findByUserId(Long userId);

    Mono<AuthRefreshTokens> findByUserId(Long userId);
}
