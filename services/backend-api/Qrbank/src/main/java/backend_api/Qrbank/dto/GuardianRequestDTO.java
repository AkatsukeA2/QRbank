package backend_api.Qrbank.dto;

import backend_api.Qrbank.model.GuardianRelationship;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

public record GuardianRequestDTO(

        @NotBlank
        String firstName,

        @NotBlank
        String lastName,

        @NotBlank
        @Email
        String email,

        @NotBlank
        String phoneNumber,

        @NotBlank
        GuardianRelationship relationship


) {
}
