package backend_api.Qrbank.mapper;

import backend_api.Qrbank.dto.AuditRequestDTO;
import backend_api.Qrbank.dto.AuditResponseDTO;
import backend_api.Qrbank.model.entities.Audit;

import java.time.LocalDateTime;

public class AuditMapper {

    public static Audit toEntity(AuditRequestDTO requestDTO){
        return Audit.builder()
                .id(null)
                .userId(requestDTO.userId())
                .action(requestDTO.action())
                .entityType(requestDTO.entityType())
                .entityId(requestDTO.entityId())
                .status(requestDTO.status())
                .description(requestDTO.description())
                .createdAt(requestDTO.createdAt())
                .ipAddress(requestDTO.ip())
                .build();
    }

    public static AuditResponseDTO toResponse(Audit entity){
        return AuditResponseDTO.builder()
                .id(entity.getId())
                .userId(entity.getUserId())
                .action(entity.getAction())
                .entityType(entity.getEntityType())
                .entityId(entity.getUserId())
                .status(entity.getStatus())
                .description(entity.getDescription())
                .createdAt(LocalDateTime.now())
                .ip(entity.getIpAddress())
                .build();
   }
}
