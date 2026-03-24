package backend_api.Qrbank.controller;

import backend_api.Qrbank.dto.AccountRequestDTO;
import backend_api.Qrbank.dto.AccountResponseDTO;
import backend_api.Qrbank.service.AccountService;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@RestController
@AllArgsConstructor
@RequestMapping("/api/accounts")
public class AccountController {

    private final AccountService service;

    // create account
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Mono<ResponseEntity<AccountResponseDTO>> create(@RequestBody AccountRequestDTO requestDTO){
        return service.createAccount(requestDTO).map(ResponseEntity::ok);
    }

    // get by id
    @GetMapping("/{id}")
    @ResponseStatus(HttpStatus.OK)
    public Mono<ResponseEntity<AccountResponseDTO>> getByID(@PathVariable Long id){
        return service.findById(id).map(ResponseEntity::ok);
    }

    // find all
    @GetMapping
    @ResponseStatus(HttpStatus.OK)
    public Flux<AccountResponseDTO> getAll(){
        return service.findByAll();
    }

    // find by user id
    @GetMapping("/{userId}")
    @ResponseStatus(HttpStatus.OK)
    public Mono<ResponseEntity<AccountResponseDTO>> getByUSerID(@PathVariable Long userID){
        return service.findByUser(userID).map(ResponseEntity::ok);
    }

    // deactivate account
    @PatchMapping("/{id}/deactivate")
    @ResponseStatus(HttpStatus.OK)
    public Mono<ResponseEntity<AccountResponseDTO>> deactivateAccount(@PathVariable Long id){
        return service.deactivate(id).map(ResponseEntity::ok);

    }

    // soft delete
    @PatchMapping("/{id}/soft")
    @ResponseStatus(HttpStatus.OK)
    public Mono<ResponseEntity<AccountResponseDTO>> softDelete(@PathVariable Long id){
        return service.softDelete(id).then(Mono.just(ResponseEntity.noContent().build()));
    }

    // restore
    @PatchMapping("/{id}/restore")
    @ResponseStatus(HttpStatus.OK)
    public Mono<ResponseEntity<AccountResponseDTO>> restore(@PathVariable Long id){
        return service.restoreAccount(id).then(Mono.just(ResponseEntity.noContent().build()));
    }

    // hard delete
    @PatchMapping("/{id}/hard")
    @ResponseStatus(HttpStatus.OK)
    public Mono<ResponseEntity<AccountResponseDTO>>hardDelete(@PathVariable Long id){
        return service.hardDelete(id).then(Mono.just(ResponseEntity.noContent().build()));
    }








    }
