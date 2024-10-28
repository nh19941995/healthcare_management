package org.example.healthcare_management.entities;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.SQLDelete;
import org.hibernate.annotations.SQLRestriction;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@Getter
@Setter
@Entity
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Table(name = "prescriptions")  // bảng đơn thuốc
@SQLDelete(sql = "UPDATE prescriptions SET deleted_at = NOW() WHERE id = ?")
@SQLRestriction("deleted_at IS NULL")
public class Prescription {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "description", columnDefinition = "TEXT")
    private String medicalDiagnosis;

    @OneToOne(
            cascade = CascadeType.ALL,
            optional = false // thông tin bệnh nhân không thể null
    )
    // tên cột chứa khóa phụ trong bảng medical_records là booking_id
    // cột phụ sẽ dc thêm vào bảng medical_records
    @JoinColumn(name = "booking_id")
    private Appointment appointment;

    @OneToMany(
            mappedBy = "prescription",
            // chỉ áp dụng với lưu và cập nhật
            // xóa teacher sẽ không ảnh hưởng đến student
            cascade = {CascadeType.PERSIST, CascadeType.MERGE},
            fetch = FetchType.LAZY
    )
    Set<Medication> medications = new HashSet<>();

    @CreationTimestamp
    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;
}
