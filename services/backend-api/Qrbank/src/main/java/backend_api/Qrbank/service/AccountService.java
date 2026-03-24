package backend_api.Qrbank.service;

import backend_api.Qrbank.dto.AccountRequestDTO;
import backend_api.Qrbank.dto.AccountResponseDTO;
import backend_api.Qrbank.mapper.AccountMapper;
import backend_api.Qrbank.model.Account;
import backend_api.Qrbank.model.User;
import backend_api.Qrbank.repository.AccountRepository;
import backend_api.Qrbank.repository.UserRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.time.LocalDateTime;

@Service
@AllArgsConstructor
public class AccountService {

    private final AccountRepository repository;
    private final UserRepository userRepository;

    // create account

    public Mono<AccountResponseDTO> createAccount(AccountRequestDTO requestDTO){
        return userRepository.findById(requestDTO.userId())
                .switchIfEmpty(Mono.error(new RuntimeException("User not found, cannot create account")))
                .flatMap(user -> {
                    Account account = AccountMapper.toEntity(requestDTO);
                   return repository.save(account).map(AccountMapper::toResponse);
                });
    }

    // find by id

    public Mono<AccountResponseDTO> findById(Long id){
        return repository.findById(id)
                .switchIfEmpty(Mono.error(new RuntimeException("Account not found, cannot create get it")))
                .map(AccountMapper::toResponse);

    }


    // find all
    public Flux<AccountResponseDTO> findByAll(){
        return repository.findAll().filter(account -> account.getDeletedAt() == null )
                .map(AccountMapper::toResponse);
    }

    // find by userID
    public Mono<AccountResponseDTO> findByUser(Long userId){
         return repository.findByUserId(userId)
                .switchIfEmpty(Mono.error(new RuntimeException("Account not found")))
                 .map(AccountMapper::toResponse);
    }

    // unactive account
    public Mono<AccountResponseDTO> deactivate(Long id){
        return repository.findById(id)
                .switchIfEmpty(Mono.error(new RuntimeException("Account not found, cannot deactivate")))
                .flatMap(account -> {
                    account.setActive(false);
                    return repository.save(account).map(AccountMapper::toResponse);
                });
    }

    // soft delete
    public Mono<Void> softDelete(Long id){
        return repository.findById(id)
                .switchIfEmpty(Mono.error(new RuntimeException("Account not found, cannot delete")))
                .flatMap(account -> {
                    account.setDeletedAt(LocalDateTime.now());
                    return repository.save(account);
                }).then();
    }

    // restore
    public Mono<Void> restoreAccount(Long id){
        return repository.findById(id)
                .switchIfEmpty(Mono.error(new RuntimeException("Account not found, cannot restore")))
                .flatMap(account -> {
                    account.setDeletedAt(null);
                    return repository.save(account);
                }).then();
    }

    // hard delete
    public Mono<Void> hardDelete(Long id){
        return repository.findById(id)
                .switchIfEmpty(Mono.error(new RuntimeException("Account not found")))
                .flatMap(account -> {
                    account.setDeletedAt(LocalDateTime.now());
                    return repository.deleteById(id);
                }).then();
    }







}
