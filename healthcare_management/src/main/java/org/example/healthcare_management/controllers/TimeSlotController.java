package org.example.healthcare_management.controllers;

import lombok.AllArgsConstructor;
import org.example.healthcare_management.controllers.dto.UserDto;
import org.example.healthcare_management.entities.TimeSlot;
import org.example.healthcare_management.repositories.TimeSlotRepo;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;


@RestController
@AllArgsConstructor
@RequestMapping("/api/timeslots")
public class TimeSlotController {
    private final TimeSlotRepo timeSlotRepository;

    // url: localhost:8080/api/timeslots
    @GetMapping("")
    public ResponseEntity<List<TimeSlot> > getAllTimeSlots() {
        List<TimeSlot> timeSlots = timeSlotRepository.findAll();
        return ResponseEntity.ok(timeSlots);
    }



}
