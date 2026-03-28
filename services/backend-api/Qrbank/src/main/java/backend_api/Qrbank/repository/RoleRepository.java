package backend_api.Qrbank.repository;

import backend_api.Qrbank.model.Role;
import backend_api.Qrbank.model.RoleName;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Mono;


@Repository
public interface RoleRepository extends ReactiveCrudRepository<Role, Long> {

    Mono<Role> findByRoleName(String roleName);
    //Mono<Role> findByRoleName(RoleName roleName);
}
