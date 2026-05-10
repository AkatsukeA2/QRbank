package backend_api.Qrbank.model.entities;

import backend_api.Qrbank.model.enums.EventStatus;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

import java.time.LocalDateTime;
@Data
@AllArgsConstructor
@NoArgsConstructor
@Table("outbox_event")
public class OutboxEvent {

    @Id
    private Long id;

    private Long aggregateId;

    private String type;

    private String payload;

    private EventStatus status; // PENDING, SENT

    private LocalDateTime createdAt;
}
