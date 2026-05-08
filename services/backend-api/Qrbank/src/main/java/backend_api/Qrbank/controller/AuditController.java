package backend_api.Qrbank.controller;

import backend_api.Qrbank.dto.AuditResponseDTO;
import backend_api.Qrbank.mapper.AuditMapper;
import backend_api.Qrbank.repository.AuditRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Flux;

@RestController
@RequestMapping("/api/audit")
@RequiredArgsConstructor
public class AuditController {

    private final AuditRepository repository;

    @GetMapping
    public Flux<AuditResponseDTO> listAll() {
        return repository.findAll().map(AuditMapper::toResponse);
    }

    @GetMapping("/user/{userId}")
    public Flux<AuditResponseDTO> byUser(@PathVariable Long userId) {
        return repository.findByUserId(userId);
    }
}
