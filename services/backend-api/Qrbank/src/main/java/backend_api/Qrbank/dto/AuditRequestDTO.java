package backend_api.Qrbank.dto;

import jakarta.annotation.Nullable;
import lombok.Builder;

import java.time.LocalDateTime;

@Builder
public record AuditRequestDTO(
        Long userId,
        String action,
        String entityType,
        Long entityId,
        String status,
        String description,

        @Nullable
        String userName,

        @Nullable
        String ip,

        @Nullable
        String errorMessage,

        LocalDateTime createdAt

) {
}
