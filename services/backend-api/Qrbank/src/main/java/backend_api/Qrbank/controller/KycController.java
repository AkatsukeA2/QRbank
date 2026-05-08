package backend_api.Qrbank.controller;

import backend_api.Qrbank.dto.KycRequestDTO;
import backend_api.Qrbank.dto.KycResponseDTO;
import backend_api.Qrbank.service.KycService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("/api/kyc")
@RequiredArgsConstructor
public class KycController {

    private final KycService service;

    @PostMapping("/{accountId}")
    public Mono<KycResponseDTO> submit(
            @PathVariable Long accountId,
            @RequestBody KycRequestDTO dto) {

        return service.submitKyc(accountId, dto);
    }

    @GetMapping("/{accountId}")
    public Mono<KycResponseDTO> find(
            @PathVariable Long accountId) {

        return service.findByAccount(accountId);
    }

    @PatchMapping("/{accountId}/verify")
    public Mono<KycResponseDTO> verify(
            @PathVariable Long accountId) {

        return service.verifyKyc(accountId);
    }

    @PatchMapping("/{accountId}/reject")
    public Mono<KycResponseDTO> reject(
            @PathVariable Long accountId,
            @RequestParam String reason) {

        return service.rejectKyc(accountId, reason);
    }
}
