package org.example.healthcare_management.controllers;

import lombok.AllArgsConstructor;
import org.example.healthcare_management.entities.User;
import org.example.healthcare_management.repositories.UserRepo;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/")
@AllArgsConstructor
public class UserController {

    private final UserRepo userRepository;

    @GetMapping("/users/{username}")
    public ResponseEntity<User> getUserById(@PathVariable String username) {
        User user = userRepository.findByUsername(username).orElseThrow(() -> new RuntimeException("User not found: " + username));
        return ResponseEntity.ok(user);
    }

}
