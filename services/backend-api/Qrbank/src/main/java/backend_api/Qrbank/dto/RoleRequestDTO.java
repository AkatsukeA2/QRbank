package backend_api.Qrbank.dto;

import backend_api.Qrbank.model.RoleName;

public record RoleRequestDTO(

         RoleName role,
         String description

) {
}
