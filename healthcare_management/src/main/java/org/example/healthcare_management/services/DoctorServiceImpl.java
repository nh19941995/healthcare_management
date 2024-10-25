package org.example.healthcare_management.services;

import lombok.AllArgsConstructor;
import org.example.healthcare_management.controllers.dto.DoctorDto;
import org.example.healthcare_management.entities.*;
import org.example.healthcare_management.repositories.DoctorRepo;
import org.example.healthcare_management.repositories.UserRepo;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeMap;
import org.modelmapper.convention.MatchingStrategies;
import org.springframework.stereotype.Service;


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
    public DoctorDto convertToDTO(Doctor doctor) {
        // Cấu hình ModelMapper để handle nested objects
        modelMapper.getConfiguration().setMatchingStrategy(MatchingStrategies.STRICT);

        // chuyển đổi từ Doctor sang DoctorDto
        TypeMap<Doctor, DoctorDto> typeMap = modelMapper.createTypeMap(Doctor.class, DoctorDto.class);
        typeMap.addMappings(mapper -> {
            mapper.map(Doctor::getAchievements, DoctorDto::setAchievements);
            mapper.map(Doctor::getMedicalTraining, DoctorDto::setMedicalTraining);
            mapper.map(Doctor::getClinic, DoctorDto::setClinicId);
            mapper.map(Doctor::getSpecialization, DoctorDto::setSpecializationId);
            mapper.map(Doctor::getStatus, DoctorDto::setStatus);
            mapper.map(Doctor::getLockReason, DoctorDto::setLockReason);


        });

        return modelMapper.map(doctor, DoctorDto.class);
    }


}
