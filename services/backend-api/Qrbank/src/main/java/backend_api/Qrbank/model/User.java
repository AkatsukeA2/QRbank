package backend_api.Qrbank.model;

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
@Table("user")
public class User {

    @Id
    @Column("id")
    private Long id;

    @NotBlank
    @Column("first_name")
    private String firstName;

    @NotBlank
    @Column("last_name")
    private String lastName;

    @Email
    @NotBlank
    @Column("email")
    private String email;

    @NotBlank
    @Column("phone_number")
    private String phoneNumber;

    @NotBlank
    @Column("password")
    private String passWord;

    @NotBlank
    @Column("role_id")
    private Long roleID;

    @NotBlank
    @Column("guardian_id")
    private Long guardianID;

    @NotBlank
    @Column("created_at")
    private LocalDateTime createdAt;

    @NotBlank
    @Column("updated_at")
    private LocalDateTime updatedAt;

    @NotBlank
    @Column("deleted_at")
    private LocalDateTime deletedAt;





}
