package org.example.healthcare_management.controllers;

import lombok.AllArgsConstructor;
import org.example.healthcare_management.repositories.TimeSlotRepo;
import org.springframework.web.bind.annotation.RestController;



@RestController
@AllArgsConstructor
public class TimeSlotController {
    private final TimeSlotRepo timeSlotRepo;




}
