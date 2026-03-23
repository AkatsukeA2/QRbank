package backend_api.Qrbank.mapper;

import backend_api.Qrbank.dto.UserRequestDTO;
import backend_api.Qrbank.dto.UserRespondDTO;
import backend_api.Qrbank.model.User;

import java.time.LocalDateTime;

public class UserMapper {

    public static UserRespondDTO toRespondDTO(User user){
       return new UserRespondDTO(
               user.getId(),
               user.getFirstName(),
               user.getLastName(),
               user.getEmail(),
               user.getPassWord(),
               user.getPhoneNumber(),
               user.getRoleID(),
               user.getGuardianID(),
               user.getCreatedAt(),
               user.getUpdatedAt(),
               user.getDeletedAt()
       );
    }

    public static User toEntity(UserRequestDTO requestDTO){
        return new User(
                null,
                requestDTO.fistName(),
                requestDTO.lastName(),
                requestDTO.email(),
                requestDTO.phoneNumber(),
                requestDTO.passWord(),
                requestDTO.roleId(),
                requestDTO.guardianID(),
                LocalDateTime.now(),
                null,
                null

        );
    }
}
