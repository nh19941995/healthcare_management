package org.example.healthcare_management.configs;

import org.example.healthcare_management.controllers.dto.ClinicDtoWithDoctor;
import org.example.healthcare_management.controllers.dto.DoctorDto;
import org.example.healthcare_management.controllers.dto.RoleDto;
import org.example.healthcare_management.controllers.dto.UserDto;
import org.example.healthcare_management.entities.*;
import org.modelmapper.ModelMapper;
import org.modelmapper.convention.MatchingStrategies;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import java.util.Collections;
import java.util.Set;
import java.util.stream.Collectors;


@Configuration
public class ModelMapperConfig {
    @Bean
    public ModelMapper modelMapper() {
        ModelMapper modelMapper = new ModelMapper();
        modelMapper.getConfiguration()
                .setMatchingStrategy(MatchingStrategies.STRICT)
                .setSkipNullEnabled(true)
                .setFieldMatchingEnabled(true)
                .setFieldAccessLevel(org.modelmapper.config.Configuration.AccessLevel.PRIVATE);
        return modelMapper;
    }

    // user
    private void configureUserMapping(ModelMapper modelMapper) {
        // chiều từ User -> UserDto
        modelMapper.createTypeMap(User.class, UserDto.class)
                .addMappings(mapper -> {
                    mapper.map(User::getId, UserDto::setId);
                    mapper.map(User::getFullName, UserDto::setFullName);
                    mapper.map(User::getUsername, UserDto::setUsername);
                    mapper.map(User::getEmail, UserDto::setEmail);
                    mapper.map(User::getAddress, UserDto::setAddress);
                    mapper.map(User::getPhone, UserDto::setPhone);
                    mapper.map(User::getAvatar, UserDto::setAvatar);
                    mapper.map(User::getGender, UserDto::setGender);
                    mapper.map(User::getDescription, UserDto::setDescription);
                    mapper.map(User::getRoles, UserDto::setRoles);

                });
    }

    // role
    private void configureRoleMapping(ModelMapper modelMapper) {
        // chiều từ Role -> RoleDto
        modelMapper.createTypeMap(Role.class, RoleDto.class)
                .addMappings(mapper -> {
                    mapper.map(Role::getId, RoleDto::setId);
                    mapper.map(Role::getName, RoleDto::setName);
                    mapper.map(Role::getDescription, RoleDto::setDescription);
                });
        // chiều từ RoleDto -> Role
        modelMapper.createTypeMap(RoleDto.class, Role.class)
                .addMappings(mapper -> {
                    mapper.map(RoleDto::getId, Role::setId);
                    mapper.map(RoleDto::getName, Role::setName);
                    mapper.map(RoleDto::getDescription, Role::setDescription);
                });
    }

    // doctor
    private void configureDoctorMapping(ModelMapper modelMapper) {
        // chiều từ Doctor -> DoctorDto
        modelMapper.createTypeMap(Doctor.class, DoctorDto.class)
                .addMappings(mapper -> {
                    // các trường giống nhau sẽ được ánh xạ tự động
                    mapper.map(Doctor::getId, DoctorDto::setId);
                    mapper.map(Doctor::getMedicalTraining, DoctorDto::setMedicalTraining);
                    mapper.map(Doctor::getAchievements, DoctorDto::setAchievements);
                    mapper.map(Doctor::getStatus, DoctorDto::setStatus);
                    mapper.map(Doctor::getLockReason, DoctorDto::setLockReason);
                    // ánh xạ các trường đặc biệt
                    // user -> username và avatar
                    mapper.map(src -> src.getUser().getUsername(), DoctorDto::setUsername);
                    mapper.map(src -> src.getUser().getAvatar(), DoctorDto::setAvatar);
                    // clinic -> clinicId
                    mapper.map(src -> src.getClinic().getId(), DoctorDto::setClinicId);
                    // specialization -> specializationId
                    mapper.map(src -> src.getSpecialization().getId(), DoctorDto::setSpecializationId);
                });
    }

    // clinic
    private void configureClinicMapping (ModelMapper modelMapper) {
        // chiều từ Clinic -> ClinicDto
        modelMapper.createTypeMap(Clinic.class, ClinicDtoWithDoctor.class)
                .addMappings(mapper -> {
                    mapper.map(Clinic::getId, ClinicDtoWithDoctor::setId);
                    mapper.map(Clinic::getName, ClinicDtoWithDoctor::setName);
                    mapper.map(Clinic::getAddress, ClinicDtoWithDoctor::setAddress);
                    mapper.map(Clinic::getPhone, ClinicDtoWithDoctor::setPhone);
                    mapper.map(Clinic::getDescription, ClinicDtoWithDoctor::setDescription);
                    mapper.map(Clinic::getImage, ClinicDtoWithDoctor::setImage);
                    mapper.map(Clinic::getCreatedAt, ClinicDtoWithDoctor::setCreatedAt);
                    // Cấu hình đặc biệt cho collection mapping
                    mapper.using(ctx -> {
                        Object source = ctx.getSource();
                        if (source instanceof Set<?>) {
                            return ((Set<?>) source).stream()
                                    .filter(Doctor.class::isInstance)
                                    .map(doctor -> modelMapper.map(doctor, DoctorDto.class))
                                    .collect(Collectors.toSet());
                        }
                        return Collections.emptySet();
                    }).map(Clinic::getDoctors, ClinicDtoWithDoctor::setDoctorsDto);
                });
    }
}
