package backend_api.Qrbank.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotBlank;

public record RefreshRequestDTO(
        @JsonProperty("refreshToken")
        @NotBlank
        String token
) {}
