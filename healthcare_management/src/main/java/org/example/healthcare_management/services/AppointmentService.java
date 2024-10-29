package org.example.healthcare_management.services;

import org.example.healthcare_management.controllers.dto.AppointmentDto;
import org.example.healthcare_management.controllers.dto.UserDto;
import org.example.healthcare_management.entities.Appointment;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.lang.NonNull;

import java.util.Set;

public interface AppointmentService {
    AppointmentDto createAppointment(
            String patient_username, String doctor_username, Long timeSlot_id, String appointmentDate);
    Page<Appointment> findAllByUsername(@NonNull Pageable pageable);
}
