package org.example.healthcare_management.controllers.dto;

import org.example.healthcare_management.entities.PatientStatus;
import org.example.healthcare_management.entities.User;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

public class PatientDto {
    private Integer id;
    private User user;
    private Set<AppointmentDto> bookings = new HashSet<>();
    private PatientStatus status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalDateTime deletedAt;
}
