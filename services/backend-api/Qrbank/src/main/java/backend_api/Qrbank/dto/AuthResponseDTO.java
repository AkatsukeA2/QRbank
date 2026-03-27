package backend_api.Qrbank.dto;


public record AuthResponseDTO(String token, String tokenType) {

    public AuthResponseDTO(String token) {
        this(token, "Bearer");
    }

}
