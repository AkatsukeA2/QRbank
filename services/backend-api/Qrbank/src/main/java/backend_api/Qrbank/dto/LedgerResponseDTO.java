package backend_api.Qrbank.dto;

import backend_api.Qrbank.model.enums.LedgerType;
import jakarta.annotation.Nullable;
import lombok.Builder;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Builder
public record LedgerResponseDTO(
        Long id,
        LedgerType type,
        BigDecimal amount,
        BigDecimal balanceAfter,
        LocalDateTime createdAt,
        @Nullable
        String description
) {
}
