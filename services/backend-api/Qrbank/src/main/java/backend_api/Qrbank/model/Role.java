package backend_api.Qrbank.model;

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
public class Role {

    @Id
    private Long id;

    @Column("role_name")
    private String roleName;

    @Column("description")
    private String description;

    @Column("created_at")
    private LocalDateTime createdAt;

    @Column("delete_at")
    private LocalDateTime deleteAt;





}
