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
@Table(name = "patients")  // bảng bệnh nhân
@SQLDelete(sql = "UPDATE patients SET deleted_at = NOW() WHERE id = ?")
@SQLRestriction("deleted_at IS NULL")
public class Patient {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

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
        booking.setPatient(this);
    }

    public void removeBooking(Booking booking) {
        this.bookings.remove(booking);
        booking.setPatient(null);
    }

}
