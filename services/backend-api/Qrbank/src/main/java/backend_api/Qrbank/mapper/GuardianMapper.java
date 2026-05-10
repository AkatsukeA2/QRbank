package backend_api.Qrbank.mapper;

import backend_api.Qrbank.dto.GuardianRequestDTO;
import backend_api.Qrbank.dto.GuardianResponseDTO;
import backend_api.Qrbank.model.entities.Guardian;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Component
public class GuardianMapper {

    public static GuardianResponseDTO toResponseDTO(Guardian guardian){

        return new GuardianResponseDTO(
                guardian.getId(),
                guardian.getFirstName(),
                guardian.getLastName(),
                guardian.getEmail(),
                guardian.getPhoneNumber(),
                guardian.getGuardianRelationship(),
                guardian.getCreatedAt(),
                guardian.getUpdatedAt(),
                guardian.getDeletedAt()
        );
    }

    public static Guardian toEntity(GuardianRequestDTO requestDTO){
        return Guardian.builder()
                .firstName(requestDTO.firstName())
                .lastName(requestDTO.lastName())
                .email(requestDTO.email())
                .phoneNumber(requestDTO.phoneNumber())
                .guardianRelationship(requestDTO.relationship())
                .createdAt(LocalDateTime.now())
                .build();



    }

}
