package org.example.healthcare_management.entities;

import jakarta.persistence.*;
import lombok.*;
import org.example.healthcare_management.enums.AppointmentsStatus;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.SQLDelete;
import org.hibernate.annotations.UpdateTimestamp;
import org.hibernate.annotations.Where;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Getter
@Setter
@Entity
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Table(name = "appointments")  // bảng bác sĩ
@SQLDelete(sql = "UPDATE appointments SET deleted_at = NOW() WHERE id = ?")
@Where(clause = "deleted_at IS NULL AND status = 'CONFIRMED'")
public class Appointment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "status")
    @Enumerated(EnumType.STRING)
    private AppointmentsStatus status;

    @ManyToOne(fetch = FetchType.LAZY)
    // tên cột chứa khóa phụ trong bảng bookings là time_slot_id
    // cột phụ time_slot_id sẽ dc thêm vào bảng bookings
    @JoinColumn(name = "time_slot_id")
    private TimeSlot timeSlot;

    @OneToOne(mappedBy = "appointment", cascade = CascadeType.ALL)
    private Prescription prescription; // đơn thuốc

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
    private LocalDate appointmentDate;

    @CreationTimestamp
    @Column(name = "created_at")
    private LocalTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalTime updatedAt;


    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;

    // Helper method for Doctor
    public void setDoctor(Doctor doctor) {
        if (this.doctor != null) {
            this.doctor.getAppointments().remove(this);
        }
        this.doctor = doctor;
        if (doctor != null) {
            doctor.getAppointments().add(this);
        }
    }

    // Helper method for Patient
    public void setPatient(Patient patient) {
        if (this.patient != null) {
            this.patient.getAppointments().remove(this);
        }
        this.patient = patient;
        if (patient != null) {
            patient.getAppointments().add(this);
        }
    }
}
