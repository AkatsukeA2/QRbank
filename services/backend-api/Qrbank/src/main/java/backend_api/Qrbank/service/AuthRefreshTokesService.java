package backend_api.Qrbank.service;

import backend_api.Qrbank.config.JwtPropertiesConfig;
import backend_api.Qrbank.dto.AuthResponseDTO;
import backend_api.Qrbank.dto.RefreshRequestDTO;
import backend_api.Qrbank.model.AuthRefreshTokens;
import backend_api.Qrbank.model.User;
import backend_api.Qrbank.repository.AuthRefreshTokensRepository;
import backend_api.Qrbank.repository.UserRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

import java.time.Duration;
import java.time.Instant;
import java.time.LocalDateTime;

@Service
@AllArgsConstructor
public class AuthRefreshTokesService {
    private AuthRefreshTokensRepository repository;
    private UserRepository userRepository;
    private JwtService jwtService;
    private JwtPropertiesConfig jwtPropertiesConfig;
    private Duration tokenDuration = Duration.ofDays(jwtPropertiesConfig.getExpiration());


    public Mono<AuthRefreshTokens> createRefreshToken(User user){

        AuthRefreshTokens refreshTokens = new AuthRefreshTokens();
        refreshTokens.setUserID(user.getId());
        refreshTokens.setToken(String.valueOf(jwtService.generateToken(user)));
        refreshTokens.setCreatedAt(LocalDateTime.now());
        refreshTokens.setExpireBy(LocalDateTime.from(Instant.now().plus(tokenDuration)));
        refreshTokens.setRevoked(false);

        return repository.deleteByUserID(user.getId())
                .then(repository.save(refreshTokens));
    }

    public Mono<AuthRefreshTokens> findByToken(String token){
         return repository.findByToken(token)
                 .switchIfEmpty(Mono.error(new RuntimeException("refresh token not found")));
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
                        repository.save(tokens);
                        return repository.deleteByUserID(tokens.getId());
                    }
                    return repository.findById(tokens.getId());
                }).then(Mono.just(token));
    }

    public Mono<Void> deleteByUserId(Long userId){
        return repository.findByUserId(userId)
                .switchIfEmpty(Mono.error(new RuntimeException("token not found, cannot delete")))
                .flatMap(tokens -> repository.deleteById(userId));
    }

    public Mono<Void> deleteByUserToken(RefreshRequestDTO token){
        return repository.findByToken(token.RefreshToken())
                .switchIfEmpty(Mono.error(new RuntimeException("token not found, cannot delete")))
                .flatMap(tokens -> repository.deleteById(tokens.getId()));
    }


}
