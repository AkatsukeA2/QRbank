package backend_api.Qrbank.dto;

import backend_api.Qrbank.model.RoleName;
import java.time.LocalDateTime;

public record RoleResponseDTO(

        Long id,
        RoleName role,
        String description,
        LocalDateTime createdAt
) {
}
