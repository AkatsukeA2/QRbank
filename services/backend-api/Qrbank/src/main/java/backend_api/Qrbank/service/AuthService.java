package backend_api.Qrbank.service;

import backend_api.Qrbank.dto.AuthLoginRequestDTO;
import backend_api.Qrbank.dto.AuthRegisterRequestDTO;
import backend_api.Qrbank.dto.AuthResponseDTO;
import backend_api.Qrbank.dto.RefreshRequestDTO;
import backend_api.Qrbank.mapper.AuthMapper;
import backend_api.Qrbank.model.AuthRefreshTokens;
import backend_api.Qrbank.model.Role;
import backend_api.Qrbank.model.User;
import backend_api.Qrbank.repository.RoleRepository;
import backend_api.Qrbank.repository.UserRepository;
import io.asyncer.r2dbc.mysql.message.client.AuthResponse;
import lombok.AllArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Service
@AllArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final RoleRepository roleRepository;
    private final AuthRefreshTokesService refreshTokesService;



    /* validate login*/

    public Mono<AuthResponseDTO> login(AuthLoginRequestDTO requestDTO){
        return userRepository.findByEmail(requestDTO.email())
                .switchIfEmpty(Mono.error(new RuntimeException("user not found")))
                .flatMap(user -> {
                    if (!passwordEncoder.matches(requestDTO.password(), user.getPassword())){
                        return Mono.error(new RuntimeException("invalid credentials"));
                    }

                    String token = String.valueOf(jwtService.generateToken(user));

                    return Mono.just(new AuthResponseDTO(token));
                });
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

    private Mono<AuthResponseDTO> generateTokenResponse(User user) {

        String token = String.valueOf(jwtService.generateToken(user));

        return Mono.just(new AuthResponseDTO(token));
    }

    private Mono<Role> getDefaultRole() {
        return roleRepository.findByRoleName("USER")
                .switchIfEmpty(Mono.error(new RuntimeException("Default role not found")));
    }

    private Mono<Void> validateUserDoesNotExist(AuthRegisterRequestDTO requestDTO) {

        return userRepository.findByEmail(requestDTO.email())
                .flatMap(user -> Mono.error(new RuntimeException("Email already exists")))
                .switchIfEmpty(
                        userRepository.findByPhoneNumber(requestDTO.phoneNumber())
                                .flatMap(user -> Mono.error(new RuntimeException("Phone already exists")))
                )
                .then();
    }


    public Mono<AuthResponseDTO> register(AuthRegisterRequestDTO requestDTO){
       return validateUserDoesNotExist(requestDTO)
               .then(getDefaultRole())
               .flatMap(role -> createUser(requestDTO,role))
               .flatMap(this::generateTokens);
    }
    private Mono<AuthResponseDTO> generateTokens(User user) {

        String accessToken = String.valueOf(jwtService.generateToken(user));
        String refreshToken = String.valueOf(refreshTokesService.createRefreshToken(user));

        return refreshTokesService.createRefreshToken(user)
                .thenReturn(
                        new AuthResponseDTO(
                                accessToken,
                                refreshToken
                        )
                );
    }
    public Mono<AuthResponseDTO> refresh(AuthRefreshTokens tokens) {

        return refreshTokesService.findByToken(tokens.getToken())
                .switchIfEmpty(Mono.error(new RuntimeException("Invalid refresh token")))
                .flatMap(refreshToken -> {

                    if (!refreshToken.getRevoked()) {
                        return Mono.error(new RuntimeException("Refresh token expired"));
                    }

                    return userRepository.findById(refreshToken.getUserID());
                })
                .flatMap(user -> {

                    String newAccessToken = String.valueOf(jwtService.generateToken(user));

                    return Mono.just(
                            new AuthResponseDTO(
                                    newAccessToken,
                                    tokens.getToken()
                            )
                    );
                });
    }

    Mono<Void> logout(RefreshRequestDTO requestDTO){
        return refreshTokesService.deleteByUserToken(requestDTO);
    }




}
