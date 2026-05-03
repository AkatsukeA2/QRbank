package backend_api.Qrbank.mapper;

import backend_api.Qrbank.dto.LedgerResponseDTO;
import backend_api.Qrbank.model.entities.Ledger;
import org.springframework.stereotype.Component;

@Component
public class LedgerMapper {
    public static LedgerResponseDTO toResponse(Ledger entity){
        return LedgerResponseDTO.builder()
                .id(entity.getId())
                .amount(entity.getAmount())
                .type(entity.getType())
                .description(entity.getDescription())
                .createdAt(entity.getCreatedAt())
                .balanceAfter(entity.getBalanceAfter()).build();

    }
}
