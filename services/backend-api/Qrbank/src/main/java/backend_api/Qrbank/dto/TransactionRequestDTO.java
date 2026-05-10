package backend_api.Qrbank.dto;

import backend_api.Qrbank.model.enums.TransactionType;
import jakarta.annotation.Nullable;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Builder;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;

@Builder
public record TransactionRequestDTO(

        @NotNull
        BigDecimal amount,

        @NotBlank
        String type,

        @Nullable
        Long receiverAccountID,

        @Nullable
        Long reference



) {
}
