package org.example.healthcare_management.entities;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Set;

@Getter
@Setter
@Entity
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Table(name = "time_slots") // bảng vai trò
public class TimeSlot {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "start_at", nullable = false)
    private LocalDateTime startAt;

    @Column(name = "end_at", nullable = false)
    private LocalDateTime endAt;

    @OneToMany(
            mappedBy = "timeSlot",
            // chỉ áp dụng với lưu và cập nhật
            // xóa timeSlot sẽ không ảnh hưởng đến booking
            cascade = {CascadeType.PERSIST, CascadeType.MERGE}
    )
    private Set<Booking> bookings;


}
