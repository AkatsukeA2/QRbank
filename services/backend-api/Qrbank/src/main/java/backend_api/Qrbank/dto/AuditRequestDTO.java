package backend_api.Qrbank.dto;


public record AuditRequestDTO(
        Long userId,
        String action,
        String entityType,
        Long entityId,
        String status,
        String description
) {
}
