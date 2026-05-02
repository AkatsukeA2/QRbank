package backend_api.Qrbank.mapper;

import backend_api.Qrbank.dto.TransactionRequestDTO;
import backend_api.Qrbank.dto.TransactionResponseDTO;
import backend_api.Qrbank.model.entities.Transaction;
import backend_api.Qrbank.model.enums.TransactionType;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
@Component
public class TransactionMapper {

    public static TransactionResponseDTO toResponse(Transaction transaction){
        return new TransactionResponseDTO(
                transaction.getId(),
                transaction.getAmount(),
                transaction.getType(),
                transaction.getStatus(),
                transaction.getSenderAccountId(),
                transaction.getReceiverAccountId(),
                transaction.getCreatedAt()
        );
    }

    public static Transaction toEntity(TransactionRequestDTO requestDTO){
        return new Transaction(
                null,
                requestDTO.receiverAccountID(),
                requestDTO.amount(),
                TransactionType.valueOf(requestDTO.type()),
                null,
                LocalDateTime.now()
        );
    }


}
