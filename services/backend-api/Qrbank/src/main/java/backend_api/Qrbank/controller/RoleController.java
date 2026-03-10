package backend_api.Qrbank.controller;

import backend_api.Qrbank.dto.RoleRequestDTO;
import backend_api.Qrbank.dto.RoleResponseDTO;
import backend_api.Qrbank.service.RoleService;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("/api/roles")
public class RoleController {

    private final RoleService roleService;

    public RoleController(RoleService roleService) {
        this.roleService = roleService;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Mono<RoleResponseDTO> createRole(@RequestBody RoleRequestDTO request) {
        return roleService.createRole(request);
    }

    @GetMapping
    public Flux<RoleResponseDTO> getAllRoles() {
        return roleService.getAllRoles();
    }

    @GetMapping("/{name}")
    public Mono<RoleResponseDTO> getRoleByName(@PathVariable String name) {
        return roleService.getRoleByName(name);
    }

    @PutMapping("/{id}")
    public Mono<RoleResponseDTO> updateRole(
            @PathVariable Long id,
            @RequestBody RoleRequestDTO request
    ) {
        return roleService.updateRole(id, request);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public Mono<Void> deleteRole(@PathVariable Long id) {
        return roleService.deleteRole(id);
    }
}