package backend_api.Qrbank.service;

import backend_api.Qrbank.dto.AuthRegisterRequest;
import backend_api.Qrbank.dto.AuthResponse;
import backend_api.Qrbank.model.User;
import backend_api.Qrbank.repository.UserRepository;
import lombok.AllArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

@Service
@AllArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    /* validate login
    public Mono<AuthResponse> login(AuthRegisterRequest request) {

        return userRepository.findByEmail(request.email())
                .switchIfEmpty(Mono.error(new RuntimeException("User not found")))
                .flatMap(user -> {

                    if (!passwordEncoder.matches(request.password(), user.getPassword())) {
                        return Mono.error(new RuntimeException("Invalid credentials"));
                    }

                    String token = jwtService.generateToken(
                            user.getEmail(),
                            user.getRoleName()
                    );

                    return Mono.just(new AuthResponse(token));
                });
    }

*/
}
