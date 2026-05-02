package backend_api.Qrbank.model.entities;

import backend_api.Qrbank.model.Model;
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
@Table("roles")
public class Role extends Model {

    @Column("role_name")
    private String roleName;

    @Column("description")
    private String description;

    public Role(Long id, String roleName, String description, LocalDateTime createdAt, LocalDateTime deletedAt) {
    }
}
