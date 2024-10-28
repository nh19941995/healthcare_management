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
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.PathVariable;
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

    // tạo một cuộc hẹn mới
    // url: localhost:8080/api/appointments/patient_username/doctor_username/timeSlot_id
    @PostMapping("{patient_username}/{doctor_username}/{timeSlot_id}/{appointmentDate}")
    public ResponseEntity<AppointmentDto> addAppointment(
            @PathVariable String patient_username,
            @PathVariable String doctor_username,
            @PathVariable Long timeSlot_id,
            @PathVariable String appointmentDate
    ) {
        // Kiểm tra xem người dùng hiện tại có phải là người sở hữu tài khoản không
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String currentUsername = authentication.getName();
        if (!currentUsername.equals(patient_username)) {
            throw new RuntimeException("You can only create appointment for yourself");
        }
        Appointment appointment = appointmentService.createAppointment(
                patient_username, doctor_username, timeSlot_id, appointmentDate);
        return ResponseEntity.ok(appointmentService.convertToDTO(appointment));
    }




}
