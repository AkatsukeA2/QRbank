package backend_api.Qrbank.controller;

import backend_api.Qrbank.dto.GuardianRequestDTO;
import backend_api.Qrbank.dto.GuardianResponseDTO;
import backend_api.Qrbank.dto.UserRequestDTO;
import backend_api.Qrbank.dto.UserResponseDTO;
import backend_api.Qrbank.mapper.UserMapper;
import backend_api.Qrbank.service.UserService;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@RestController
@AllArgsConstructor
@RequestMapping("/api/users")
public class UserController {

    private final UserService service;

    // create user
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Mono<ResponseEntity<UserResponseDTO>> create(@RequestBody UserRequestDTO requestDTO){
        return service.createUser(requestDTO).map(ResponseEntity::ok);
    }

    // get users by id
    @GetMapping("/{id}")
    @ResponseStatus(HttpStatus.FOUND)
    public Mono<ResponseEntity<UserResponseDTO>> getByID(@PathVariable Long id){
        return service.findByUSerID(id).map(ResponseEntity::ok);
    }

    // get all users
    @GetMapping
    @ResponseStatus(HttpStatus.FOUND)
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
    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.OK)
    public Mono<ResponseEntity<UserResponseDTO>> softDelete(@PathVariable Long id){
        return service.softDelete(id).then(Mono.just(ResponseEntity.noContent().build()));
    }

    // hard delete
    @DeleteMapping("/{id}/hard")
    @ResponseStatus(HttpStatus.OK)
    public Mono<ResponseEntity<UserResponseDTO>> hardDelete(@PathVariable Long id){
        return service.hardDelete(id).then(Mono.just(ResponseEntity.noContent().build()));
    }

    //
    @PatchMapping("/{id}/{password}")
    @ResponseStatus(HttpStatus.OK)
    public Mono<ResponseEntity<UserResponseDTO>> changePassWord(@PathVariable Long id,@PathVariable String newPassWord){
        return service.updateUserPassWor(id,newPassWord).then(Mono.just(ResponseEntity.noContent().build()));
    }




}
