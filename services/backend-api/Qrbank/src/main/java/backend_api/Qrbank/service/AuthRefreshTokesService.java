package backend_api.Qrbank.service;

import backend_api.Qrbank.config.JwtPropertiesConfig;
import backend_api.Qrbank.dto.AuthResponseDTO;
import backend_api.Qrbank.dto.RefreshRequestDTO;
import backend_api.Qrbank.model.AuthRefreshTokens;
import backend_api.Qrbank.model.RoleName;
import backend_api.Qrbank.model.User;
import backend_api.Qrbank.repository.AuthRefreshTokensRepository;
import backend_api.Qrbank.repository.RoleRepository;
import backend_api.Qrbank.repository.UserRepository;
import lombok.AllArgsConstructor;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

import java.time.Duration;
import java.time.Instant;
import java.time.LocalDateTime;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AuthRefreshTokesService {
    private final AuthRefreshTokensRepository repository;
    private final RoleRepository roleRepository;
    private final JwtPropertiesConfig jwtPropertiesConfig;



    public Mono<AuthRefreshTokens> createRefreshToken(User user) {

        return roleRepository.findById(user.getRoleID())
                .switchIfEmpty(Mono.error(new RuntimeException("Role not found")))
                .flatMap(role -> {
                    String token = UUID.randomUUID().toString();

                    AuthRefreshTokens refreshToken = new AuthRefreshTokens();
                    refreshToken.setUserId(user.getId());
                    refreshToken.setToken(token);
                    refreshToken.setCreatedAt(LocalDateTime.now());
                    refreshToken.setExpireBy(LocalDateTime.now().plus(Duration.ofMillis(jwtPropertiesConfig.getRefresh_expiration())));
                    refreshToken.setRevoked(false);

                    return repository.deleteByUserId(user.getId())
                            .then(repository.save(refreshToken));
                });
    }

    public Mono<AuthRefreshTokens> findByToken(String token){
         return repository.findByToken(token);
    }
    public Mono<AuthRefreshTokens> findByUserId(Long userId){
        return repository.findByUserId(userId)
                .switchIfEmpty(Mono.error(new RuntimeException("refresh token not found")));
    }

    public Mono<AuthRefreshTokens> verifyExpiration(AuthRefreshTokens token){
        return repository.findById(token.getId())
                .switchIfEmpty(Mono.error(new RuntimeException("token not found, cannot verify")))
                .flatMap(tokens -> {
                    if (!tokens.getRevoked() && tokens.getExpireBy().isAfter(LocalDateTime.now())){
                        tokens.setRevoked(true);
                        repository.save(tokens).then(Mono.error(new RuntimeException("Token expired")));;
                        return repository.deleteByUserId(tokens.getId());
                    }
                    return repository.findById(tokens.getId());
                }).then(Mono.just(token));
    }

    public Mono<String> deleteByUserId(Long userId){
        return repository.findByUserId(userId)
                .switchIfEmpty(Mono.error(new RuntimeException("token not found, cannot delete")))
                .flatMap(tokens -> repository.deleteById(tokens.getId())).then(Mono.just("deleted"));
    }

    public Mono<Void> deleteByUserToken(RefreshRequestDTO token){
        return repository.findByToken(token.token())
                .switchIfEmpty(Mono.error(new RuntimeException("token not found, cannot delete")))
                .flatMap(tokens -> repository.deleteById(tokens.getId()));
    }


}
