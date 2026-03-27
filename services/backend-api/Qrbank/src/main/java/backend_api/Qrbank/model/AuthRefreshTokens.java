package backend_api.Qrbank.model;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

import java.time.LocalDateTime;

@Table("refresh_tokens")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class AuthRefreshTokens {

    @Id
    @NotBlank
    private Long id;

    @NotBlank
    private Long userID;

    @NotBlank
    private String token;

    @NotBlank
    private LocalDateTime expireBy;

    @NotBlank
    private Boolean revoked = false;

    @NotBlank
    private LocalDateTime createdAt;
}
