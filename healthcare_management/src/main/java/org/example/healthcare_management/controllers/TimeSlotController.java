package org.example.healthcare_management.controllers;

import lombok.AllArgsConstructor;
import org.example.healthcare_management.repositories.TimeSlotRepo;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;



@RestController
@AllArgsConstructor
@RequestMapping("/api/timeslots")
public class TimeSlotController {
    private final TimeSlotRepo timeSlotRepo;

    @GetMapping("")
    public String getAllTimeSlots() {
        return "All time slots";
    }



}
