package backend_api.Qrbank.dto;

import backend_api.Qrbank.model.enums.RoleName;

public record RoleRequestDTO(

         RoleName role,
         String description

) {
}
