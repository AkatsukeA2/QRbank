package backend_api.Qrbank.model.entities;

import backend_api.Qrbank.model.enums.LedgerType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Table("ledgers")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Ledger {

    @Id
    private Long id;

    @Column("account_id")
    private Long accountId;

    @Column("transaction_id")
    private Long transactionId;

    @Column("type")
    private LedgerType type;

    @Column("amount")
    private BigDecimal amount;

    @Column("balance_after")
    private BigDecimal balanceAfter;

    @Column("description")
    private String description;

    @Column("created_at")
    private LocalDateTime createdAt;


}
