package backend_api.Qrbank.dto;

import backend_api.Qrbank.model.enums.TransactionStatus;
import backend_api.Qrbank.model.enums.TransactionType;

import java.time.LocalDateTime;

public record TransactionResponseDTO(
        Long id,

        Double amount,

        TransactionType type,

        TransactionStatus status,

        Long senderWalletId,

        Long receiverWalletId,

        LocalDateTime createdAt
) {
}
