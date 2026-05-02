package backend_api.Qrbank.model.entities;

import backend_api.Qrbank.model.Model;
import backend_api.Qrbank.model.enums.GuardianRelationship;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Table("guardians")
public class Guardian extends Model {

    @NotBlank
    @Column("first_name")
    private String firstName;

    @NotBlank
    @Column("last_name")
    private String lastName;

    @NotBlank
    @Email
    @Column("email")
    private String email;

    @NotBlank
    @Column("phone_number")
    private String phoneNumber;

    @NotBlank
    @Column("relationship")
    private GuardianRelationship guardianRelationship;

    public Guardian(Long id, @NotBlank String firstName, @NotBlank String lastName, @NotBlank @Email String email, @NotBlank String phoneNumber, @NotBlank GuardianRelationship relationship, LocalDateTime now, LocalDateTime updatedAt, LocalDateTime deletedAt) {
    }
}
