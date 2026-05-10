package backend_api.Qrbank.dto;

import backend_api.Qrbank.model.enums.IbanCurrency;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record AccountRequestDTO(

        @NotNull
        Long userId,

        @NotBlank
        String currency

) {
}
