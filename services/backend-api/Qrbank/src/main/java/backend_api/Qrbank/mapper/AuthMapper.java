package backend_api.Qrbank.mapper;

import backend_api.Qrbank.dto.AuthResponseDTO;
import backend_api.Qrbank.model.User;
import org.springframework.stereotype.Component;

@Component
public class AuthMapper {

    public static AuthResponseDTO toResponse(String token){
        return new AuthResponseDTO(
                token,
                "Bearer"
        );
    }
}
