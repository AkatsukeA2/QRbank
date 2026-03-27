package backend_api.Qrbank.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

public record AuthLoginRequestDTO(

        @Email(message = "invalid email format")
        @NotBlank(message = "email is required")
        String email,

        @NotBlank(message = "password is required")
        String password
) {
}
