package backend_api.Qrbank.model.entities;

import backend_api.Qrbank.model.Model;
import backend_api.Qrbank.model.enums.IbanCurrency;
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
public class Account extends Model {
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
    private Double balance;

    @NotBlank
    @Column("currency")
    private IbanCurrency currency;

    @NotBlank
    @Column("active")
    private boolean active;

    public Account(Long userId, @NotBlank Long aLong, String accountNumber, String iban, BigDecimal zero, @NotBlank IbanCurrency currency, boolean b, LocalDateTime now, LocalDateTime updatedAt, LocalDateTime deletedAt) {
    }
}
