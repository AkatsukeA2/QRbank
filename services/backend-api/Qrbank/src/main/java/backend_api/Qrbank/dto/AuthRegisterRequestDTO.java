package backend_api.Qrbank.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import java.time.LocalDate;
import java.time.LocalDateTime;

public record AuthRegisterRequestDTO(

        @Email(message = "invalid email format")
        @NotBlank(message = "email is required")
        String email,

        @NotBlank(message = "password is required")
        @Size(min = 6, message = "password must be at least 6 characters")
        String password,

        @NotBlank(message = "first name is required")
        String firstName,

        @NotBlank(message = "surname is required")
        String lastName,

        @NotBlank(message = "phone number is required")
        String phoneNumber,

        @NotNull(message = "phone number is required")
        LocalDate age

) {
}
