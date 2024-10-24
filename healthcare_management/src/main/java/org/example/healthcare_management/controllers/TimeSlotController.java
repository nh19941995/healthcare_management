package org.example.healthcare_management.controllers;

import lombok.AllArgsConstructor;
import org.example.healthcare_management.entities.TimeSlot;
import org.example.healthcare_management.repositories.TimeSlotRepo;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@AllArgsConstructor
public class TimeSlotController {
    private final TimeSlotRepo timeSlotRepo;

    @GetMapping("/timeslots")
    public List<TimeSlot> getTimeSlots() {
        return timeSlotRepo.findAll();
    }


}
