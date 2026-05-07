package backend_api.Qrbank.dto;

import backend_api.Qrbank.model.enums.KycStatus;
import jakarta.annotation.Nullable;
import jakarta.validation.constraints.NotBlank;
import lombok.Builder;

import java.sql.Date;
import java.time.LocalDateTime;

@Builder
public record KycResponseDTO(

        @NotBlank
        Long id,

        @NotBlank
        Long accountId,

        @NotBlank
        String fullName,

        @NotBlank
        String documentType,

        @NotBlank
        String documentNumber,

        @NotBlank
        Date birthDate,

        @NotBlank
        KycStatus status,

        @Nullable
        String rejectionReason,

        @NotBlank
        LocalDateTime submittedAt,

        @NotBlank
        LocalDateTime verifiedAt
) {
}
