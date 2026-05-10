package backend_api.Qrbank.repository;


import backend_api.Qrbank.model.entities.OutboxEvent;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Mono;

public interface OutboxEventRepository extends ReactiveCrudRepository<OutboxEvent, Long> {
    @Query("""
    DELETE FROM outbox_event
    WHERE status = 'SENT'
    AND created_at < NOW() - INTERVAL 2 DAY
""")
    Mono<Void> deleteOld();

    Mono<OutboxEvent> findByStatus(String pending);
}
