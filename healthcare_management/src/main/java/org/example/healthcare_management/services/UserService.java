package org.example.healthcare_management.services;

import org.example.healthcare_management.controllers.dto.user.UpdateDto;
import org.example.healthcare_management.controllers.dto.user.UserDto;
import org.example.healthcare_management.entities.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.lang.NonNull;


public interface UserService  {
    // tìm user theo username
    User findByUsername(String username);
    // lấy hết user
    Page<UserDto> findAll(@NonNull Pageable pageable);
    // update user

    void addRoleToUser(String username, String roleName);

    void checkUsernameExistence (String username);

    User validateOwnership (Long userId);

    void updateProfile(Long userI, UpdateDto userDto);
}
