package backend_api.Qrbank.controller;


import backend_api.Qrbank.dto.GuardianRequestDTO;
import backend_api.Qrbank.dto.GuardianResponseDTO;
import backend_api.Qrbank.dto.RoleResponseDTO;
import backend_api.Qrbank.service.GuardianService;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@RestController
@AllArgsConstructor
@RequestMapping("/api/guardians")
public class GuardianController {

    private final GuardianService service;

    // create

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Mono<ResponseEntity<GuardianResponseDTO>> create(@RequestBody GuardianRequestDTO requestDTO){
        return service.createGuardian(requestDTO).map(ResponseEntity::ok);
    }

    // get by id
    @GetMapping("/{id}")
    @ResponseStatus(HttpStatus.FOUND)
    public Mono<ResponseEntity<GuardianResponseDTO>> getByID(@PathVariable Long id){
        return service.findGuardianByID(id).map(ResponseEntity::ok);
    }

    // get all
    @GetMapping
    @ResponseStatus(HttpStatus.FOUND)
    public Flux<GuardianResponseDTO> getAll(){
        return service.findAllGuardians();
    }

    //update

    @PostMapping("/{id}")
    @ResponseStatus(HttpStatus.OK)
    public Mono<ResponseEntity<GuardianResponseDTO>> update(@PathVariable Long id, @RequestBody GuardianRequestDTO requestDTO){
        return service.updateGuardian(id,requestDTO).map(ResponseEntity::ok);
    }

    //soft delete
    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.OK)
    public Mono<ResponseEntity<GuardianResponseDTO>> softDelete(@PathVariable Long id){
        return service.softDelete(id).then(Mono.just(ResponseEntity.noContent().build()));
    }

    //hard delete
    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.OK)
    public Mono<ResponseEntity<GuardianResponseDTO>> hardDelete(@PathVariable Long id){
        return service.hardDelete(id).then(Mono.just(ResponseEntity.noContent().build()));
    }



}
