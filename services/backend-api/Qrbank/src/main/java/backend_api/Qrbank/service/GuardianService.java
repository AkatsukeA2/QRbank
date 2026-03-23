package backend_api.Qrbank.service;

import backend_api.Qrbank.dto.GuardianRequestDTO;
import backend_api.Qrbank.dto.GuardianResponseDTO;
import backend_api.Qrbank.mapper.GuardianMapper;
import backend_api.Qrbank.model.Guardian;
import backend_api.Qrbank.model.User;
import backend_api.Qrbank.repository.GuardianRepository;
import backend_api.Qrbank.repository.UserRepository;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.time.LocalDateTime;

@Service
@AllArgsConstructor
public class GuardianService {

    private final GuardianRepository repository;
    private final UserRepository userRepository;

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
        return repository.findById(id)
                .switchIfEmpty(Mono.error(new RuntimeException("Guardian not found")))
                .map(GuardianMapper::toResponseDTO);
    }

    // find all guardians

    public Flux<GuardianResponseDTO> findAllGuardians(){
        return repository.findAll().map(GuardianMapper::toResponseDTO);
    }

    // update guardian

    public Mono<GuardianResponseDTO> updateGuardian(Long id, GuardianRequestDTO requestDTO){

        return repository.findById(id)
                .switchIfEmpty(Mono.error(new RuntimeException("Guardian not found")))
                .flatMap(guardian -> {

                    if (guardian.getDeletedAt() != null) {
                        return Mono.error(new RuntimeException("Guardian is deleted"));
                    }

                    guardian.setFirstName(requestDTO.firstName());
                    guardian.setLastName(requestDTO.lastName());
                    guardian.setEmail(requestDTO.email());
                    guardian.setGuardianRelationship(requestDTO.relationship());
                    guardian.setUpdatedAt(LocalDateTime.now());

                    return repository.save(guardian);
                })
                .map(GuardianMapper::toResponseDTO);
    }

    // soft delete

    public Mono<Void> softDelete(Long id){
         return repository.findById(id).switchIfEmpty(Mono.error(new RuntimeException("Guardian not found"))).flatMap(guardian -> {

             guardian.setDeletedAt(LocalDateTime.now());
             return repository.save(guardian);

         }).then();

    }

    // hard delete

    public Mono<Void> hardDelete(Long id){

        return repository.findById(id).switchIfEmpty(Mono.error(new RuntimeException("Guardian not found"))).flatMap(guardian -> {
            Mono<Object> user = userRepository.existByGuardianID(id)
                    .switchIfEmpty(Mono.error(new RuntimeException("this guardian is linked to users, cannot delete ")))
                    .flatMap(exist ->{
                       return repository.deleteById(id);
                    } );


            return repository.deleteById(id);

        }).then();




    }

    // find guardian by email

    public Mono<GuardianResponseDTO> findGuardianByEmail(String email){

        return repository.findByEmail(email)
                    .switchIfEmpty(Mono.error(new RuntimeException("Guardian not found")))
                    .map(GuardianMapper::toResponseDTO);

    }


}
