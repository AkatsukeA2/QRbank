package backend_api.Qrbank.controller;

import backend_api.Qrbank.dto.GuardianRequestDTO;
import backend_api.Qrbank.dto.GuardianResponseDTO;
import backend_api.Qrbank.dto.UserRequestDTO;
import backend_api.Qrbank.dto.UserResponseDTO;
import backend_api.Qrbank.mapper.UserMapper;
import backend_api.Qrbank.service.EmailService;
import backend_api.Qrbank.service.UserService;
import jakarta.validation.constraints.Email;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.math.BigDecimal;

@RestController
@AllArgsConstructor
@RequestMapping("/api/users")
public class UserController {

    private final UserService service;
    private final EmailService emailService;

    // create user
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Mono<ResponseEntity<UserResponseDTO>> create(@RequestBody UserRequestDTO requestDTO){
        return service.createUser(requestDTO).map(ResponseEntity::ok);
    }

    // get users by id
    @GetMapping("/{id}")
    public Mono<ResponseEntity<UserResponseDTO>> getByID(@PathVariable Long id){
        return service.findByUserID(id).map(ResponseEntity::ok);
    }
    // get users by id
    @GetMapping("/email/{email}")  // <-- mude para /email/{email}
    public Mono<ResponseEntity<UserResponseDTO>> getByEmail(@PathVariable String email){
        return service.findByUserEmail(email).map(ResponseEntity::ok);
    }

    // get all users
    @GetMapping
    public Flux<UserResponseDTO> getAllUsers(){
        return service.findAllUser();
    }

    // update user
    @PutMapping("/{id}")
    @ResponseStatus(HttpStatus.OK)
    public Mono<ResponseEntity<UserResponseDTO>> updateUser(@PathVariable Long id, @RequestBody UserRequestDTO requestDTO){
        return service.updateUser(id,requestDTO).map(ResponseEntity::ok);
    }

    //soft delete
    @PatchMapping("/{id}")
    @ResponseStatus(HttpStatus.OK)
    public Mono<ResponseEntity<UserResponseDTO>> softDelete(@PathVariable Long id){
        return service.softDelete(id).then(Mono.just(ResponseEntity.noContent().build()));
    }

    // restore
    @PatchMapping("/{id}/restore")
    @ResponseStatus(HttpStatus.OK)
    public Mono<Void> restore(@PathVariable Long id){
        return service.restoreUser(id).then();
    }

    // hard delete
    @DeleteMapping("/{id}/hard")
    @ResponseStatus(HttpStatus.OK)
    public Mono<Void> hardDelete(@PathVariable Long id){
        return service.hardDelete(id).then();
    }

    //
    @PatchMapping("/{id}/newPassWord")
    @ResponseStatus(HttpStatus.OK)
    public Mono<ResponseEntity<UserResponseDTO>> changePassWord(@PathVariable Long id,@RequestBody String newPassWord){
        return service.updateUserPassWor(id,newPassWord).then(Mono.just(ResponseEntity.noContent().build()));
    }

    //
    @PatchMapping("/{id}/newEmail")
    @ResponseStatus(HttpStatus.OK)
    public Mono<ResponseEntity<UserResponseDTO>> changeEmail(@PathVariable Long id,@RequestBody String newEmail){
        return service.updateUserEmail(id,newEmail).then(Mono.just(ResponseEntity.noContent().build()));
    }

    @GetMapping("/test-email")
    public Mono<String> test() {
        return emailService
                .sendEmail(
                        "francneto745@gmail.com",
                        "Teste QRbank",
                        "O QRbank da-te as boas vindas cliente Bicho neto"
                )
                .thenReturn("Email enviado");
    }
    @GetMapping("/grid")
    public Mono<String> grid(
            @RequestParam String email,
            @RequestParam String name) {
        return emailService
                .sendEmail(email.trim(), "Boas-vindas ao QRbank",
                        "O QRbank dá-te as boas-vindas, " + name + "!")
                .thenReturn("Email enviado");
    }

    @GetMapping("/control")
    public Mono<String> control(@RequestBody String email, String senderName, String receiverName, BigDecimal amount) {
        return emailService
                .sendEmail(
                        email.trim(),
                        "Email de Controle",
                        "Caro Cliente viemos informar que o seu dependente "+senderName+" efetuou uma transação no valor de "+amount+" ao "+receiverName
                )
                .thenReturn("Email enviado");
    }



}
