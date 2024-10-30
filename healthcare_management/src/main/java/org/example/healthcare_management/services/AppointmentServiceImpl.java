package org.example.healthcare_management.services;

import lombok.AllArgsConstructor;
import lombok.NonNull;
import org.example.healthcare_management.controllers.dto.AppointmentDto;
import org.example.healthcare_management.entities.Appointment;
import org.example.healthcare_management.entities.Doctor;
import org.example.healthcare_management.entities.TimeSlot;
import org.example.healthcare_management.entities.User;
import org.example.healthcare_management.enums.AppointmentsStatus;
import org.example.healthcare_management.repositories.AppointmentRepo;
import org.example.healthcare_management.repositories.TimeSlotRepo;
import org.modelmapper.ModelMapper;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.time.LocalDate;

@Service
@AllArgsConstructor
public class AppointmentServiceImpl implements AppointmentService {
    private final ModelMapper modelMapper;
    private final AppointmentRepo appointmentRepository;
    private final UserService userService;
    private final TimeSlotRepo timeSlotRepo;
    private final DoctorService doctorService;


    @Override
    public AppointmentDto createAppointment(
            String patient_username, String doctor_username,
            Long timeSlot_id, String appointmentDate
    ) {
        User patient = userService.findByUsername(patient_username);
        Doctor doctor = doctorService.findByUsername(doctor_username);

        TimeSlot timeSlot = timeSlotRepo.findById(timeSlot_id)
                .orElseThrow(() -> new RuntimeException("Time slot not found"));
        // tạo appointmentDate từ string
        Appointment appointment =  new Appointment();
        LocalDate date = LocalDate.parse(appointmentDate);
        // set trạng thái của cuộc hẹn là PENDING
        appointment.setStatus(AppointmentsStatus.PENDING);
        // set ngày hẹn
        appointment.setAppointmentDate(date);
        // set bác sĩ và bệnh nhân
        appointment.setPatient(patient.getPatient());
        appointment.setDoctor(doctor);
        // set time slot
        appointment.setTimeSlot(timeSlot);
        // lưu cuộc hẹn
        appointmentRepository.save(appointment);
        return modelMapper.map(appointment, AppointmentDto.class);
    }

    @Override
    public Page<Appointment> findAllByUsername(@NonNull Pageable pageable, String username) {


        return appointmentRepository.findAll(pageable);
    }
}
