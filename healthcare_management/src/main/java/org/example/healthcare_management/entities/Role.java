package org.example.healthcare_management.entities;


import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import lombok.*;

import java.util.HashSet;
import java.util.Set;

@Getter
@Setter
@Entity
@AllArgsConstructor
@NoArgsConstructor
@Builder
@ToString(of = {"id", "name"})
@Table(name = "roles") // bảng vai trò
public class Role {
    @Id
    @GeneratedValue(strategy = jakarta.persistence.GenerationType.IDENTITY)
    private Long id;
    @Column(name = "name")
    private String name;
    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @ManyToMany(
            fetch = FetchType.LAZY,
            // tên biến của set<Role> trong entity Role
            mappedBy = "roles"
    )
    @JsonBackReference // tránh lỗi vòng lặp khi chuyển đổi sang JSON
    private Set<User> users = new HashSet<>();

    public Role(String name, String description) {
        this.name = name;
        this.description = description;
    }
}
