package org.example.healthcare_management.controllers;

import org.example.healthcare_management.repositories.UserRepo;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class UserController {

    private final UserRepo userRepository;

    public UserController(UserRepo userRepository) {
        this.userRepository = userRepository;
    }


}
