package backend_api.Qrbank.controller;

import backend_api.Qrbank.dto.IbanTransferRequestDTO;
import backend_api.Qrbank.dto.TransactionRequestDTO;
import backend_api.Qrbank.dto.TransactionResponseDTO;
import backend_api.Qrbank.mapper.TransactionMapper;
import backend_api.Qrbank.service.TransactionsService;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.math.BigDecimal;

@RestController
@AllArgsConstructor
@RequestMapping("/api/transactions")
public class TransactionController {

    private final TransactionsService service;

    @PostMapping("/transfer/{id}")
    @ResponseStatus(HttpStatus.ACCEPTED)
    public Mono<ResponseEntity<TransactionResponseDTO>> transfer(@RequestBody TransactionRequestDTO requestDTO, @PathVariable Long id){
        return service.transfer(id,requestDTO).map(res -> ResponseEntity.status(HttpStatus.ACCEPTED).body(res));
    }

    @GetMapping("/id/{id}")
    @ResponseStatus(HttpStatus.OK)
    public Mono<ResponseEntity<TransactionResponseDTO>> getById(@PathVariable Long id){
        return service.getTransactionById(id).map(ResponseEntity::ok);
    }

    @GetMapping
    @ResponseStatus(HttpStatus.OK)
    public Flux<ResponseEntity<TransactionResponseDTO>> getAll(){
        return service.getAllTransaction().map(ResponseEntity::ok);
    }

    @GetMapping("/account/{accountId}")
    @ResponseStatus(HttpStatus.OK)
    public Flux<TransactionResponseDTO> getByAccountId(@PathVariable Long accountId){
        return service.getTransactionByAccountId(accountId);
    }

    @PostMapping("/transfer/{id}/qr")
    @ResponseStatus(HttpStatus.ACCEPTED)
    public Mono<ResponseEntity<TransactionResponseDTO>> QrTransfer(@RequestBody TransactionRequestDTO requestDTO, @PathVariable Long id){
        return service.transfer(id,requestDTO).map(res -> ResponseEntity.status(HttpStatus.ACCEPTED).body(res));
    }


    @PostMapping("/transfer/{id}/iban")
    @ResponseStatus(HttpStatus.ACCEPTED)
    public Mono<ResponseEntity<TransactionResponseDTO>> IbanTransfer(@RequestBody IbanTransferRequestDTO requestDTO, @PathVariable Long id){
        return service.IbanTransfer(id, requestDTO.iban(), requestDTO.amount()).map(res -> ResponseEntity.status(HttpStatus.ACCEPTED).body(res));
    }


}
