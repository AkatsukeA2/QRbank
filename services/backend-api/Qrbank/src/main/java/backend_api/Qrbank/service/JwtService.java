package backend_api.Qrbank.service;

import backend_api.Qrbank.config.JwtPropertiesConfig;
import backend_api.Qrbank.model.Role;
import backend_api.Qrbank.model.User;
import backend_api.Qrbank.repository.RoleRepository;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

import java.util.Date;

@Service
@AllArgsConstructor
public class JwtService {

    private JwtPropertiesConfig jwtPropertiesConfig;
    private RoleRepository roleRepository;

    public  Mono<String>  generateToken(User user){
        return roleRepository.findById(user.getRoleID()).map(role -> Jwts.builder()
                    .setSubject(String.valueOf(user.getId()))
                    .claim("email",user.getEmail()).claim("role",role.getRoleName())
                    .setIssuedAt(new Date())
                    .setExpiration(new Date(System.currentTimeMillis() + jwtPropertiesConfig.getExpiration()))
                    .signWith(SignatureAlgorithm.HS256, jwtPropertiesConfig.getSecret()).compact()
        );


    }

    public boolean validateToken(String token) {
        try {
            Jwts.parser()
                    .setSigningKey(jwtPropertiesConfig.getSecret())
                    .parseClaimsJws(token);
            return true;
        } catch (Exception e) {
            return false;
        }
    }


    public Long getUserId(String token) {
        Claims claims = Jwts.parser()
                .setSigningKey(jwtPropertiesConfig.getSecret())
                .parseClaimsJws(token)
                .getBody();

        return Long.parseLong(claims.getSubject());
    }

    public Long getRoleId(String token) {
        Claims claims = Jwts.parser()
                .setSigningKey(jwtPropertiesConfig.getSecret())
                .parseClaimsJws(token)
                .getBody();

        return claims.get("roleId", Long.class);
    }


}
