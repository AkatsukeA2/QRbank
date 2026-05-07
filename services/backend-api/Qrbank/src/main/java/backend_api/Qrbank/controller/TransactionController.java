package backend_api.Qrbank.controller;

import backend_api.Qrbank.dto.TransactionRequestDTO;
import backend_api.Qrbank.dto.TransactionResponseDTO;
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

    @PostMapping("/tranfer/{id}")
    @ResponseStatus(HttpStatus.ACCEPTED)
    public Mono<ResponseEntity<TransactionResponseDTO>> transfer(@RequestBody TransactionRequestDTO requestDTO, @PathVariable Long id){
        return service.transfer(id,requestDTO).map(ResponseEntity::ok);
    }

    @GetMapping("/id/{id}")
    @ResponseStatus(HttpStatus.OK)
    public Mono<ResponseEntity<TransactionResponseDTO>> getById(@PathVariable Long id){
        return service.getTransactionById(id).map(ResponseEntity::ok);
    }

    @GetMapping("/")
    @ResponseStatus(HttpStatus.OK)
    public Flux<ResponseEntity<TransactionResponseDTO>> getAll(){
        return service.getAllTransaction().map(ResponseEntity::ok);
    }

    @GetMapping("/account/{accountId}")
    @ResponseStatus(HttpStatus.OK)
    public Flux<ResponseEntity<TransactionResponseDTO>> getByAccountId(@PathVariable Long accountId){
        return service.getTransactionByAccountId(accountId).map(ResponseEntity::ok);
    }

    @PostMapping("/tranfer/{id}/qr")
    @ResponseStatus(HttpStatus.ACCEPTED)
    public Mono<ResponseEntity<TransactionResponseDTO>> QrTransfer(@RequestBody TransactionRequestDTO requestDTO, @PathVariable Long id){
        return service.transfer(id,requestDTO).map(ResponseEntity::ok);
    }


    @PostMapping("/tranfer/{id}/iban")
    @ResponseStatus(HttpStatus.ACCEPTED)
    public Mono<ResponseEntity<TransactionResponseDTO>> Ibantransfer(@RequestBody String iban, @PathVariable Long id, @RequestBody BigDecimal amount){
        return service.IbanTransfer(id,iban,amount).map(ResponseEntity::ok);
    }


}
