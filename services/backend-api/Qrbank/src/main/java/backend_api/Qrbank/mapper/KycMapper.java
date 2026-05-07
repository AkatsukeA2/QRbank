package backend_api.Qrbank.mapper;

import backend_api.Qrbank.dto.KycRequestDTO;
import backend_api.Qrbank.dto.KycResponseDTO;
import backend_api.Qrbank.model.entities.Kyc;
import backend_api.Qrbank.model.enums.KycStatus;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

public class KycMapper {

    public static Kyc toEntity(KycRequestDTO requestDTO){
        return Kyc.builder()
                .id(null)
                .accountId(requestDTO.accountId())
                .fullName(requestDTO.fullName())
                .birthDate(requestDTO.birthDate())
                .documentNumber(requestDTO.documentNumber())
                .documentType(requestDTO.documentType())
                .nationality(requestDTO.nationality())
                .status(KycStatus.PENDING)
                .rejectionReason(null)
                .documentFrontUrl(requestDTO.documentFrontUrl())
                .documentBackUrl(requestDTO.documentBackUrl())
                .build();
    }

    public static KycResponseDTO toResponse(Kyc kyc){
        return KycResponseDTO.builder()
                .id(kyc.getId())
                .accountId(kyc.getAccountId())
                .fullName(kyc.getFullName())
                .documentNumber(kyc.getDocumentNumber())
                .birthDate(kyc.getBirthDate())
                .status(kyc.getStatus())
                .documentType(kyc.getDocumentType())
                .rejectionReason(kyc.getRejectionReason())
                .submittedAt(kyc.getSubmittedAt())
                .verifiedAt(kyc.getVerifiedAt())
                .build();
    }
}
