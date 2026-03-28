package backend_api.Qrbank.service;

import backend_api.Qrbank.config.JwtPropertiesConfig;
import backend_api.Qrbank.model.AuthRefreshTokens;
import backend_api.Qrbank.model.RoleName;
import backend_api.Qrbank.model.User;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.security.Key;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.UUID;

@Service
@AllArgsConstructor
public class JwtService {

    private final JwtPropertiesConfig jwtPropertiesConfig;


    public String generateToken(User user, RoleName roleName) {
        return Jwts.builder()
                .setSubject(String.valueOf(user.getId()))
                .claim("email", user.getEmail())
                .claim("role", roleName)
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + jwtPropertiesConfig.getExpiration()))
                .signWith(getSigningKey(), SignatureAlgorithm.HS256)
                .compact();
    }

    public boolean validatedToken(String token) {
        try {
            extractAllClaims(token);
            return true;
        } catch (Exception e) {
            return false;
        }
    }


    public Long getUserId(String token) {
        return Long.parseLong(extractAllClaims(token).getSubject());
    }


    public String getRole(String token) {
        return extractAllClaims(token).get("role", String.class);
    }

    private Key getSigningKey() {
        return Keys.hmacShaKeyFor(Decoders.BASE64.decode(jwtPropertiesConfig.getSecret()));
    }

    private Claims extractAllClaims(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(getSigningKey())
                .build()
                .parseClaimsJws(token)
                .getBody();
    }

    public String extractUsername(String token) {
        return extractAllClaims(token).get("email", String.class);
    }
}