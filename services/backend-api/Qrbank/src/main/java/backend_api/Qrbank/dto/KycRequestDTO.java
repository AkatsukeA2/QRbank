package backend_api.Qrbank.dto;

import jakarta.annotation.Nullable;
import jakarta.validation.constraints.NotBlank;
import lombok.Builder;

import java.sql.Date;
@Builder
public record KycRequestDTO(

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

        @Nullable
        String nationality,

        @Nullable
        String documentFrontUrl,

        @Nullable
        String documentBackUrl
) {
}
