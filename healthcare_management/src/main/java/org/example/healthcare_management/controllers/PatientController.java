package org.example.healthcare_management.controllers;

import lombok.AllArgsConstructor;
import org.example.healthcare_management.entities.Appointment;
import org.example.healthcare_management.entities.Patient;
import org.example.healthcare_management.entities.TimeSlot;
import org.example.healthcare_management.entities.User;
import org.example.healthcare_management.repositories.UserRepo;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("api/patients")
@AllArgsConstructor
public class PatientController {
    private final UserRepo userRepository;



}
