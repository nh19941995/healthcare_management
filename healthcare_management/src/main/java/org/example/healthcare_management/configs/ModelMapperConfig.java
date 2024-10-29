package org.example.healthcare_management.configs;

import lombok.AllArgsConstructor;
import org.example.healthcare_management.controllers.dto.*;
import org.example.healthcare_management.entities.*;
import org.example.healthcare_management.repositories.ClinicRepo;
import org.example.healthcare_management.repositories.SpecializationRepo;
import org.modelmapper.ModelMapper;
import org.modelmapper.convention.MatchingStrategies;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.Collections;
import java.util.Set;
import java.util.stream.Collectors;


@Configuration
@AllArgsConstructor
public class ModelMapperConfig {
    private final ClinicRepo clinicRepo;
    private final SpecializationRepo specializationRepo;

    @Bean
    public ModelMapper modelMapper() {
        ModelMapper modelMapper = new ModelMapper();
        modelMapper.getConfiguration()
                .setMatchingStrategy(MatchingStrategies.STRICT)
                .setSkipNullEnabled(true)
                .setFieldMatchingEnabled(true)
                .setFieldAccessLevel(org.modelmapper.config.Configuration.AccessLevel.PRIVATE);

        configureUserMapping(modelMapper);
        configureRoleMapping(modelMapper);
        configureDoctorMapping(modelMapper);
        configureClinicMapping(modelMapper);
        configureAppointmentMapping(modelMapper);

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

                    // Map Doctor -> DoctorDto
//                    mapper.map(User::getDoctor, UserDto::setDoctor);
                });

        // chiều từ UserDto -> User
        modelMapper.createTypeMap(UserDto.class, User.class)
                .addMappings(mapper -> {
                    mapper.map(UserDto::getId, User::setId);
                    mapper.map(UserDto::getFullName, User::setFullName);
                    mapper.map(UserDto::getUsername, User::setUsername);
                    mapper.map(UserDto::getEmail, User::setEmail);
                    mapper.map(UserDto::getAddress, User::setAddress);
                    mapper.map(UserDto::getPhone, User::setPhone);
                    mapper.map(UserDto::getAvatar, User::setAvatar);
                    mapper.map(UserDto::getGender, User::setGender);
                    mapper.map(UserDto::getDescription, User::setDescription);
                    mapper.map(UserDto::getRoles, User::setRoles);

                    // không cập nhật Doctor
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
                    // Map các trường cơ bản
                    mapper.map(Doctor::getId, DoctorDto::setId);
                    mapper.map(Doctor::getMedicalTraining, DoctorDto::setMedicalTraining);
                    mapper.map(Doctor::getAchievements, DoctorDto::setAchievements);
                    mapper.map(Doctor::getStatus, DoctorDto::setStatus);
                    mapper.map(Doctor::getLockReason, DoctorDto::setLockReason);
                })
                .setPostConverter(context -> {
                    Doctor source = context.getSource();
                    DoctorDto destination = context.getDestination();

                    // Map User fields
                    if (source.getUser() != null) {
                        destination.setUsername(source.getUser().getUsername());
                        destination.setAvatar(source.getUser().getAvatar());
                    }

                    // Map Clinic
                    if (source.getClinic() != null) {
                        destination.setClinicId(source.getClinic().getId());
                    }

                    // Map Specialization
                    if (source.getSpecialization() != null) {
                        destination.setSpecializationId(source.getSpecialization().getId());
                    }

                    return destination;
                });

        // chiều từ DoctorDto -> Doctor
        modelMapper.createTypeMap(DoctorDto.class, Doctor.class)
                .addMappings(mapper -> {
                    // Map các trường cơ bản
                    mapper.map(DoctorDto::getId, Doctor::setId);
                    mapper.map(DoctorDto::getMedicalTraining, Doctor::setMedicalTraining);
                    mapper.map(DoctorDto::getAchievements, Doctor::setAchievements);
                    mapper.map(DoctorDto::getStatus, Doctor::setStatus);
                    mapper.map(DoctorDto::getLockReason, Doctor::setLockReason);
                })
                .setPostConverter(context -> {
                    DoctorDto source = context.getSource();
                    Doctor destination = context.getDestination();

                    // không cập nhật User

                    // Map Clinic
                    if (source.getClinicId() != null) {
                        Clinic clinic = clinicRepo.findById(source.getClinicId())
                                .orElseThrow(() -> new RuntimeException("Clinic not found"));
                        destination.setClinic(clinic);
                    }

                    // Map Specialization
                    if (source.getSpecializationId() != null) {
                        Specialization specialization = specializationRepo.findById(source.getSpecializationId())
                                .orElseThrow(() -> new RuntimeException("Specialization not found"));
                        destination.setSpecialization(specialization);
                    }

                    return destination;
                });
    }

    // clinic
    private void configureClinicMapping (ModelMapper modelMapper) {
        // chiều từ Clinic -> ClinicDto (không chứa Doctor)
        modelMapper.createTypeMap(Clinic.class, ClinicDtoNoDoctor.class)
                .addMappings(mapper -> {
                    mapper.map(Clinic::getId, ClinicDtoNoDoctor::setId);
                    mapper.map(Clinic::getName, ClinicDtoNoDoctor::setName);
                    mapper.map(Clinic::getAddress, ClinicDtoNoDoctor::setAddress);
                    mapper.map(Clinic::getPhone, ClinicDtoNoDoctor::setPhone);
                    mapper.map(Clinic::getDescription, ClinicDtoNoDoctor::setDescription);
                    mapper.map(Clinic::getImage, ClinicDtoNoDoctor::setImage);
                    mapper.map(Clinic::getCreatedAt, ClinicDtoNoDoctor::setCreatedAt);
                });

        // chiều từ Clinic -> ClinicDto (có chứa Doctor)
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

    // appointment
    private void configureAppointmentMapping(ModelMapper modelMapper) {
        // chiều từ Appointment -> AppointmentDto
        modelMapper.createTypeMap(Appointment.class, AppointmentDto.class)
                .addMappings(mapper -> {
                    mapper.map(Appointment::getId, AppointmentDto::setId);
                    mapper.map(Appointment::getAppointmentDate, AppointmentDto::setAppointmentDate);
                    mapper.map(Appointment::getStatus, AppointmentDto::setStatus);
                })
                .setPostConverter(context -> {
                    Appointment source = context.getSource();
                    AppointmentDto destination = context.getDestination();

                    // Map Doctor
                    if (source.getDoctor() != null) {
                        destination.setDoctor(
                                modelMapper.map(source.getDoctor(), DoctorDtoNoUser.class)
                        );
                    }

                    // Map Patient
                    if (source.getPatient() != null) {
                        destination.setPatient(
                                modelMapper.map(source.getPatient(), Patient.class)
                        );
                    }

                    // Map TimeSlot
                    if (source.getTimeSlot() != null) {
                        destination.setStartAt(source.getTimeSlot().getStartAt());
                        destination.setEndAt(source.getTimeSlot().getEndAt());
                    }

                    return destination;
                });

        // chiều từ AppointmentDto -> Appointment
        modelMapper.createTypeMap(AppointmentDto.class, Appointment.class)
                .addMappings(mapper -> {
                    mapper.map(AppointmentDto::getId, Appointment::setId);
                    mapper.map(AppointmentDto::getAppointmentDate, Appointment::setAppointmentDate);
                    mapper.map(AppointmentDto::getStatus, Appointment::setStatus);
                })
                .setPostConverter(context -> {
                    AppointmentDto source = context.getSource();
                    Appointment destination = context.getDestination();

                    // không cập nhật Doctor

                    // không cập nhật Patient

                    // không cập nhật TimeSlot

                    return destination;
                });
    }


}
