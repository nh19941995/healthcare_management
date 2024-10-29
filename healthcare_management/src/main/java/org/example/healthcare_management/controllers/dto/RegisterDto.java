package org.example.healthcare_management.controllers.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.example.healthcare_management.enums.Gender;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class RegisterDto {
    private String fullName;
    private String username;
    private String password;
    private String email;
    private String address;
    private String phone;
    private String avatar;
    private Gender gender;
    private String description;
}
