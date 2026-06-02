package backend_api.Qrbank.model.entities;

import backend_api.Qrbank.model.Model;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;
import java.time.LocalDateTime;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Table("roles")
public class Role {

    @Id
    @NotBlank
    @Column("id")
    protected Long id;

    @NotBlank
    @Column("created_at")
    protected LocalDateTime createdAt;

    @NotBlank
    @Column("delete_at")
    protected LocalDateTime deletedAt;

    @Column("role_name")
    private String roleName;

    @Column("description")
    private String description;


}
