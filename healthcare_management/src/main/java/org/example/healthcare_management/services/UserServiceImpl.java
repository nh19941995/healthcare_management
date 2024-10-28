package org.example.healthcare_management.services;

import lombok.NonNull;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.healthcare_management.controllers.dto.UserDto;
import org.example.healthcare_management.entities.Role;
import org.example.healthcare_management.entities.User;
import org.example.healthcare_management.enums.EnumRole;
import org.example.healthcare_management.exceptions.BusinessException;
import org.example.healthcare_management.exceptions.ResourceNotFoundException;
import org.example.healthcare_management.repositories.RoleRepo;
import org.example.healthcare_management.repositories.UserRepo;
import org.modelmapper.ModelMapper;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Set;

@Service
@Slf4j
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {
    private final UserRepo userRepository;
    private final RoleRepo roleRepository;
    private final ModelMapper modelMapper;


    @Override
    public User findByUsername(String username) {
        return userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User", "username", username));
    }

    @Override
    public Page<UserDto> findAll(@NonNull Pageable pageable) {
        // lấy ra tất cả user
        Page<User> userPage = userRepository.findAll(pageable);
        // chuyển đổi từ User sang UserDto
        return userPage.map(user -> modelMapper.map(user, UserDto.class));
    }

    @Override
    public UserDto updateProfile(UserDto userDto, String username) {
        return null;
    }

    @Override
    public UserDto addRoleToUser(String username, String roleName) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User", "username", username));
        Role role = roleRepository.findByName(roleName).
                orElseThrow(() -> new BusinessException("Role not found",
                        "No role found with name: " + roleName,
                        HttpStatus.NOT_FOUND));
        user.getRoles().add(role);
        User newUser= userRepository.save(user);
        return modelMapper.map(newUser, UserDto.class);
    }


    @Override
    public User create(User entity) {
        Role role = roleRepository.findByName(EnumRole.PATIENT.getRoleName())
                .orElseThrow(() -> new BusinessException("Role not found",
                        "No role found with name: " + EnumRole.PATIENT.getRoleName(),
                        HttpStatus.NOT_FOUND));
        // Set.of(role) tạo ra một Set chỉ chứa một phần tử, đó là đối tượng role.
        entity.setRoles(Set.of(role));
        return userRepository.save(entity);
    }

    @Override
    public User findById(Long id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User", "id", id));
    }

    @Override
    public UserDto update(Long id, UserDto dtoEntity) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User", "id", id));
        modelMapper.map(dtoEntity, user);
        return modelMapper.map(userRepository.save(user), UserDto.class);
    }

    @Override
    public void delete(Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User", "id", id));
        user.setDeletedAt(LocalDateTime.now());
        userRepository.save(user);
    }

    @Override
    public boolean exists(Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User", "id", id));
        return user.getDeletedAt() == null;
    }
}
