package org.example.healthcare_management.services;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.healthcare_management.controllers.dto.DoctorDto;
import org.example.healthcare_management.entities.*;
import org.example.healthcare_management.enums.EnumRole;
import org.example.healthcare_management.repositories.DoctorRepo;
import org.example.healthcare_management.repositories.UserRepo;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;


@Slf4j
@Service
@AllArgsConstructor
public class DoctorServiceImpl implements DoctorService {
    private final UserRepo userRepo;
    private final DoctorRepo doctorRepo;
    private final ModelMapper modelMapper;
    private final RoleService roleService;


    @Override
    public DoctorDto updateProfile(DoctorDto doctorDto, String username) {
        User user = userRepo.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));

        Doctor existingDoctor = user.getDoctor();
        if (existingDoctor != null) {
            // Trực tiếp map từ doctorDto sang existingDoctor mà không cần tạo đối tượng trung gian
            modelMapper.map(doctorDto, existingDoctor);
            // Lưu thông tin bác sĩ
            doctorRepo.save(existingDoctor);
            return doctorDto;
        }
        return null;
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

    @Override
    public Doctor findByUsername(String username) {
        // Tìm user theo username
        User user = userRepo.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
        // Kiểm tra xem user có phải là bác sĩ không
        roleService.checkUserRole(username, EnumRole.DOCTOR.name());
        return user.getDoctor();
    }


}
