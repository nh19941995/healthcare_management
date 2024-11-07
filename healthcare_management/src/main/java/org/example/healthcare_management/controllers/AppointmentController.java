package org.example.healthcare_management.controllers;

import lombok.AllArgsConstructor;
import org.example.healthcare_management.controllers.dto.AppointmentDto;
import org.example.healthcare_management.entities.Appointment;
import org.example.healthcare_management.repositories.TimeSlotRepo;
import org.example.healthcare_management.services.AppointmentService;
import org.example.healthcare_management.services.DoctorService;
import org.example.healthcare_management.services.UserService;
import org.modelmapper.ModelMapper;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

@RestController
@AllArgsConstructor
@RequestMapping("api/appointments")
public class AppointmentController {

    private final UserService userService;
    private final DoctorService doctorService;
    private final AppointmentService appointmentService;
    private final TimeSlotRepo timeSlotRepo;
    private final ModelMapper modelMapper;

    // tạo một cuộc hẹn mới
    // url: localhost:8080/api/appointments/patient_username/doctor_username/timeSlot_id/appointmentDate
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
        AppointmentDto appointment = appointmentService.createAppointment(
                patient_username, doctor_username, timeSlot_id, appointmentDate);
        return ResponseEntity.ok(appointment);
    }

    // ulr: localhost:8080/api/appointments/username?page=0&size=10
    @GetMapping("{username}")
    public ResponseEntity<Page<AppointmentDto>> getAppointments(
            @PathVariable String username,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size
    ) {
        // Kiểm tra xem người dùng hiện tại có phải là người sở hữu tài khoản không
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String currentUsername = authentication.getName();
        if (!currentUsername.equals(username)) {
            throw new RuntimeException("You can only view your own appointments");
        }
        Pageable pageable = PageRequest.of(page, size);
        Page<Appointment> appointments = appointmentService.findAllByUsername(pageable, username);
        Page<AppointmentDto> appointmentDtos = appointments.map(appointment -> modelMapper.map(appointment, AppointmentDto.class));
        return ResponseEntity.ok(appointmentDtos);
    }




}
