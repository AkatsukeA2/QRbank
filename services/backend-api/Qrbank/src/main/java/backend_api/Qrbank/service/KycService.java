package backend_api.Qrbank.service;

import backend_api.Qrbank.dto.KycRequestDTO;
import backend_api.Qrbank.dto.KycResponseDTO;
import backend_api.Qrbank.mapper.KycMapper;
import backend_api.Qrbank.model.entities.Kyc;
import backend_api.Qrbank.model.enums.KycStatus;
import backend_api.Qrbank.repository.AccountRepository;
import backend_api.Qrbank.repository.GuardianRepository;
import backend_api.Qrbank.repository.KycRepository;
import backend_api.Qrbank.repository.UserRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

import java.sql.Date;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Period;

@Service
@AllArgsConstructor
public class KycService {

    private final KycRepository repository;
    private final AccountRepository accountRepository;
    private final GuardianRepository guardianRepository;
    private final UserRepository userRepository;



    public Mono<KycResponseDTO> submitKyc(Long accountId, KycRequestDTO requestDTO){
        return accountRepository.findById(accountId)
                .switchIfEmpty(Mono.error(new RuntimeException("Account not found")))
                .flatMap(account ->{
                    if (isMinor(requestDTO.birthDate())){
                        return userRepository.findById(account.getUserId())
                                .switchIfEmpty(Mono.error(new RuntimeException("User not found")))
                                .flatMap(user ->
                                        guardianRepository.findById(user.getGuardianID())
                                                .switchIfEmpty(
                                                        Mono.error(new RuntimeException("Guardian required for minors"))
                                                ).then(processKyc(accountId,requestDTO))

                                );

                    }
                    return processKyc(accountId,requestDTO);
                });
    }

    public Mono<KycResponseDTO> findByAccount(Long accountId){
        return repository.findByAccountId(accountId)
                .switchIfEmpty(Mono.error(new RuntimeException("KYC not found")))
                .map(KycMapper::toResponse);
    }

    public Mono<KycResponseDTO> verifyKyc(Long accountId){
        return repository.findByAccountId(accountId)
                .switchIfEmpty(Mono.error(new RuntimeException("KYC not found")))
                .flatMap(kyc ->{
                    if (kyc.getStatus() != KycStatus.SUBMITTED) return Mono.error( new RuntimeException("KYC is not in submitted state"));


                    kyc.setStatus(KycStatus.VERIFIED);
                    kyc.setVerifiedAt(LocalDateTime.now());

                    return accountRepository.findById(accountId)
                                            .switchIfEmpty(Mono.error(new RuntimeException("Account not found")))
                                            .flatMap(account ->{
                                                account.setActive(true);
                                                return accountRepository.save(account)
                                                        .then(repository.save(kyc))
                                                        .map(KycMapper::toResponse);
                                            });

                });
    }

    public Mono<KycResponseDTO> rejectKyc(Long accountId, String reason){

        return repository.findByAccountId(accountId)
                .switchIfEmpty(Mono.error(new RuntimeException("KYC not found")))
                .flatMap(kyc ->{
                    if (kyc.getStatus() != KycStatus.SUBMITTED) return Mono.error(new RuntimeException("KYC cannot be rejected"));

                    kyc.setStatus(KycStatus.REJECTED);
                    kyc.setRejectionReason(reason);
                    kyc.setVerifiedAt(null);

                    return accountRepository.findById(accountId)
                            .switchIfEmpty(Mono.error(new RuntimeException("Account not found")))
                            .flatMap(account ->{
                                account.setActive(false);
                                return accountRepository.save(account)
                                        .then(repository.save(kyc))
                                        .map(KycMapper::toResponse);
                            });

                });
    }










    private boolean isMinor(LocalDate date){
        return Period.between(date, LocalDate.now()).getYears() < 18;
    }

    private Mono<KycResponseDTO> processKyc(Long accountId, KycRequestDTO dto) {

        return repository.findByAccountId(accountId)
                .flatMap(existingKyc -> {

                    // Não permitir alteração se já estiver VERIFIED
                    if (existingKyc.getStatus() == KycStatus.VERIFIED) {
                        return Mono.error(
                                new RuntimeException("KYC already verified")
                        );
                    }

                    // Atualiza dados (re-submissão)
                    existingKyc.setFullName(dto.fullName());
                    existingKyc.setBirthDate(dto.birthDate());
                    existingKyc.setDocumentNumber(dto.documentNumber());
                    existingKyc.setDocumentType(dto.documentType());
                    existingKyc.setNationality(dto.nationality());
                    existingKyc.setDocumentFrontUrl(dto.documentFrontUrl());
                    existingKyc.setDocumentBackUrl(dto.documentBackUrl());

                    existingKyc.setStatus(KycStatus.SUBMITTED);
                    existingKyc.setSubmittedAt(LocalDateTime.now());
                    existingKyc.setRejectionReason(null);

                    return repository.save(existingKyc);
                })
                .switchIfEmpty(
                        repository.save(
                                Kyc.builder()
                                        .accountId(accountId)
                                        .fullName(dto.fullName())
                                        .birthDate(dto.birthDate())
                                        .documentNumber(dto.documentNumber())
                                        .documentType(dto.documentType())
                                        .nationality(dto.nationality())
                                        .documentFrontUrl(dto.documentFrontUrl())
                                        .documentBackUrl(dto.documentBackUrl())
                                        .status(KycStatus.SUBMITTED)
                                        .submittedAt(LocalDateTime.now())
                                        .build()
                        )
                ).map(KycMapper::toResponse);
    }
}
