package backend_api.Qrbank.dto;

import backend_api.Qrbank.model.enums.TransactionStatus;
import backend_api.Qrbank.model.enums.TransactionType;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public record TransactionResponseDTO(
        Long id,

        BigDecimal amount,

        TransactionType type,

        TransactionStatus status,

        Long senderWalletId,

        Long receiverWalletId,

        LocalDateTime createdAt
) {
}
