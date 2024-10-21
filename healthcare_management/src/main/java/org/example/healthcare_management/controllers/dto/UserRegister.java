package org.example.healthcare_management.controllers.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.example.healthcare_management.entities.User;
import org.example.healthcare_management.enums.Gender;

@Getter
@Setter
@AllArgsConstructor
@ToString
public class UserRegister {
    @NotBlank(message = "Username is required")
    private String username;

    @NotBlank(message = "Password is required")
    @Size(min = 8, message = "Password must be at least 8 characters long")
    private String password;

    @NotBlank(message = "Gender is required")
    private String gender;

    @Email(message = "Invalid email format")
    private String email;

    private String phone;
    private String address;
    private String fullName;
    private String roleName;
    private String description;

    public User toUser() {
        return User.builder()
                .username(username)
                .password(password)
                .gender(Gender.fromString(gender))
                .email(email)
                .phone(phone)
                .address(address)
                .name(fullName)
                .description(description)
                .build();
    }
}
