package backend_api.Qrbank.dto;

import backend_api.Qrbank.model.enums.RoleName;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record RoleRequestDTO(
        @NotNull
        RoleName role,

        @NotBlank
        String description
) {
}
