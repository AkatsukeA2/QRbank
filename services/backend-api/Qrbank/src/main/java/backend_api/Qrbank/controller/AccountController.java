package backend_api.Qrbank.controller;

import backend_api.Qrbank.dto.AccountRequestDTO;
import backend_api.Qrbank.dto.AccountResponseDTO;
import backend_api.Qrbank.dto.LedgerResponseDTO;
import backend_api.Qrbank.service.AccountService;
import backend_api.Qrbank.service.LedgerService;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.Map;

@RestController
@AllArgsConstructor
@RequestMapping("/api/accounts")
public class AccountController {

    private final AccountService service;
    private final LedgerService ledgerService;

    // create account
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Mono<ResponseEntity<AccountResponseDTO>> create(@RequestBody AccountRequestDTO requestDTO){

        return service.createAccount(requestDTO)
                .map(res -> ResponseEntity.status(HttpStatus.CREATED).body(res));
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
    @GetMapping("/user/{userId}")
    @ResponseStatus(HttpStatus.OK)
    public Mono<ResponseEntity<AccountResponseDTO>> getByUSerID(@PathVariable Long userId){
        return service.findByUser(userId).map(ResponseEntity::ok);
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
    public Mono<Void> restore(@PathVariable Long id){
        return service.restoreAccount(id).then();
    }

    // hard delete
    @PatchMapping("/{id}/hard")
    @ResponseStatus(HttpStatus.OK)
    public Mono<Void>hardDelete(@PathVariable Long id){
        return service.hardDelete(id).then();
    }


    @GetMapping("/{accountId}/ledger")
    public Flux<LedgerResponseDTO> getStatement(@PathVariable Long accountId) {
        return ledgerService.getStatement(accountId);
    }

    @GetMapping("/{id}/qr")
    @ResponseStatus(HttpStatus.OK)
    public Mono<Map<String,String>> getQrData(@PathVariable Long id){
        return Mono.just(
                Map.of(
                        "type","ACCOUNT_QR",
                        "accountId", String.valueOf(id)
                )
        );
    }








    }
