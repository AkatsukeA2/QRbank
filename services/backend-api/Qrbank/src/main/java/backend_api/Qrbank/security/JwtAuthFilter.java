package backend_api.Qrbank.security;

import org.springframework.security.authentication.ReactiveAuthenticationManager;
import org.springframework.security.web.server.authentication.AuthenticationWebFilter;

public class JwtAuthFilter extends AuthenticationWebFilter {
    public JwtAuthFilter(ReactiveAuthenticationManager authenticationManager) {
        super(authenticationManager);
    }
}
