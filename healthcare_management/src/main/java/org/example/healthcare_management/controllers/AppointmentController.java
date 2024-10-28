package org.example.healthcare_management.controllers;

import lombok.AllArgsConstructor;
import org.example.healthcare_management.controllers.dto.AppointmentDto;
import org.example.healthcare_management.entities.Appointment;
import org.example.healthcare_management.entities.Doctor;
import org.example.healthcare_management.entities.TimeSlot;
import org.example.healthcare_management.entities.User;
import org.example.healthcare_management.repositories.TimeSlotRepo;
import org.example.healthcare_management.services.AppointmentService;
import org.example.healthcare_management.services.DoctorService;
import org.example.healthcare_management.services.UserService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@AllArgsConstructor
@RequestMapping("api/appointments")
public class AppointmentController {

    private final UserService userService;
    private final DoctorService doctorService;
    private final AppointmentService appointmentService;
    private final TimeSlotRepo timeSlotRepo;

    @PostMapping("")
    public ResponseEntity<AppointmentDto> addAppointment(
            String patient_username,
            String doctor_username,
            String timeSlot_id
    ) {
        Appointment appointment = appointmentService.createAppointment(patient_username, doctor_username, timeSlot_id);
        return ResponseEntity.ok(appointmentService.convertToDTO(appointment));
    }


}
