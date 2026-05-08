package backend_api.Qrbank.service;

import backend_api.Qrbank.dto.AuditRequestDTO;
import backend_api.Qrbank.mapper.AuditMapper;
import backend_api.Qrbank.model.entities.Audit;
import backend_api.Qrbank.repository.AuditRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

@Service
@AllArgsConstructor
public class AuditService {

    private final AuditRepository repository;


    public Mono<Void> log(AuditRequestDTO requestDTO){
        Audit audit = AuditMapper.toEntity(requestDTO);
        return repository.save(audit).then();
    }

}
