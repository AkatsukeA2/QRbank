package backend_api.Qrbank.mapper;

import backend_api.Qrbank.dto.RoleRequestDTO;
import backend_api.Qrbank.dto.RoleResponseDTO;
import backend_api.Qrbank.model.Role;
import backend_api.Qrbank.model.RoleName;
import org.springframework.stereotype.Component;

import java.sql.Date;
import java.time.LocalDateTime;

@Component
public class RoleMapper {



    public static RoleResponseDTO toResponseDTO(Role role){
        return new RoleResponseDTO(
                role.getId(),
                RoleName.valueOf(role.getRoleName()),
                role.getDescription(),
                role.getCreatedAt(),
                role.getDeleteAt()
        );

    }

    public static Role toEntity(RoleRequestDTO dto) {
        return new Role(
                null,
                String.valueOf(dto.role()),
                dto.description(),
                LocalDateTime.now(),
                null
        );
    }
}
