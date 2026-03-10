package backend_api.Qrbank.model;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;
import java.time.LocalDateTime;

@Data
@Table("role")
public class Role {

    @Id
    private Long id;

    @Column("role_name")
    private RoleName role;

    @Column("description")
    private String description;

    @Column("created_at")
    private LocalDateTime createdAt;


    public Role(Integer id, RoleName role, String description, LocalDateTime now) {
    }
}
