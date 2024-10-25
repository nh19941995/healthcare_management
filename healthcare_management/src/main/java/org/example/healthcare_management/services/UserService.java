package org.example.healthcare_management.services;

import org.example.healthcare_management.controllers.dto.BookingDto;
import org.example.healthcare_management.controllers.dto.UserDto;
import org.example.healthcare_management.entities.Booking;
import org.example.healthcare_management.entities.Doctor;
import org.example.healthcare_management.entities.Role;
import org.example.healthcare_management.entities.User;

import java.util.List;
import java.util.Set;

public interface UserService {
    User update(User user);
    User findById(Long id);
    List<User> findAll();
    void addRoleToUser(String username, String roleName);
    void removeRoleFromUser(User user, Role role);
    User convertToEntity(UserDto userDto);
    UserDto convertToDTO(User user);
    Set<UserDto> convertToDTOs(Set<User> users);
    Set<User> convertToEntities(Set<UserDto> userDtos);
    void updateProfile(User user, String username);

}
