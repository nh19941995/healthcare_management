package org.example.healthcare_management.entities;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.SQLDelete;
import org.hibernate.annotations.SQLRestriction;

import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Table(name = "medications")  // dữ liệu thuốc
@SQLDelete(sql = "UPDATE medications SET deleted_at = NOW() WHERE id = ?")
@SQLRestriction("deleted_at IS NULL")
public class Medication {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "name", nullable = false)
    private String name; // tên thuốc

    @Column(name = "type", nullable = false)
    private String type; // loại thuốc

    @Column(name = "manufacturer", nullable = false)
    private String manufacturer; // nhà sản xuất

    @Column(name = "dosage", nullable = false)
    private String dosage; // liều lượng

    @Column(name = "instructions", nullable = false)
    private String instructions; // hướng dẫn sử dụng

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;

    @ManyToOne(fetch = FetchType.LAZY)
    // tên cột chứa khóa phụ trong bảng medications là prescription_id
    // cột phụ prescription_id sẽ dc thêm vào bảng medications
    @JoinColumn(name = "prescription_id")
    private Prescription prescription;


}
