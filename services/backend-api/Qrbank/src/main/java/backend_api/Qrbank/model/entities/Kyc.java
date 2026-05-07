package backend_api.Qrbank.model.entities;


import backend_api.Qrbank.model.enums.KycStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

import java.sql.Date;
import java.time.LocalDateTime;

@Builder
@Data
@AllArgsConstructor
@NoArgsConstructor
@Table("kyc")
public class Kyc {

    @Id
    @Column("id")
    private Long id;

    @Column("account_id")
    private Long accountId;

    @Column("full_name")
    private String fullName;

    @Column("document_type")
    private String documentType;

    @Column("document_number")
    private String documentNumber;

    @Column("birth_date")
    private Date birthDate;

    @Column("nationality")
    private String nationality;

    @Column("document_front_url")
    private String documentFrontUrl;

    @Column("document_back_url")
    private String documentBackUrl;

    @Column("status")
    private KycStatus status;

    @Column("rejection_reason")
    private String rejectionReason;

    @Column("submitted_at")
    private LocalDateTime submittedAt;

    @Column("verified_at")
    private LocalDateTime verifiedAt;

    @Column("created_at")
    private LocalDateTime createdAt;

    @Column("updated_at")
    private LocalDateTime updatedAt;






}
