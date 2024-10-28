package org.example.healthcare_management.entities;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;
import org.example.healthcare_management.enums.Status;
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
@Table(name = "doctors")  // bảng bác sĩ
@SQLDelete(sql = "UPDATE doctors SET deleted_at = NOW() WHERE id = ?")
@SQLRestriction("deleted_at IS NULL")
public class Doctor {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @JsonIgnore
    @OneToOne(
            cascade = {CascadeType.PERSIST, CascadeType.MERGE}
    )
    // tên cột chứa khóa phụ trong bảng doctors là user_id
    // cột phụ sẽ dc thêm vào bảng doctors
    @JoinColumn(name = "user_id")
    private User user;

    @Column(name = "achievements")
    private String achievements;

    @Column(name = "medical_training")
    private String medicalTraining;

    @JsonIgnore
    // mappedBy trỏ tới tên biến doctors trong entity Booking
    @OneToMany(mappedBy = "doctor", cascade = {
            CascadeType.PERSIST,
            CascadeType.MERGE,
            CascadeType.REFRESH,
            CascadeType.DETACH
    }, fetch = FetchType.LAZY)
    private Set<Appointment> appointments = new HashSet<>();

    @JsonIgnore
    @ManyToOne(fetch = FetchType.EAGER)
    // tên cột chứa khóa phụ trong bảng doctors là clinic_id
    // cột phụ clinic_id sẽ dc thêm vào bảng doctors
    @JoinColumn(name = "clinic_id")
    private Clinic clinic;

    @JsonIgnore
    @ManyToOne(fetch = FetchType.EAGER)
    // tên cột chứa khóa phụ trong bảng doctors là specialization_id
    // cột phụ specialization_id sẽ dc thêm vào bảng doctors
    @JoinColumn(name = "specialization_id")
    private Specialization specialization;


    @Column(name = "status")
    @Enumerated(EnumType.STRING)
    private Status status;

    @Column(name = "lock_reason")
    private String lockReason;

    @CreationTimestamp
    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;


    // Helper methods for Booking (OneToMany)
    public void addAppointment(Appointment appointment) {
        this.appointments.add(appointment);
        appointment.setDoctor(this);
    }

    public void removeAppointment(Appointment appointment) {
        this.appointments.remove(appointment);
        appointment.setDoctor(null);
    }

    @Override
    public String toString() {
        return "Doctor{" +
                "id=" + id +
                ", user=" + user.getId() +
                ", achievements='" + achievements + '\'' +
                ", medicalTraining='" + medicalTraining + '\'' +
                ", clinic=" + clinic.getId() +
                ", specialization=" + specialization.getId() +
                ", status=" + status +
                ", lockReason='" + lockReason + '\'' +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                ", deletedAt=" + deletedAt +
                '}';
    }
}
