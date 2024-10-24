package org.example.healthcare_management.controllers.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.example.healthcare_management.entities.*;
import org.example.healthcare_management.enums.Status;

import java.util.HashSet;
import java.util.Set;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class DoctorDto {

    private String achievements;

    private String medicalTraining;

    private Set<Booking> bookings = new HashSet<>();

    private Clinic clinic;

    private Specialization specialization;

    private Set<Schedule> schedules = new HashSet<>();

    private Status status;

    private String lockReason;
}
