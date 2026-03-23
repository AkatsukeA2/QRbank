package backend_api.Qrbank.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

import java.time.LocalDateTime;

public record UserResponseDTO(

        @NotBlank
        Long id,

        @NotBlank
        String fistName,

        @NotBlank
        String lastName,

        @NotBlank
        @Email
        String email,

        @NotBlank
        String passWord,

        @NotBlank
        String phoneNumber,

        @NotBlank
        Long roleId,

        @NotBlank
        Long guardianID,

        @NotBlank
        LocalDateTime createdAt,

        @NotBlank
        LocalDateTime updatedAt,

        @NotBlank
        LocalDateTime deletedAt
) {
}
