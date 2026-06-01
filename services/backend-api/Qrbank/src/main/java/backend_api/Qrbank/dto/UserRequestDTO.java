package backend_api.Qrbank.dto;

import jakarta.annotation.Nullable;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.sql.Date;
import java.time.LocalDate;

public record UserRequestDTO(

        @NotBlank
        String firstName,

        @NotBlank
        String lastName,

        @NotBlank
        @Email
        String email,

        @Nullable
        String password,

        @Nullable
        String phoneNumber,

        @Nullable
        Long roleId,

        @Nullable
        LocalDate dateOfBirth,

        @Nullable
        Long guardianID

) {
}
