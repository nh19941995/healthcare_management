package org.example.healthcare_management.services;

import org.example.healthcare_management.controllers.dto.BookingDto;
import org.example.healthcare_management.controllers.dto.UserDto;
import org.example.healthcare_management.entities.Booking;
import org.example.healthcare_management.entities.Doctor;
import org.example.healthcare_management.entities.Role;
import org.example.healthcare_management.entities.User;
import org.example.healthcare_management.services.CRUD.BaseCrud;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.lang.NonNull;

import java.util.Set;

public interface UserService extends BaseCrud<User, UserDto> {
    User findByUsername(String username);
    // lấy hết user
    Page<User> findAll(@NonNull Pageable pageable);
    // chuyển từ userDto sang user
    User convertToEntity(UserDto userDto);
    // chuyển từ user sang userDto
    UserDto convertToDTO(User user);
    // chuyển từ set user sang set userDto
    Set<UserDto> convertToDTOs(Set<User> users);
    // chuyển từ set userDto sang set user
    Set<User> convertToEntities(Set<UserDto> userDtos);

     UserDto updateProfile(UserDto userDto, String username);
}
