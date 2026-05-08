package backend_api.Qrbank.service;

import backend_api.Qrbank.dto.TransactionRequestDTO;
import backend_api.Qrbank.dto.TransactionResponseDTO;
import backend_api.Qrbank.model.entities.Account;
import backend_api.Qrbank.model.entities.Transaction;
import backend_api.Qrbank.model.enums.LedgerType;
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

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Service
@AllArgsConstructor
public class TransactionsService {

    private final TransactionRepository repository;
    private final AccountRepository accountRepository ;
    private final LedgerService ledgerService ;


    public Mono<TransactionResponseDTO> transfer(Long accountId, TransactionRequestDTO requestDTO){

        if (accountId.equals(requestDTO.receiverAccountID())) {
            return Mono.error(new RuntimeException("Não pode transferir para si próprio"));
        }

        BigDecimal amount2 =requestDTO.amount();
        TransactionType type = TransactionType.valueOf(requestDTO.type());

        return accountRepository.findById(accountId)
                .switchIfEmpty(Mono.error(new RuntimeException("Conta remetente inexistente")))
                .flatMap(sender -> {
                        if (!sender.isActive())return Mono.error(new RuntimeException("Account not active"));
                        switch (type) {

                            case TRANSFER -> handleTransfer( requestDTO, amount2, accountId);

                            case DEPOSIT -> handleDeposit(requestDTO, amount2, accountId);


                            case WITHDRAW -> handleWithdraw(requestDTO, amount2, accountId);


                        }
                    return saveTransaction(requestDTO, accountId, TransactionStatus.PENDING);
                });
    }

    public Mono<TransactionResponseDTO> IbanTransfer(Long accountId, String iban, BigDecimal amount){
        return accountRepository.findByIban(iban)
                .switchIfEmpty(Mono.error(new RuntimeException("Account not found")))
                .flatMap( receiver ->{
                            if (accountId.equals(receiver.getId())) {
                                return Mono.error(new RuntimeException("Não pode transferir para si próprio"));
                            }

                             ;
                            return transfer(
                                    accountId,
                                    TransactionRequestDTO.builder()
                                            .amount(amount)
                                            .type(TransactionType.TRANSFER.toString())
                                            .receiverAccountID(receiver.getId())
                                            .build());

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



    private Mono<TransactionResponseDTO> handleTransfer(TransactionRequestDTO requestDTO,BigDecimal amount2, Long accountId){
            return accountRepository.findById(requestDTO.receiverAccountID())
                            .switchIfEmpty(Mono.error(new RuntimeException("Conta destino inexistente")))
                            .flatMap(receiver ->

                                    // 1. salva transaction primeiro
                                    saveTransaction(requestDTO, accountId, TransactionStatus.PENDING)
                                            .flatMap(transaction ->

                                                    // 2. executa movimentações
                                                    debit(accountId, amount2)
                                                            .then(credit(receiver.getId(), amount2))

                                                            // 3. ledger depois de tudo ok
                                                            .then(Mono.when(

                                                                            ledgerService.createEntry(
                                                                                    accountId,
                                                                                    transaction.id(),
                                                                                    LedgerType.DEBIT,
                                                                                    amount2
                                                                            ),

                                                                            ledgerService.createEntry(
                                                                                    receiver.getId(),
                                                                                    transaction.id(),
                                                                                    LedgerType.CREDIT,
                                                                                    amount2
                                                                            )

                                                                    ).then(saveTransaction(requestDTO, accountId, TransactionStatus.COMPLETED))
                                                                    .thenReturn(transaction))

                                            )
                            );

    }

    private Mono<TransactionResponseDTO> handleDeposit(TransactionRequestDTO requestDTO,BigDecimal amount2, Long accountId){
        return saveTransaction(requestDTO, accountId, TransactionStatus.PENDING)
                .flatMap(transaction ->

                        credit(accountId, amount2)
                                .then(
                                        ledgerService.createEntry(
                                                accountId,
                                                transaction.id(),
                                                LedgerType.CREDIT,
                                                amount2
                                        )
                                ).then(saveTransaction(requestDTO, accountId, TransactionStatus.COMPLETED))
                                .thenReturn(transaction)

                );
    }

    private Mono<TransactionResponseDTO> handleWithdraw(TransactionRequestDTO requestDTO,BigDecimal amount2, Long accountId){

        return saveTransaction(requestDTO, accountId, TransactionStatus.PENDING)
                .flatMap(transaction ->

                        debit(accountId, amount2)
                                .then(
                                        ledgerService.createEntry(
                                                accountId,
                                                transaction.id(),
                                                LedgerType.DEBIT,
                                                amount2
                                        )
                                ).then(saveTransaction(requestDTO, accountId, TransactionStatus.COMPLETED))
                                .thenReturn(transaction)

                );

    }

    private Mono<Void> debit(Long accountId, BigDecimal amount){
        return accountRepository.debitIfEnough(accountId, amount)
                .flatMap(row -> {
                    if (row == 0) return Mono.error(new RuntimeException("Saldo insuficiente"));
                    return Mono.empty();
                });
    }

    private Mono<Void> credit(Long accountId, BigDecimal amount){
        return accountRepository.credit(accountId, amount)
                .then();
    }

    private Mono<Void> withdraw(Long accountId, BigDecimal amount){
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
