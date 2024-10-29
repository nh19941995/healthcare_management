package org.example.healthcare_management.controllers.dto;

import jakarta.persistence.Column;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.example.healthcare_management.entities.Doctor;
import org.example.healthcare_management.entities.Patient;
import org.example.healthcare_management.entities.User;
import org.example.healthcare_management.enums.AppointmentsStatus;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class AppointmentDto {
    private Long id;
    private AppointmentsStatus status;
    private DoctorDtoNoUser doctor;
    private Patient patient;
    private LocalDate appointmentDate;
    private LocalDateTime createdAt;
    private LocalTime startAt;
    private LocalTime endAt;
}
