package backend_api.Qrbank.service;

import backend_api.Qrbank.dto.RoleRequestDTO;
import backend_api.Qrbank.dto.RoleResponseDTO;
import backend_api.Qrbank.mapper.RoleMapper;
import backend_api.Qrbank.model.Role;
import backend_api.Qrbank.model.RoleName;
import backend_api.Qrbank.repository.RoleRepository;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.time.LocalDateTime;

@Service
public class RoleService {

    private final RoleRepository repository;

    public RoleService(RoleRepository repository) {
        this.repository = repository;
    }

    public Mono<RoleResponseDTO> createRole(RoleRequestDTO request){
        Role role = RoleMapper.toEntity(request);
        role.setCreatedAt(LocalDateTime.now());

        return repository.save(role).map(RoleMapper::toResponseDTO);

    }

    public Flux<RoleResponseDTO> getAllRoles() {
        return repository.findAll()
                .map(RoleMapper::toResponseDTO);
    }

    public Mono<RoleResponseDTO> getRoleById(Long id){
        return repository.findById(id).map(RoleMapper::toResponseDTO);

    }

    public Mono<RoleResponseDTO> updateRole(Long id, RoleRequestDTO request) {
        return repository.findById(id)
                .flatMap(existing -> {
                    existing.setRoleName(String.valueOf(request.role()));
                    existing.setDescription(request.description());
                    return repository.save(existing);
                })
                .map(RoleMapper::toResponseDTO);
    }
    // soft delete

    public Mono<Void> softDelete(Long id){
        return repository.findById(id).switchIfEmpty(Mono.error(new RuntimeException("Role not found"))).flatMap(role -> {

            role.setDeleteAt(LocalDateTime.now());
            return repository.save(role);

        }).then();

    }

    // restore role

    public Mono<Void> restoreRole(Long id){
        return repository.findById(id).switchIfEmpty(Mono.error(new RuntimeException("Role not found"))).flatMap(role -> {

            role.setDeleteAt(null);
            return repository.save(role);

        }).then();

    }
    // hard delete
    public Mono<Void> deleteRole(Long id){
        return repository.deleteById(id);
    }

    public Mono<RoleResponseDTO> getRoleByName(String roleName) {
        return repository.findByRoleName(roleName)
                .map(RoleMapper::toResponseDTO);
    }





}
