package backend_api.Qrbank.security;

import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import org.springframework.web.server.WebFilter;
import org.springframework.web.server.WebFilterChain;
import reactor.core.publisher.Mono;
@Component
public class RequestContextFilter implements WebFilter {

    public static final String IP_KEY = "REQUEST_IP";
    @Override
    public Mono<Void> filter(ServerWebExchange exchange, WebFilterChain chain) {
        String ip = exchange.getRequest()
                .getRemoteAddress()
                .getAddress()
                .getHostAddress();

        return chain.filter(exchange)
                .contextWrite(context -> context.put(IP_KEY, ip));
    }
}
