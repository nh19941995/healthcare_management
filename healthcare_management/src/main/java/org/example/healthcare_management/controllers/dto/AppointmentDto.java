package org.example.healthcare_management.controllers.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.example.healthcare_management.entities.Doctor;
import org.example.healthcare_management.entities.Patient;
import org.example.healthcare_management.enums.AppointmentsStatus;

import java.time.LocalDateTime;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class AppointmentDto {
    private AppointmentsStatus status;
    private Doctor doctor;
    private Patient patient;
    private LocalDateTime appointmentDate;
    private LocalDateTime createdAt;
}