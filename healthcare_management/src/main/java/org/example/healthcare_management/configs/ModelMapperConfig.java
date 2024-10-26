package org.example.healthcare_management.configs;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import org.example.healthcare_management.controllers.dto.RoleDto;
import org.example.healthcare_management.controllers.dto.UserDto;
import org.example.healthcare_management.entities.Doctor;
import org.example.healthcare_management.entities.Patient;
import org.example.healthcare_management.entities.Role;
import org.example.healthcare_management.entities.User;
import org.example.healthcare_management.enums.Gender;
import org.example.healthcare_management.enums.Status;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.modelmapper.ModelMapper;
import org.modelmapper.convention.MatchingStrategies;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

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





//    private Long id;
//    private String fullName;
//    private String username;
//    private String email;
//    private String password;
//    private String address;
//    private String phone;
//    private String avatar;
//    private Gender gender;
//    private String description;
//    private Set<Role> roles = new HashSet<>();
//    private Doctor doctor;
//    private Patient patient;
//    private LocalDateTime createdAt;
//    private LocalDateTime updatedAt;
//    private LocalDateTime deletedAt;
//    private Status status;
//    private String lockReason;


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
}
