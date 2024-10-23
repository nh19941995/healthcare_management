package org.example.healthcare_management.controllers;

import lombok.extern.slf4j.Slf4j;
import org.example.healthcare_management.controllers.dto.ApiResponse;
import org.example.healthcare_management.controllers.dto.UserRegister;
import org.example.healthcare_management.entities.User;
import org.example.healthcare_management.security.AuthService;
import org.example.healthcare_management.security.JwtResponse;
import org.example.healthcare_management.controllers.dto.LoginRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/auth")
@Slf4j
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    // url: localhost:8080/auth/login
    @PostMapping("/login")
    public ResponseEntity<JwtResponse> login(@RequestBody LoginRequest loginRequest) throws Exception {
        log.info("Controller - Login request: {}", loginRequest);
        String token = authService.login(loginRequest.getUsername(), loginRequest.getPassword());
        return ResponseEntity.ok(new JwtResponse(token));
    }

    // url: localhost:8080/auth/register
    @PostMapping("/register")
    public ResponseEntity<ApiResponse> register(@RequestBody User user) {
        log.info("Controller - Register request: {}", user);
        authService.register(user);
        ApiResponse apiResponse = new ApiResponse(true, "Registration successful!");
        return ResponseEntity.status(HttpStatus.CREATED).body(apiResponse);
    }
}
