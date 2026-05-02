package backend_api.Qrbank.dto;

import backend_api.Qrbank.model.enums.TransactionType;
import jakarta.annotation.Nullable;
import jakarta.validation.constraints.NotBlank;

public record TransactionRequestDTO(

        @NotBlank
        Double amount,

        @NotBlank
        String type,

        @Nullable
        Long receiverAccountID,

        @Nullable
        Long reference



) {
}
