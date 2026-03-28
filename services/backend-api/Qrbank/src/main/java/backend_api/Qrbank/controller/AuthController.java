package backend_api.Qrbank.controller;

import backend_api.Qrbank.dto.AuthLoginRequestDTO;
import backend_api.Qrbank.dto.AuthRegisterRequestDTO;
import backend_api.Qrbank.dto.AuthResponseDTO;
import backend_api.Qrbank.dto.RefreshRequestDTO;
import backend_api.Qrbank.model.AuthRefreshTokens;
import backend_api.Qrbank.service.AuthService;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("/api/auth")
@AllArgsConstructor
public class AuthController {

    private final AuthService authService;


    @PostMapping("/register")
    @ResponseStatus(HttpStatus.CREATED)
    public Mono<AuthResponseDTO> register(@RequestBody AuthRegisterRequestDTO requestDTO) {
        return authService.register(requestDTO);
    }


    @PostMapping("/login")
    public Mono<AuthResponseDTO> login(@RequestBody AuthLoginRequestDTO requestDTO) {
        return authService.login(requestDTO);
    }


    @PostMapping("/refresh")
    public Mono<AuthResponseDTO> refresh(@RequestBody RefreshRequestDTO refreshToken) {
        return authService.refresh(refreshToken);
    }

    @PostMapping("/logout")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public Mono<Void> logout(@RequestBody RefreshRequestDTO requestDTO) {
        return authService.logout(requestDTO);
    }
}