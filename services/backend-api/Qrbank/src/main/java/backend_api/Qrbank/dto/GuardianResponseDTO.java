package backend_api.Qrbank.dto;

import backend_api.Qrbank.model.GuardianRelationship;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import org.hibernate.validator.internal.util.privilegedactions.LoadClass;
import org.springframework.cglib.core.Local;

import java.time.LocalDateTime;

public record GuardianResponseDTO(

        @NotBlank
        Long id,

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
        GuardianRelationship relationship,

        @NotBlank
        LocalDateTime createdAt,

        @NotBlank
        LocalDateTime updatedAt,

        @NotBlank
        LocalDateTime deletedAt

) {
}
