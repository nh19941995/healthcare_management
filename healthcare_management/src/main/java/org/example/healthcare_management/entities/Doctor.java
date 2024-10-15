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
@Table(name = "doctors")  // bảng bác sĩ
@SQLDelete(sql = "UPDATE doctors SET deleted_at = NOW() WHERE id = ?")
@SQLRestriction("deleted_at IS NULL")
public class Doctor {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(
            cascade = CascadeType.ALL,
            fetch = FetchType.LAZY,
            optional = false // thông tin bác sĩ không thể null
    )
    // tên cột chứa khóa phụ trong bảng doctors là infor_id
    // cột phụ sẽ dc thêm vào bảng doctors
    @JoinColumn(name = "infor_id")
    private User doctorInfo;

    // mappedBy trỏ tới tên biến doctors trong entity Booking
    @OneToMany(mappedBy = "doctor", cascade = {
            CascadeType.PERSIST,
            CascadeType.MERGE,
            CascadeType.REFRESH,
            CascadeType.DETACH
    }, fetch = FetchType.LAZY)
    private Set<Booking> bookings = new HashSet<>();

    @ManyToOne(
            fetch = FetchType.LAZY,
            cascade = {
                    CascadeType.PERSIST,
                    CascadeType.MERGE,
                    CascadeType.REFRESH,
                    CascadeType.DETACH
            })
    // tên cột chứa khóa phụ trong bảng doctors là clinic_id
    // cột phụ clinic_id sẽ dc thêm vào bảng doctors
    @JoinColumn(name = "clinic_id")
    private Clinic clinic;

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
            name = "doctors_patients",
            // tên cột chứa khóa phụ trong bảng trung gian của Doctor
            joinColumns = @JoinColumn(name = "doctor_id"),
            // tên cột chứa khóa phụ trong bảng trung gian của Specialization
            inverseJoinColumns = @JoinColumn(name = "patient_id")
    )
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

    @CreationTimestamp
    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;


    // Helper methods for Booking (OneToMany)
    public void addBooking(Booking booking) {
        this.bookings.add(booking);
        booking.setDoctor(this);
    }

    public void removeBooking(Booking booking) {
        this.bookings.remove(booking);
        booking.setDoctor(null);
    }

    // Helper methods for Patient (ManyToMany)
    public void addPatient(Patient patient) {
        this.patients.add(patient);
        patient.getDoctors().add(this);
    }

    public void removePatient(Patient patient) {
        this.patients.remove(patient);
        patient.getDoctors().remove(this);
    }

    // Helper methods for Specialization (ManyToMany)
    public void addSpecialization(Specialization specialization) {
        this.specializations.add(specialization);
        specialization.getDoctors().add(this);
    }

    public void removeSpecialization(Specialization specialization) {
        this.specializations.remove(specialization);
        specialization.getDoctors().remove(this);
    }

}
