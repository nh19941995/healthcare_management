package org.example.healthcare_management.entities;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@Getter
@Setter
@Entity
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Table(name = "doctors")
public class Doctor {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(
            cascade = CascadeType.ALL,
            fetch = FetchType.LAZY
    )
    // tên cột chứa khóa phụ trong bảng doctors là infor_id
    // cột phụ sẽ dc thêm vào bảng doctors
    @JoinColumn(name = "infor_id")
    private User doctorInfo;

    @Column(name = "clinicId")
    private Integer clinicId;

    // mappedBy trỏ tới tên biến doctors trong entity Specialization
    @OneToMany(mappedBy = "doctor", cascade = {
            CascadeType.PERSIST,
            CascadeType.MERGE,
            CascadeType.REFRESH,
            CascadeType.DETACH
    }, fetch = FetchType.LAZY)
    private Set<Patient> patients = new HashSet<>();

    @ManyToMany(
            fetch = FetchType.LAZY,
            cascade = {
                    CascadeType.PERSIST,
                    CascadeType.MERGE,
                    CascadeType.REFRESH,
                    CascadeType.DETACH
            }
    )
    @JoinTable(
            // tên bảng trung gian
            name = "doctors_specialization",
            // tên cột chứa khóa phụ trong bảng trung gian của Doctor
            joinColumns = @JoinColumn(name = "doctor_id"),
            // tên cột chứa khóa phụ trong bảng trung gian của Specialization
            inverseJoinColumns = @JoinColumn(name = "specialization_id")
    )
    private Set<Specialization> specializations = new HashSet<>();

    @Column(name = "createdAt")
    private LocalDateTime createdAt;

    @Column(name = "updatedAt")
    private LocalDateTime updatedAt;

    @Column(name = "deletedAt")
    private LocalDateTime deletedAt;
}
