package org.example.healthcare_management.entities;

import jakarta.persistence.*;
import lombok.*;
import org.example.healthcare_management.enums.Gender;
import org.example.healthcare_management.enums.Status;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Table(name = "users") // bảng người dùng
@ToString
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "name")
    private String name;

    @Column(name = "username")
    private String username;

    @Column(name = "email")
    private String email;

    @Column(name = "password")
    private String password;

    @Column(name = "address")
    private String address;

    @Column(name = "phone")
    private String phone;

    @Column(name = "avatar")
    private String avatar;

    @Column(name = "gender")
    @Enumerated(EnumType.STRING)
    private Gender gender;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @ManyToOne(fetch = FetchType.EAGER)
    // tên cột chứa khóa phụ trong bảng user là role_id
    // cột phụ role_id sẽ dc thêm vào bảng user
    @JoinColumn(name = "role_id")
    private Role role;

    @CreationTimestamp
    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;

    @Column(name = "status")
    @Enumerated(EnumType.STRING)
    private Status status;

    @Column(name = "lock_reason")
    private String lockReason;

    public User(
            String name,
            String email,
            String password,
            String address,
            String phone,
            Gender gender,
            String description
    ) {
        this.name = name;
        this.email = email;
        this.password = password;
        this.address = address;
        this.phone = phone;
        this.gender = gender;
        this.description = description;
    }
}

