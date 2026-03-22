package backend_api.Qrbank.service;

import backend_api.Qrbank.dto.GuardianRequestDTO;
import backend_api.Qrbank.dto.GuardianResponseDTO;
import backend_api.Qrbank.mapper.GuardianMapper;
import backend_api.Qrbank.model.Guardian;
import backend_api.Qrbank.repository.GuardianRepository;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

@Service
public class GuardianService {

    private final GuardianRepository repository;

    public GuardianService(GuardianRepository repository) {
        this.repository = repository;
    }


    //create guardian
    public Mono<GuardianResponseDTO> createGuardian(GuardianRequestDTO requestDTO){
        Guardian guardian = GuardianMapper.toEntity(requestDTO)

    }
}
