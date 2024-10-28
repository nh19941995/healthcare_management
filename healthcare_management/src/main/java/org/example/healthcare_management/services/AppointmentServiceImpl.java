package org.example.healthcare_management.services;

import lombok.AllArgsConstructor;
import org.example.healthcare_management.controllers.dto.AppointmentDto;
import org.example.healthcare_management.entities.Appointment;
import org.example.healthcare_management.entities.TimeSlot;
import org.example.healthcare_management.entities.User;
import org.example.healthcare_management.enums.AppointmentsStatus;
import org.example.healthcare_management.repositories.AppointmentRepo;
import org.example.healthcare_management.repositories.TimeSlotRepo;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@AllArgsConstructor
public class AppointmentServiceImpl implements AppointmentService {
    private final ModelMapper modelMapper;
    private final AppointmentRepo appointmentRepository;
    private final UserService userService;
    private final TimeSlotRepo timeSlotRepo;

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

    @Override
    public Appointment createAppointment(String patient_username, String doctor_username, Long timeSlot_id, String appointmentDate) {
        User patient = userService.findByUsername(patient_username);
        User doctor = userService.findByUsername(doctor_username);
        TimeSlot timeSlot = timeSlotRepo.findById(timeSlot_id)
                .orElseThrow(() -> new RuntimeException("Time slot not found"));
        // tạo appointmentDate từ string
        Appointment appointment =  new Appointment();
        LocalDate date = LocalDate.parse(appointmentDate);
        appointment.setStatus(AppointmentsStatus.PENDING);
        appointment.setAppointmentDate(date);
        appointment.setPatient(patient.getPatient());
        appointment.setDoctor(doctor.getDoctor());
        appointment.setTimeSlot(timeSlot);
        return appointmentRepository.save(appointment);
    }
}
