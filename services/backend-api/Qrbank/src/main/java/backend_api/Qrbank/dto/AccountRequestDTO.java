package backend_api.Qrbank.dto;

import backend_api.Qrbank.model.IbanCurrency;
import jakarta.validation.constraints.NotBlank;

public record AccountRequestDTO(

        @NotBlank
        Long userId,

        @NotBlank
        IbanCurrency currency

) {
}
