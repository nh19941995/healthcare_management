package org.example.healthcare_management.services;

import org.example.healthcare_management.controllers.dto.AppointmentDto;
import org.example.healthcare_management.entities.Appointment;

import java.util.Set;

public interface AppointmentService {
    Appointment convertToEntity(AppointmentDto appointmentDto);
    AppointmentDto convertToDTO(Appointment appointment);
    Set<AppointmentDto> convertToDTOs(Set<Appointment> appointments);
    Set<Appointment> convertToEntities(Set<AppointmentDto> appointmentDtos);
}
