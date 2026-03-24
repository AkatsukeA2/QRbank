package backend_api.Qrbank.model;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Table("accounts")
public class Account {

    @Id
    @NotBlank
    @Column("id")
    private Long id;

    @NotBlank
    @Column("user_id")
    private Long userId;

    @NotBlank
    @Column("account_number")
    private String accountNumber;

    @NotBlank
    @Column("iban")
    private String iban;

    @NotBlank
    @Column("balance")
    private BigDecimal balance;

    @NotBlank
    @Column("currency")
    private IbanCurrency currency;

    @NotBlank
    @Column("active")
    private boolean active;

    @NotBlank
    @Column("created_at")
    private LocalDateTime createdAt;

    @NotBlank
    @Column("updated_at")
    private LocalDateTime updatedAt;

    @NotBlank
    @Column("deleted_at")
    private LocalDateTime deletedAt;




}
