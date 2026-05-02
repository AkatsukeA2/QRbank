package backend_api.Qrbank.model;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;

import java.time.LocalDateTime;
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Model {
    @Id
    @NotBlank
    @Column("id")
    protected Long id;

    @NotBlank
    @Column("created_at")
    protected LocalDateTime createdAt;

    @NotBlank
    @Column("updated_at")
    protected LocalDateTime updatedAt;

    @NotBlank
    @Column("deleted_at")
    protected LocalDateTime deletedAt;
}
