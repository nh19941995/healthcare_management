package org.example.healthcare_management.entities;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.SQLDelete;
import org.hibernate.annotations.SQLRestriction;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Table(name = "schedules")  // bảng bác sĩ
@SQLDelete(sql = "UPDATE schedules SET deleted_at = NOW() WHERE id = ?")
@SQLRestriction("deleted_at IS NULL")
public class Schedule {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(
            fetch = FetchType.LAZY,
            cascade = {
                    CascadeType.PERSIST,
                    CascadeType.MERGE,
                    CascadeType.REFRESH,
                    CascadeType.DETACH
            }
    )
    // tên cột chứa khóa phụ trong bảng schedule là doctor_id
    // cột phụ doctor_id sẽ dc thêm vào bảng schedule
    @JoinColumn(name = "doctor_id")
    private Doctor doctor;

    @Column(name = "time")
    private LocalDateTime time;

    @Column(name = "max_booking")
    private Integer maxBooking;

    @Column(name = "sum_booking")
    private Integer sumBooking;

    @CreationTimestamp
    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;
}
