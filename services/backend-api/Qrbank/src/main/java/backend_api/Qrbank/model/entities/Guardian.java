package backend_api.Qrbank.model.entities;

import backend_api.Qrbank.model.Model;
import backend_api.Qrbank.model.enums.GuardianRelationship;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

import java.time.LocalDateTime;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Table("guardians")
public class Guardian {

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

    @NotNull
    @Column("relationship")
    private GuardianRelationship guardianRelationship;

    @Id
    @NotBlank
    @Column("id")
    protected Long id;

    @NotBlank
    @Column("created_at")
    protected LocalDateTime createdAt;

    @NotBlank
    @Column("updated_at")
    protected LocalDateTime updatedAt;

    @NotBlank
    @Column("deleted_at")
    protected LocalDateTime deletedAt;

}
