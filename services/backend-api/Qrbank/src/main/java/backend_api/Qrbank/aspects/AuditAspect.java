package backend_api.Qrbank.aspects;

import backend_api.Qrbank.annotation.Auditable;
import backend_api.Qrbank.dto.AuditRequestDTO;
import backend_api.Qrbank.service.AuditService;
import backend_api.Qrbank.security.RequestContextFilter;
import lombok.RequiredArgsConstructor;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.*;
import org.springframework.security.core.context.ReactiveSecurityContextHolder;
import org.springframework.stereotype.Component;
import reactor.core.publisher.Mono;

import java.time.LocalDateTime;

@Aspect
@Component
@RequiredArgsConstructor
public class AuditAspect {

    private final AuditService auditService;

    @Around("@annotation(auditable)")
    public Object audit(ProceedingJoinPoint joinPoint, Auditable auditable) throws Throwable {

        Object result = joinPoint.proceed();

        if (result instanceof Mono<?> monoResult) {

            return monoResult
                    .flatMap(response ->
                            buildAudit(auditable.action(), "SUCCESS", null)
                                    .thenReturn(response)
                    )
                    .onErrorResume(ex ->
                            buildAudit(auditable.action(), "ERROR", ex.getMessage())
                                    .then(Mono.error(ex))
                    );
        }

        return result;
    }

    private Mono<Void> buildAudit(String action, String status, String error) {

        return ReactiveSecurityContextHolder.getContext()
                .map(ctx -> ctx.getAuthentication().getName())
                .defaultIfEmpty("anonymous")
                .flatMap(username ->
                        Mono.deferContextual(contextView -> {

                            String ip = contextView.getOrDefault(RequestContextFilter.IP_KEY, "unknown");

                            AuditRequestDTO dto = AuditRequestDTO.builder()
                                    .action(action)
                                    .userName(username)
                                    .ip(ip)
                                    .status(status)
                                    .errorMessage(error)
                                    .description("Executed action: " + action)
                                    .createdAt(LocalDateTime.now())
                                    .build();

                            return auditService.log(dto);
                        })
                );
    }
}