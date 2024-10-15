package org.example.healthcare_management.entities;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@Entity
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Table(name = "PatientStatus") // bảng trạng thái bệnh nhân
public class PatientStatus {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "status")
    private String status;

    @Column(name = "description")
    private String description;

    public PatientStatus(String status, String description) {
        this.status = status;
        this.description = description;
    }
}
