package backend_api.Qrbank.model.entities;


import backend_api.Qrbank.model.Model;
import backend_api.Qrbank.model.enums.TransactionStatus;
import backend_api.Qrbank.model.enums.TransactionType;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Table("transactions")
public class Transaction extends Model {


    @Column("sender_account_id")
    private Long senderAccountId;

    @Column("receiver_account_id")
    private Long receiverAccountId;

    @Column("amount")
    private Double amount;

    @Column("type")
    private TransactionType type;

    @Column("status")
    private TransactionStatus status;

    public Transaction(Long id, Long senderAccountId, @NotBlank Double amount, @NotBlank TransactionType type, TransactionStatus status, LocalDateTime createdAt) {
    }
}
