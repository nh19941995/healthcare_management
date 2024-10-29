package org.example.healthcare_management.services;

import org.example.healthcare_management.controllers.dto.UserDto;
import org.example.healthcare_management.entities.User;
import org.example.healthcare_management.services.CRUD.BaseCrud;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.lang.NonNull;


public interface UserService extends BaseCrud<User, UserDto> {
    // tìm user theo username
    User findByUsername(String username);
    // lấy hết user
    Page<UserDto> findAll(@NonNull Pageable pageable);
    // update user
    UserDto updateProfile(UserDto userDto, String username);

    UserDto addRoleToUser(String username, String roleName);

    void checkUsernameExistence (String username);
}
