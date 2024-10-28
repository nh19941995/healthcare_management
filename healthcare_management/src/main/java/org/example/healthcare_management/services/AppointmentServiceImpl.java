package org.example.healthcare_management.services;

import lombok.AllArgsConstructor;
import org.example.healthcare_management.controllers.dto.AppointmentDto;
import org.example.healthcare_management.entities.Appointment;
import org.example.healthcare_management.repositories.AppointmentRepo;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@AllArgsConstructor
public class AppointmentServiceImpl implements AppointmentService {
    private final ModelMapper modelMapper;
    private final AppointmentRepo appointmentRepository;

    @Override
    public Appointment convertToEntity(AppointmentDto appointmentDto) {
        return modelMapper.map(appointmentDto, Appointment.class);
    }

    @Override
    public AppointmentDto convertToDTO(Appointment appointment) {
        return modelMapper.map(appointment, AppointmentDto.class);
    }

    @Override
    public Set<AppointmentDto> convertToDTOs(Set<Appointment> appointments) {
        return appointments.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toSet());
    }

    @Override
    public Set<Appointment> convertToEntities(Set<AppointmentDto> appointmentDtos) {
        return appointmentDtos.stream()
                .map(this::convertToEntity)
                .collect(Collectors.toSet());
    }
}
