package backend_api.Qrbank.mapper;

import backend_api.Qrbank.dto.RoleRequestDTO;
import backend_api.Qrbank.dto.RoleResponseDTO;
import backend_api.Qrbank.model.Role;
import org.springframework.stereotype.Component;

import java.sql.Date;
import java.time.LocalDateTime;

@Component
public class RoleMapper {



    public static RoleResponseDTO toResponseDTO(Role role){
        return new RoleResponseDTO(
                role.getId(),
                role.getRoleName(),
                role.getDescription(),
                role.getCreatedAt()
        );

    }

    public static Role toEntity(RoleRequestDTO dto) {
        return new Role(
                null,
                dto.role(),
                dto.description(),
                LocalDateTime.now()
        );
    }
}
