package backend_api.Qrbank.service;

import backend_api.Qrbank.dto.GuardianRequestDTO;
import backend_api.Qrbank.dto.GuardianResponseDTO;
import backend_api.Qrbank.mapper.GuardianMapper;
import backend_api.Qrbank.model.Guardian;
import backend_api.Qrbank.repository.GuardianRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.time.LocalDateTime;

@Service
public class GuardianService {

    private final GuardianRepository repository;

    public GuardianService(GuardianRepository repository) {
        this.repository = repository;
    }


    //create guardian
    public Mono<GuardianResponseDTO> createGuardian(GuardianRequestDTO requestDTO){

        return repository.existsByEmail(requestDTO.email()).flatMap(exist ->{
            if (exist) return Mono.error(new RuntimeException("this guardian already exist"));
            Guardian guardian = GuardianMapper.toEntity(requestDTO);
            guardian.setCreatedAT(LocalDateTime.now());
            return repository.save(guardian).map(GuardianMapper::toResponseDTO);
        });

    }

    // find by id

    public Mono<GuardianResponseDTO> findGuardianByID(Long id){

        Guardian guardian = repository.findById(id)
                .blockOptional()
                .orElseThrow(()->new RuntimeException("Guardian not found"));

        if (guardian.getDeletedAt() != null) throw new RuntimeException("guardian is deleted");

        return repository.findById(guardian.getId()).map(GuardianMapper::toResponseDTO);
    }

    // find all guardians

    public Flux<GuardianResponseDTO> findAllGuardians(){
        return repository.findAll().map(GuardianMapper::toResponseDTO);
    }

    // update guardian

    public Mono<GuardianResponseDTO> updateGuardian(Long id, GuardianRequestDTO requestDTO){

        Guardian guardian = repository.findById(id)
                .blockOptional()
                .orElseThrow(()->new RuntimeException("Guardian not found"));

        if (guardian.getDeletedAt() != null) throw new RuntimeException("guardian is deleted");

        guardian.setFirstName(requestDTO.firstName());
        guardian.setLastName(requestDTO.lastName());
        guardian.setEmail(requestDTO.email());
        guardian.setGuardianRelationship(requestDTO.relationship());
        guardian.setUpdatedAt(LocalDateTime.now());

        return repository.save(guardian).map(GuardianMapper::toResponseDTO);

    }

    // soft delete

    public Mono<Void> softDelete(Long id){

        Guardian guardian = repository.findById(id)
                .blockOptional()
                .orElseThrow(()->new RuntimeException("Guardian not found"));

        guardian.setDeletedAt(LocalDateTime.now());
        repository.save(guardian);
        return null;
    }

    // hard delete

    public Mono<Void> hardDelete(Long id){
        Guardian guardian = repository.findById(id)
                .blockOptional()
                .orElseThrow(()->new RuntimeException("Guardian not found"));

        // just when user crud get done
       // if (userRepository.existByGuardianID(id)) throw new RuntimeException("this guardian is linked to users, cannot delete ");

        repository.deleteById(id);
        return null;
    }

    // find guardian by email

    public Mono<GuardianResponseDTO> findGuardianByEmail(String email){

        Guardian guardian = repository.findByEmail(email);
        if (guardian == null)throw new RuntimeException("Guardian not found");
        return repository.findById(guardian.getId()).map(GuardianMapper::toResponseDTO);

    }


}
