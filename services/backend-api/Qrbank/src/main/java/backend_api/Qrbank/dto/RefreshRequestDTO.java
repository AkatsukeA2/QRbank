package backend_api.Qrbank.dto;

import jakarta.validation.constraints.NotBlank;

public record RefreshRequestDTO(
        @NotBlank
        String RefreshToken

) {
}
