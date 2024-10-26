package org.example.healthcare_management.services;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.healthcare_management.controllers.dto.DoctorDto;
import org.example.healthcare_management.entities.*;
import org.example.healthcare_management.repositories.DoctorRepo;
import org.example.healthcare_management.repositories.UserRepo;
import org.hibernate.Hibernate;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeMap;
import org.modelmapper.convention.MatchingStrategies;
import org.springframework.stereotype.Service;


@Slf4j
@Service
@AllArgsConstructor
public class DoctorServiceImpl implements DoctorService {
    private final UserRepo userRepo;
    private final DoctorRepo doctorRepo;
    private final ModelMapper modelMapper;
    private final BookingService bookingService;


    @Override
    public void updateProfile(Doctor doctor, String username) {
        User user = userRepo.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
        Doctor oldDoctor = user.getDoctor();
        if (oldDoctor != null) {
            // chuyển dữ liệu từ doctor sang oldDoctor
            modelMapper.map(doctor, oldDoctor);
            // lưu lại thông tin doctor để cập nhật vào database
            doctorRepo.save(oldDoctor);
        }
    }

    @Override
    public DoctorDto getDoctorProfile(String username) {
        User user = userRepo.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
        Doctor doctor = user.getDoctor();

        if (doctor == null) {
            throw new RuntimeException("User is not a doctor");
        }
        log.info("doctor: {}", doctor);
        return modelMapper.map(doctor, DoctorDto.class);
    }


}
