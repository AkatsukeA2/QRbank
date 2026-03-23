package backend_api.Qrbank.service;

import backend_api.Qrbank.dto.UserRequestDTO;
import backend_api.Qrbank.dto.UserResponseDTO;
import backend_api.Qrbank.mapper.UserMapper;
import backend_api.Qrbank.model.User;
import backend_api.Qrbank.repository.GuardianRepository;
import backend_api.Qrbank.repository.RoleRepository;
import backend_api.Qrbank.repository.UserRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.time.LocalDateTime;

@Service
@AllArgsConstructor
public class UserService {

    private final UserRepository repository;
    private final RoleRepository roleRepository;
    private final GuardianRepository guardianRepository;



    // create user

    public Mono<UserResponseDTO> createUser(UserRequestDTO requestDTO){

        User user = UserMapper.toEntity(requestDTO);


        if (user.getRoleID() == null) {
            return Mono.error(new RuntimeException("RoleId is required"));
        }

        return roleRepository.findById(user.getRoleID())
                .switchIfEmpty(Mono.error(new RuntimeException("Role not found")))
                .flatMap(role -> {


                    if (user.getGuardianID() != null) {
                        return guardianRepository.findById(user.getGuardianID())
                                .switchIfEmpty(Mono.error(new RuntimeException("Guardian not found")))
                                .then(repository.save(user)
                                        .map(UserMapper::toResponseDTO));
                    }

                    return repository.save(user)
                            .map(UserMapper::toResponseDTO);
                });
    }

    // find by user id
    public Mono<UserResponseDTO> findByUSerID(Long id){
        return repository.findById(id).filter(user -> user.getDeletedAt() == null)
                .switchIfEmpty(Mono.error(new RuntimeException("USer not found"))).map(UserMapper::toResponseDTO);
    }

    // find all users
    public Flux<UserResponseDTO> findAllUser(){
        return repository.findAll()
                .filter(user -> user.getDeletedAt() == null).map(UserMapper::toResponseDTO);
    }

    //update user
    public Mono<UserResponseDTO> updateUser(Long id, UserRequestDTO requestDTO){
        return repository.findById(id).filter(user -> user.getDeletedAt() == null)
                .switchIfEmpty(Mono.error(new RuntimeException("User not found")))
                .flatMap(user -> {
                    user.setFirstName(requestDTO.firstName());
                    user.setLastName(requestDTO.lastName());
                    user.setEmail(requestDTO.email());
                    user.setPassword(requestDTO.password());
                    user.setPhoneNumber(requestDTO.phoneNumber());
                    user.setRoleID(requestDTO.roleId());
                    user.setGuardianID(requestDTO.guardianID());
                    user.setUpdatedAt(LocalDateTime.now());
                    return repository.save(user).map(UserMapper::toResponseDTO);
                });
    }

    //update password
    public Mono<UserResponseDTO> updateUserPassWor(Long id, String newPassWord){
        return repository.findById(id).filter(user -> user.getDeletedAt() == null)
                .switchIfEmpty(Mono.error(new RuntimeException("User not found")))
                .flatMap(user -> {

                    user.setPassword(newPassWord);
                    user.setUpdatedAt(LocalDateTime.now());
                    return repository.save(user).map(UserMapper::toResponseDTO);
                });
    }

    // soft delete
    public Mono<Void> softDelete(Long id){
        return repository.findById(id).switchIfEmpty(Mono.error(new RuntimeException("User not found")))
                .flatMap(user -> {

                    user.setDeletedAt(LocalDateTime.now());
                    return repository.save(user);
                }).then();
    }

    // restore
    public Mono<Void> restoreUser(Long id){
        return repository.findById(id).switchIfEmpty(Mono.error(new RuntimeException("User not found")))
                .flatMap(user -> {

                    user.setDeletedAt(null);
                    return repository.save(user);
                }).then();
    }

    // hard delete
    public Mono<Void> hardDelete(Long id){
        return repository.deleteById(id);

    }
}
