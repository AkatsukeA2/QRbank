package backend_api.Qrbank.model;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
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
    @Column("user_id")
    private Long userId;

    @NotBlank
    @Column("token")
    private String token;

    @NotBlank
    @Column("expire_by")
    private LocalDateTime expireBy;

    @NotBlank
    @Column("revoked")
    private Boolean revoked = false;

    @NotBlank
    @Column("created_at")
    private LocalDateTime createdAt;
}
