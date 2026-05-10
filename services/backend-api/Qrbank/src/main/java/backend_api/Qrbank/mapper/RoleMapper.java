package backend_api.Qrbank.mapper;

import backend_api.Qrbank.dto.RoleRequestDTO;
import backend_api.Qrbank.dto.RoleResponseDTO;
import backend_api.Qrbank.model.entities.Role;
import backend_api.Qrbank.model.enums.RoleName;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Component
public class RoleMapper {



    public static RoleResponseDTO toResponseDTO(Role role){
        return new RoleResponseDTO(
                role.getId(),
                RoleName.valueOf(role.getRoleName()),
                role.getDescription(),
                role.getCreatedAt(),
                role.getDeletedAt()
        );

    }

    public static Role toEntity(RoleRequestDTO dto) {
        return Role.builder()
                .roleName(String.valueOf(dto.role()))
                .description(dto.description())
                .createdAt(LocalDateTime.now())
                .build();
    }
}
