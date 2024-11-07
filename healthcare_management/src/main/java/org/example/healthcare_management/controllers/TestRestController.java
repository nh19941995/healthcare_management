package org.example.healthcare_management.controllers;

import org.example.healthcare_management.services.UserService;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class TestRestController {
    private final UserService userService;

    public TestRestController(UserService userService) {
        this.userService = userService;
    }


}
