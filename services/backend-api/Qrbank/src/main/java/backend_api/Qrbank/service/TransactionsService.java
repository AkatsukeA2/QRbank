package backend_api.Qrbank.service;

import backend_api.Qrbank.dto.TransactionRequestDTO;
import backend_api.Qrbank.dto.TransactionResponseDTO;
import backend_api.Qrbank.model.entities.Account;
import backend_api.Qrbank.model.entities.Transaction;
import backend_api.Qrbank.model.enums.TransactionStatus;
import backend_api.Qrbank.model.enums.TransactionType;
import backend_api.Qrbank.repository.AccountRepository;
import backend_api.Qrbank.repository.TransactionRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import backend_api.Qrbank.mapper.TransactionMapper;

import java.time.LocalDateTime;

@Service
@AllArgsConstructor
public class TransactionsService {

    private final TransactionRepository repository;
    private final AccountRepository accountRepository;


    @Transactional
    public Mono<TransactionResponseDTO> transfer(Long accountId, TransactionRequestDTO requestDTO){

        if (accountId.equals(requestDTO.receiverAccountID())) {
            return Mono.error(new RuntimeException("Não pode transferir para si próprio"));
        }

        Double amount = requestDTO.amount();
        TransactionType type = TransactionType.valueOf(requestDTO.type());

        return accountRepository.findById(accountId)
                .switchIfEmpty(Mono.error(new RuntimeException("Conta remetente inexistente")))
                .flatMap(sender ->

                        switch (type) {

                            case TRANSFER ->

                                    accountRepository.findById(requestDTO.receiverAccountID())
                                            .switchIfEmpty(Mono.error(new RuntimeException("Conta destino inexistente")))
                                            .flatMap(receiver ->
                                                    debit(accountId, amount)
                                                            .then(credit(receiver.getId(), amount))
                                                            .then(saveTransaction(
                                                                    requestDTO,
                                                                    accountId,
                                                                    TransactionStatus.COMPLETED
                                                            ))
                                            );

                            case DEPOSIT ->

                                    credit(accountId, amount)
                                            .then(saveTransaction(
                                                    requestDTO,
                                                    accountId,
                                                    TransactionStatus.COMPLETED
                                            ));

                            case WITHDRAW ->

                                    debit(accountId, amount)
                                            .then(saveTransaction(
                                                    requestDTO,
                                                    accountId,
                                                    TransactionStatus.COMPLETED
                                            ));

                        }
                );
    }

    public Mono<TransactionResponseDTO> getTransactionById(Long id){
        return repository.findById(id)
                .switchIfEmpty(Mono.error(new RuntimeException("Transação inexistente")))
                .map(TransactionMapper::toResponse);
    }

    public Flux<TransactionResponseDTO> getAllTransaction(){
        return repository.findAll()
                .switchIfEmpty(Mono.error(new RuntimeException("Sem transações")))
                .map(TransactionMapper::toResponse);
    }

    public Flux<TransactionResponseDTO> getTransactionByAccountId(Long id){
        return repository.findAllBySenderAccountId(id)
                .switchIfEmpty(Mono.error(new RuntimeException("Sem transações")))
                .map(TransactionMapper::toResponse);
    }


    private Mono<Void> debit(Long accountId, Double amount){
        return accountRepository.debitIfEnough(accountId, amount)
                .flatMap(row -> {
                    if (row == 0) return Mono.error(new RuntimeException("Saldo insuficiente"));
                    return Mono.empty();
                });
    }

    private Mono<Void> credit(Long accountId, Double amount){
        return accountRepository.credit(accountId, amount)
                .then();
    }

    private Mono<Void> withdraw(Long accountId, Double amount){
        return accountRepository.withdraw(accountId, amount)
                .then();
    }

    private Mono<TransactionResponseDTO> saveTransaction(TransactionRequestDTO requestDTO, Long senderAccountId, TransactionStatus status){

        Transaction transaction = new Transaction(
                senderAccountId,
                requestDTO.receiverAccountID(),
                requestDTO.amount(),
                TransactionType.valueOf(requestDTO.type()),
                status,
                LocalDateTime.now()
        );
        return repository.save(transaction).map(TransactionMapper::toResponse);
    }





}
