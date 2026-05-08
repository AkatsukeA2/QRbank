package backend_api.Qrbank.model.entities;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

import java.time.LocalDateTime;

@Builder
@Data
@NoArgsConstructor
@AllArgsConstructor
@Table("audit_logs")
public class Audit {

    @Id
    private Long id;

    @Column("user_id")
    private Long userId;

    @Column("action")
    private String action;

    @Column("entity_type")
    private String entityType;

    @Column("entity_id")
    private Long entityId;

    @Column("status")
    private String status;

    @Column("description")
    private String description;

    @Column("ip_address")
    private String ipAddress;

    @Column("created_at")
    private LocalDateTime createdAt;
}
