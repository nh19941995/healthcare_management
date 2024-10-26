package org.example.healthcare_management.controllers.dto;


import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.example.healthcare_management.entities.Doctor;
import org.example.healthcare_management.entities.Patient;
import org.example.healthcare_management.entities.Role;
import org.example.healthcare_management.enums.Gender;
import org.example.healthcare_management.enums.Status;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class UserDto {
    private Long id;

    private String fullName;

    private String username;

    private String email;

    private String address;

    private String phone;

    private String avatar;

    private Gender gender;

    private String description;

    private Set<Role> roles = new HashSet<>();

    private Doctor doctor;

    private Patient patient;

    private LocalDateTime createdAt;

    private Status status;

    private String lockReason;

}
