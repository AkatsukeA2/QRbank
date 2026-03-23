package backend_api.Qrbank.dto;

import backend_api.Qrbank.model.IbanCurrency;
import jakarta.validation.constraints.NotBlank;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public record AccountResponseDTO(

        @NotBlank
        Long id,

        @NotBlank
        String accountNumer,

        @NotBlank
        String iban,

        @NotBlank
        BigDecimal balance,

        @NotBlank
        IbanCurrency currency,

        @NotBlank
        boolean active,

        @NotBlank
        LocalDateTime createdAt
) {
}
