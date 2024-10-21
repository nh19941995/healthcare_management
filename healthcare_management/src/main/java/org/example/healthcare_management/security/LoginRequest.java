package org.example.healthcare_management.security;

import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class LoginRequest {
    private String username;
    private String password;
}
