package backend_api.Qrbank.service;

import backend_api.Qrbank.dto.LedgerResponseDTO;
import backend_api.Qrbank.mapper.LedgerMapper;
import backend_api.Qrbank.model.entities.Ledger;
import backend_api.Qrbank.model.enums.LedgerType;
import backend_api.Qrbank.repository.LedgerRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Service
@AllArgsConstructor
public class LedgerService {
    private final LedgerRepository repository;

    public Mono<LedgerResponseDTO> createEntry(Long accountId, Long transactionId, LedgerType type, BigDecimal amount){
        return repository.findFirstByAccountIdOrderByCreatedAtDesc(accountId)
                .map(Ledger::getBalanceAfter)
                .defaultIfEmpty(BigDecimal.ZERO)
                .flatMap(lastBalance ->{

                    BigDecimal newBalance = (type == LedgerType.DEBIT )
                            ? lastBalance.subtract(amount)
                            : lastBalance.add(amount);
                    System.out.println(newBalance+" kkkkkkkkkkkkkkkkkkkkkkksbf");
                    if (newBalance.compareTo(BigDecimal.ZERO) < 0) return Mono.error(new RuntimeException("Saldo insuficiente dddd"));

                    Ledger ledger = Ledger.builder()
                            .accountId(accountId)
                            .transactionId(transactionId)
                            .type(type)
                            .amount(amount)
                            .balanceAfter(newBalance)
                            .createdAt(LocalDateTime.now())
                            .build();

                    return repository.save(ledger).map(LedgerMapper::toResponse);
                });
    }

    public Flux<LedgerResponseDTO> getStatement(Long accountId){
        return repository.findStatement(accountId)
                .map(LedgerMapper::toResponse);
    }


}
