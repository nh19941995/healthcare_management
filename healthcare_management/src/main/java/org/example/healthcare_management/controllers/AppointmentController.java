package org.example.healthcare_management.controllers;

import lombok.AllArgsConstructor;
import org.example.healthcare_management.controllers.dto.AppointmentDto;
import org.example.healthcare_management.entities.Appointment;
import org.example.healthcare_management.entities.TimeSlot;
import org.example.healthcare_management.services.AppointmentService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@AllArgsConstructor
@RequestMapping("api/appointments")
public class AppointmentController {

    private final AppointmentService appointmentService;

    @PostMapping("")
    public ResponseEntity<AppointmentDto> addAppointment(
            String patient_username,
            String doctor_username,
            TimeSlot timeSlot
    ) {

    }

}
