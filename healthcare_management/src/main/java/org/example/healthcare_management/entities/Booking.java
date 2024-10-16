package org.example.healthcare_management.entities;

import jakarta.persistence.*;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Table;
import lombok.*;
import org.example.healthcare_management.enums.BookingStatus;
import org.example.healthcare_management.enums.Gender;
import org.hibernate.annotations.*;

import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Table(name = "bookings")  // bảng bác sĩ
@SQLDelete(sql = "UPDATE bookings SET deleted_at = NOW() WHERE id = ?")
@SQLRestriction("deleted_at IS NULL")
public class Booking {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "status")
    @Enumerated(EnumType.STRING)
    private BookingStatus status;

    @ManyToOne(
            fetch = FetchType.LAZY,
            cascade = {
                    CascadeType.PERSIST,
                    CascadeType.MERGE,
                    CascadeType.REFRESH,
                    CascadeType.DETACH
            }
    )
    // tên cột chứa khóa phụ trong bảng bookings là doctor_id
    // cột phụ doctor_id sẽ dc thêm vào bảng bookings
    @JoinColumn(name = "doctor_id")
    private Doctor doctor;

    @ManyToOne(
            fetch = FetchType.LAZY,
            cascade = {
                    CascadeType.PERSIST,
                    CascadeType.MERGE,
                    CascadeType.REFRESH,
                    CascadeType.DETACH
            }
    )
    // tên cột chứa khóa phụ trong bảng bookings là patient_id
    // cột phụ patient_id sẽ dc thêm vào bảng bookings
    @JoinColumn(name = "patient_id")
    private Patient patient;

    @Column(name = "appointment_date")
    private LocalDateTime appointmentDate;

    @CreationTimestamp
    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;


    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;

    // Helper method for Doctor
    public void setDoctor(Doctor doctor) {
        if (this.doctor != null) {
            this.doctor.getBookings().remove(this);
        }
        this.doctor = doctor;
        if (doctor != null) {
            doctor.getBookings().add(this);
        }
    }

    // Helper method for Patient
    public void setPatient(Patient patient) {
        if (this.patient != null) {
            this.patient.getBookings().remove(this);
        }
        this.patient = patient;
        if (patient != null) {
            patient.getBookings().add(this);
        }
    }
}
