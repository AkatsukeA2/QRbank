package backend_api.Qrbank.dto;

import java.math.BigDecimal;

public record IbanTransferRequestDTO(
        String iban,
        BigDecimal amount
) {}
