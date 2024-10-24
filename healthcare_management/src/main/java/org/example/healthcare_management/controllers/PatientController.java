package org.example.healthcare_management.controllers;

import lombok.AllArgsConstructor;
import org.example.healthcare_management.entities.Booking;
import org.example.healthcare_management.entities.Patient;
import org.example.healthcare_management.entities.TimeSlot;
import org.example.healthcare_management.entities.User;
import org.example.healthcare_management.repositories.UserRepo;
import org.example.healthcare_management.services.UserService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("api/patients")
@AllArgsConstructor
public class PatientController {
    private final UserRepo userRepository;

    @GetMapping("/addBooking")
    public String addBooking(@PathVariable String username) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found: " + username));
        Patient patient = user.getPatient();
        if (patient == null) {
            throw new RuntimeException("User is not a patient");
        }else {
            TimeSlot timeSlot = new TimeSlot();

            Booking booking = new Booking();
            booking.setPatient(patient);
        }
        return "Patients";
    }

}
