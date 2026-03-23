package backend_api.Qrbank.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

public record UserRequestDTO(

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
        Long guardianID

) {
}
