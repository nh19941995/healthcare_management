package org.example.healthcare_management.entities;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
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
@Table(name = "patients")  // bảng bệnh nhân
public class Patient {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;


    @ManyToMany(
            fetch = FetchType.LAZY,
            cascade = {
                    CascadeType.PERSIST,
                    CascadeType.MERGE,
                    CascadeType.REFRESH,
                    CascadeType.DETACH
            },
            // tên biến của set<Patient> trong entity Doctor
            mappedBy = "patients"
    )
    // tên biến authors trong entity Book
    private Set<Doctor> doctors = new HashSet<>();

    @OneToOne(
            cascade = CascadeType.ALL,
            fetch = FetchType.LAZY,
            optional = false // thông tin bệnh nhân không thể null
    )
    // tên cột chứa khóa phụ trong bảng wife là user_Id
    // cột phụ sẽ dc thêm vào bảng patients
    @JoinColumn(name = "user_Id")
    private User user;

    // mappedBy trỏ tới tên biến patient trong entity booking
    @OneToMany(
            mappedBy = "patient",
            cascade = {
                    CascadeType.PERSIST,
                    CascadeType.MERGE,
                    CascadeType.REFRESH,
                    CascadeType.DETACH
            }, fetch = FetchType.LAZY
    )
    private Set<Booking> bookings = new HashSet<>();


    @ManyToOne(
            fetch = FetchType.LAZY,
            cascade = {
                    CascadeType.PERSIST,
                    CascadeType.MERGE,
                    CascadeType.REFRESH,
                    CascadeType.DETACH
            }
    )
    // tên cột chứa khóa phụ trong bảng user là status_id
    // cột phụ role_id sẽ dc thêm vào bảng user
    @JoinColumn(name = "status_id")
    private PatientStatus status;

    @CreationTimestamp
    @Column(name = "createdAt")
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updatedAt")
    private LocalDateTime updatedAt;

    @Column(name = "deletedAt")
    private LocalDateTime deletedAt;

    // Helper methods for Doctor (ManyToMany)
    public void addDoctor(Doctor doctor) {
        this.doctors.add(doctor);
        doctor.getPatients().add(this);
    }

    public void removeDoctor(Doctor doctor) {
        this.doctors.remove(doctor);
        doctor.getPatients().remove(this);
    }

    // Helper methods for Booking (OneToMany)
    public void addBooking(Booking booking) {
        this.bookings.add(booking);
        booking.setPatient(this);
    }

    public void removeBooking(Booking booking) {
        this.bookings.remove(booking);
        booking.setPatient(null);
    }

}
