package backend_api.Qrbank.service;

import backend_api.Qrbank.dto.AuthLoginRequestDTO;
import backend_api.Qrbank.dto.AuthRegisterRequestDTO;
import backend_api.Qrbank.dto.AuthResponseDTO;
import backend_api.Qrbank.dto.RefreshRequestDTO;
import backend_api.Qrbank.model.AuthRefreshTokens;
import backend_api.Qrbank.model.Role;
import backend_api.Qrbank.model.RoleName;
import backend_api.Qrbank.model.User;
import backend_api.Qrbank.repository.RoleRepository;
import backend_api.Qrbank.repository.UserRepository;
import lombok.AllArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

import java.time.LocalDateTime;

@Service
@AllArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final RoleRepository roleRepository;
    private final AuthRefreshTokesService refreshTokesService;

    /* --- LOGIN --- */
    public Mono<AuthResponseDTO> login(AuthLoginRequestDTO requestDTO) {
        return userRepository.findByEmail(requestDTO.email())
                .switchIfEmpty(Mono.error(new RuntimeException("User not found")))
                .flatMap(user -> {
                    if (!passwordEncoder.matches(requestDTO.password(), user.getPassword())) {
                        return Mono.error(new RuntimeException("Invalid credentials"));
                    }
                    return roleRepository.findById(user.getRoleID())
                            .flatMap(role ->
                                    refreshTokesService.createRefreshToken(user)
                                            .map(refreshToken -> new AuthResponseDTO(
                                                    jwtService.generateToken(user, RoleName.valueOf(role.getRoleName())),
                                                    refreshToken.getToken(),
                                                    "Bearer"
                                            ))
                            );
                });
    }

    /* --- REGISTER --- */
    public Mono<AuthResponseDTO> register(AuthRegisterRequestDTO requestDTO) {
        return validateUserDoesNotExist(requestDTO)
                .then(getDefaultRole())
                .flatMap(role -> createUser(requestDTO, role))
                .flatMap(this::generateTokens);
    }

    /* --- REFRESH --- */
    public Mono<AuthResponseDTO> refresh(RefreshRequestDTO token) {
        System.out.println(">>> Token recebido no refresh: [" + token.token() + "]");
        return refreshTokesService.findByToken(token.token()).doOnNext(t -> System.out.println(">>> Token encontrado no banco: [" + t.getToken() + "]"))
                .switchIfEmpty(Mono.fromRunnable(() ->
                        System.out.println(">>> Nenhum token encontrado no banco!")
                ).then(Mono.error(new RuntimeException("Invalid refresh token"))))
                .flatMap(refreshToken -> {
                    if (refreshToken.getRevoked() || refreshToken.getExpireBy().isBefore(LocalDateTime.now())) {
                        return Mono.error(new RuntimeException("Refresh token expired"));
                    }
                    return userRepository.findById(refreshToken.getUserId());
                })
                .flatMap(user ->
                        roleRepository.findById(user.getRoleID())
                                .flatMap(role ->
                                        refreshTokesService.createRefreshToken(user)
                                                .map(newRefresh -> new AuthResponseDTO(
                                                        jwtService.generateToken(user, RoleName.valueOf(role.getRoleName())),
                                                        newRefresh.getToken(),
                                                        "Bearer"
                                                ))
                                )
                );
    }

    /* --- LOGOUT --- */
    public Mono<Void> logout(RefreshRequestDTO requestDTO) {
        return refreshTokesService.deleteByUserToken(requestDTO);
    }

    /* --- AUXILIARES --- */
    private Mono<Void> validateUserDoesNotExist(AuthRegisterRequestDTO requestDTO) {
        return userRepository.findByEmail(requestDTO.email())
                .flatMap(user -> Mono.error(new RuntimeException("Email already exists")))
                .switchIfEmpty(
                        userRepository.findByPhoneNumber(requestDTO.phoneNumber())
                                .flatMap(user -> Mono.error(new RuntimeException("Phone already exists")))
                )
                .then();
    }

    private Mono<Role> getDefaultRole() {

        return roleRepository.findByRoleName("USER")
                .switchIfEmpty(Mono.error(new RuntimeException("Default role not found")));
    }

    private Mono<User> createUser(AuthRegisterRequestDTO requestDTO, Role role) {
        User user = new User();
        user.setEmail(requestDTO.email());
        user.setPassword(passwordEncoder.encode(requestDTO.password()));
        user.setCreatedAt(LocalDateTime.now());
        user.setFirstName(requestDTO.firstName());
        user.setLastName(requestDTO.lastName());
        user.setRoleID(role.getId());
        user.setPhoneNumber(requestDTO.phoneNumber());
        return userRepository.save(user);
    }

    private Mono<AuthResponseDTO> generateTokens(User user) {
        return roleRepository.findById(user.getRoleID())
                .flatMap(role ->
                        refreshTokesService.createRefreshToken(user)
                                .map(refreshToken -> new AuthResponseDTO(
                                        jwtService.generateToken(user, RoleName.valueOf(role.getRoleName())),
                                        refreshToken.getToken(),
                                        "Bearer"
                                ))
                );
    }
}