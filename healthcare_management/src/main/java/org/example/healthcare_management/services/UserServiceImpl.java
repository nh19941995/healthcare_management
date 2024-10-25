package org.example.healthcare_management.services;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.healthcare_management.controllers.dto.UserDto;
import org.example.healthcare_management.entities.Role;
import org.example.healthcare_management.entities.User;
import org.example.healthcare_management.exceptions.BusinessException;
import org.example.healthcare_management.exceptions.ResourceNotFoundException;
import org.example.healthcare_management.repositories.RoleRepo;
import org.example.healthcare_management.repositories.UserRepo;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@Slf4j
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {
    private final UserRepo userRepository;
    private final RoleRepo roleRepository;
    private final ModelMapper modelMapper;


    @Transactional
    @Override
    public User update(User user) {
        log.info("Updating user {} in the database", user.getFullName());
        return userRepository.save(user);
    }

    @Override
    public User findById(Long id) {
        log.info("Fetching user with id {}", id);
        Optional<User> user = userRepository.findById(id);
        return user.orElse(null);
    }

    @Override
    public List<User> findAll() {
        log.info("Fetching all users");
        return userRepository.findAll();
    }

    @Transactional
    @Override
    public void addRoleToUser(String username, String roleName) {

        // Get user
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User", "username", username));

        // Get role
        Role newRole = roleRepository.findByName(roleName)
                .orElseThrow(() -> new ResourceNotFoundException("Role", "roleName", roleName));

        // kiểm tra xem user đã có role chưa
        if (user.hasRole(roleName)) {
            throw new BusinessException(
                    "Role assignment failed",
                    "User already has the specified role",
                    HttpStatus.CONFLICT
            );
        }

        // Update user roles
        user.addRole(newRole);
        userRepository.save(user);
        log.info("Role {} added to user {}", roleName, user.getFullName());
    }

    @Transactional
    @Override
    public void removeRoleFromUser(User user, Role role) {
        if (user != null && role != null) {
            log.info("Removing role {} from user {}", role.getName(), user.getFullName());
            user.removeRole(role);
            userRepository.save(user);
        } else {
            log.warn("Attempted to remove null role from user or remove role from null user");
        }
    }

    @Override
    public User convertToEntity(UserDto userDto) {
        return modelMapper.map(userDto, User.class);
    }

    @Override
    public UserDto convertToDTO(User user) {
        return modelMapper.map(user, UserDto.class);
    }

    @Override
    public Set<UserDto> convertToDTOs(Set<User> users) {
        return users.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toSet());
    }

    @Override
    public Set<User> convertToEntities(Set<UserDto> userDtos) {
        return userDtos.stream()
                .map(this::convertToEntity)
                .collect(Collectors.toSet());
    }

    @Override
    public void updateProfile(User user, String username) {
        User oldUser = userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User", "username", username));
        modelMapper.map(user, oldUser);
        userRepository.save(oldUser);
    }
}
