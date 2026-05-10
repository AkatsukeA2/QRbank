package backend_api.Qrbank.service;

import backend_api.Qrbank.model.enums.EventStatus;
import backend_api.Qrbank.repository.OutboxEventRepository;
import lombok.AllArgsConstructor;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
public class OutboxServer {

    private final OutboxEventRepository repository;
    private final KafkaTemplate<String, String> kafkaTemplate;

    @Scheduled(fixedDelay = 2000)
    public void publishEvents() {

        repository.findByStatus("PENDING")
                .flatMap(event -> {

                    kafkaTemplate.send(
                            "ledger.transactions",
                            event.getAggregateId().toString(),
                            event.getPayload()
                    );

                    event.setStatus(EventStatus.SENT);

                    return repository.save(event);
                })
                .subscribe();
    }
}