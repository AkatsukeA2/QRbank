package backend_api.Qrbank.dto;

import lombok.Builder;

import java.time.LocalDateTime;

@Builder
public record AuditResponseDTO(

        Long id,
        Long userId,
        String action,
        String entityType,
        Long entityId,
        String status,
        String description,
        LocalDateTime createdAt,
        String ip
) {
}
