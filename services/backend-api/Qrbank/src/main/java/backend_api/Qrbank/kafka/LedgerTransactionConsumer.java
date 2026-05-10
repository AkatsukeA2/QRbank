/*package backend_api.Qrbank.kafka;

import backend_api.Qrbank.event.LedgerTransactionEvent;
import backend_api.Qrbank.model.entities.Guardian;
import backend_api.Qrbank.repository.GuardianRepository;
import backend_api.Qrbank.repository.UserRepository;
import backend_api.Qrbank.service.EmailService;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

import java.time.LocalDate;
import java.time.Period;

@Service
@RequiredArgsConstructor
public class LedgerTransactionConsumer {

    private final EmailService emailService;
    private final UserRepository userRepository;
    private final GuardianRepository guardianRepository;
    private final ObjectMapper objectMapper;

    @KafkaListener(
            topics = "ledger.transactions",
            groupId = "qrbank-notification"
    )
    public void consume(String eventJson) {

        try {
            LedgerTransactionEvent event =
                    objectMapper.readValue(eventJson, LedgerTransactionEvent.class);

            System.out.println("EVENTO RECEBIDO: " + event);

            findGuardianEmail(event.userId())
                    .flatMap(email ->
                            emailService.sendEmail(
                                    email,
                                    "QRbank Alert - Transaction",
                                    buildMessage(event)
                            )
                    )
                    .subscribe();

        } catch (Exception e) {
            System.err.println("Erro ao desserializar evento: " + e.getMessage());
        }
    }

    private Mono<String> findGuardianEmail(Long userId) {

        return userRepository.findById(userId)
                .switchIfEmpty(Mono.error(new RuntimeException("User not found")))
                .flatMap(user -> {

                    boolean isMinor = Period.between(
                            user.getDateOfBirth(),
                            LocalDate.now()
                    ).getYears() < 18;

                    if (isMinor) {

                        if (user.getGuardianID() == null) {
                            return Mono.error(new RuntimeException("Minor must have guardian"));
                        }

                        return guardianRepository.findById(user.getGuardianID())
                                .switchIfEmpty(Mono.error(new RuntimeException("Guardian not found")))
                                .map(Guardian::getEmail);
                    }

                    return Mono.just(user.getEmail());
                });
    }

    private String buildMessage(LedgerTransactionEvent event) {
        return """
                Transaction Alert:

                Type: %s
                Amount: %s
                Status: %s
                Account: %s

                Transaction ID: %s
                """.formatted(
                event.type(),
                event.amount(),
                event.status(),
                event.accountId(),
                event.transactionId()
        );
    }
}*/