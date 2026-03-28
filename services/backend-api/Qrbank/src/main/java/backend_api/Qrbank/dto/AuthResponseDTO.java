package backend_api.Qrbank.dto;


public record AuthResponseDTO(String token,String refreshToken , String tokenType) {

    public AuthResponseDTO(String token, String refreshToken) {
        this(token, refreshToken, "Bearer");
    }

}
