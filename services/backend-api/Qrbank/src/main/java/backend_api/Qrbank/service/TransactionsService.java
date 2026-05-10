package backend_api.Qrbank.service;

import backend_api.Qrbank.annotation.Auditable;
import backend_api.Qrbank.dto.TransactionRequestDTO;
import backend_api.Qrbank.dto.TransactionResponseDTO;
/*import backend_api.Qrbank.event.LedgerTransactionEvent;
import backend_api.Qrbank.model.entities.OutboxEvent;*/
import backend_api.Qrbank.model.entities.Transaction;
import backend_api.Qrbank.model.enums.EventStatus;
import backend_api.Qrbank.model.enums.LedgerType;
import backend_api.Qrbank.model.enums.TransactionStatus;
import backend_api.Qrbank.model.enums.TransactionType;
import backend_api.Qrbank.repository.AccountRepository;
import backend_api.Qrbank.repository.OutboxEventRepository;
import backend_api.Qrbank.repository.TransactionRepository;
import backend_api.Qrbank.mapper.TransactionMapper;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.AllArgsConstructor;
import org.jetbrains.annotations.NotNull;
import org.springframework.stereotype.Service;

import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Service
@AllArgsConstructor
public class TransactionsService {

    private final TransactionRepository repository;
    private final OutboxEventRepository outboxEventRepository;
    private final AccountRepository accountRepository;
    private final LedgerService ledgerService;
    private final ObjectMapper objectMapper;

    @Auditable(action = "TRANSFER")
    public Mono<TransactionResponseDTO> transfer(Long accountId, TransactionRequestDTO requestDTO) {

        if (accountId.equals(requestDTO.receiverAccountID())) {
            return Mono.error(new RuntimeException("Não pode transferir para si próprio"));
        }

        BigDecimal amount = requestDTO.amount();
        TransactionType type = TransactionType.valueOf(requestDTO.type());

        return accountRepository.findById(accountId)
                .switchIfEmpty(Mono.error(new RuntimeException("Conta remetente inexistente")))
                .flatMap(sender -> {

                    if (!sender.isActive())
                        return Mono.error(new RuntimeException("Account not active"));

                    return switch (type) {
                        case TRANSFER -> handleTransfer(requestDTO, amount, accountId);
                        case DEPOSIT -> handleDeposit(requestDTO, amount, accountId);
                        case WITHDRAW -> handleWithdraw(requestDTO, amount, accountId);
                    };
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

    private Mono<TransactionResponseDTO> handleTransfer(
            TransactionRequestDTO requestDTO,
            BigDecimal amount,
            Long accountId
    ) {

        return accountRepository.findById(requestDTO.receiverAccountID())
                .switchIfEmpty(Mono.error(new RuntimeException("Conta destino inexistente")))
                .flatMap(receiver ->

                        saveTransaction(requestDTO, accountId, TransactionStatus.PENDING)
                                .flatMap(transaction ->

                                        debit(accountId, amount)
                                                .then(credit(receiver.getId(), amount))
                                                .then(Mono.when(
                                                        ledgerService.createEntry(accountId, transaction.id(), LedgerType.DEBIT, amount),
                                                        ledgerService.createEntry(receiver.getId(), transaction.id(), LedgerType.CREDIT, amount)
                                                ))
                                                .then(saveTransaction(requestDTO, accountId, TransactionStatus.COMPLETED))
                                               /* .flatMap(t -> {

                                                    LedgerTransactionEvent event = new LedgerTransactionEvent(
                                                            transaction.id(),
                                                            accountId,
                                                            receiver.getId(),
                                                            amount,
                                                            "TRANSFER",
                                                            "COMPLETED"
                                                    );

                                                    OutboxEvent outbox = new OutboxEvent(
                                                            null,
                                                            accountId,
                                                            "LEDGER_TRANSACTION",
                                                            safeJson(event),
                                                            EventStatus.valueOf("PENDING"),
                                                            LocalDateTime.now()
                                                    );

                                                    return outboxEventRepository.save(outbox)
                                                            .thenReturn(t);
                                                })*/
                                )
                );
    }

    private Mono<TransactionResponseDTO> handleDeposit(
            TransactionRequestDTO requestDTO,
            BigDecimal amount,
            Long accountId
    ) {

        return saveTransaction(requestDTO, accountId, TransactionStatus.PENDING)
                .flatMap(transaction ->
                        credit(accountId, amount)
                                .then(ledgerService.createEntry(accountId, transaction.id(), LedgerType.CREDIT, amount))
                                .then(saveTransaction(requestDTO, accountId, TransactionStatus.COMPLETED))
                                /*.flatMap(t -> {

                                    LedgerTransactionEvent event = new LedgerTransactionEvent(
                                            transaction.id(),
                                            accountId,
                                            accountId,
                                            amount,
                                            "DEPOSIT",
                                            "COMPLETED"
                                    );

                                    OutboxEvent outbox = new OutboxEvent(
                                            null,
                                            accountId,
                                            "LEDGER_TRANSACTION",
                                            safeJson(event),
                                            EventStatus.valueOf("PENDING"),
                                            LocalDateTime.now()
                                    );

                                    return outboxEventRepository.save(outbox)
                                            .thenReturn(t);
                                })*/
                );
    }

    private Mono<TransactionResponseDTO> handleWithdraw(
            TransactionRequestDTO requestDTO,
            BigDecimal amount,
            Long accountId
    ) {

        return saveTransaction(requestDTO, accountId, TransactionStatus.PENDING)
                .flatMap(transaction ->
                        debit(accountId, amount)
                                .then(ledgerService.createEntry(accountId, transaction.id(), LedgerType.DEBIT, amount))
                                .then(saveTransaction(requestDTO, accountId, TransactionStatus.COMPLETED))
                );
    }

    private String safeJson(Object obj) {
        try {
            return objectMapper.writeValueAsString(obj);
        } catch (Exception e) {
            throw new RuntimeException("Erro ao serializar evento", e);
        }
    }

    @NotNull
    private Mono<TransactionResponseDTO> saveTransaction(
            TransactionRequestDTO requestDTO,
            Long senderAccountId,
            TransactionStatus status
    ) {

        Transaction transaction = Transaction.builder()
                .receiverAccountId(requestDTO.receiverAccountID())
                .senderAccountId(senderAccountId)
                .amount(requestDTO.amount())
                .type(TransactionType.valueOf(requestDTO.type()))
                .status(status)
                .createdAt(LocalDateTime.now())
                .build();

        return repository.save(transaction)
                .map(TransactionMapper::toResponse);
    }

    private Mono<Void> debit(Long accountId, BigDecimal amount) {
        return accountRepository.debitIfEnough(accountId, amount)
                .flatMap(row -> {

                    if (row == 0) return Mono.error(new RuntimeException("Saldo insuficiente kkk"));
                    return Mono.empty();
                });
    }

    private Mono<Void> credit(Long accountId, BigDecimal amount) {
        return accountRepository.credit(accountId, amount).then();
    }
}