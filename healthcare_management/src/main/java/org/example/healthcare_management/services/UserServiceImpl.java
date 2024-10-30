package org.example.healthcare_management.services;

import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.healthcare_management.controllers.dto.user.UpdateDto;
import org.example.healthcare_management.controllers.dto.user.UserDto;
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
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;


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
                .orElseThrow(() -> new BusinessException(
                        "Username not found",
                        "The username '" + username + "' does not exist. Please check the username and try again.",
                        HttpStatus.NOT_FOUND));
    }

    @Override
    public Page<UserDto> findAll(@NonNull Pageable pageable) {
        // lấy ra tất cả user
        Page<User> userPage = userRepository.findAll(pageable);
        // chuyển đổi từ User sang UserDto
        return userPage.map(user -> modelMapper.map(user, UserDto.class));
    }

//    @Transactional
//    @Override
//    public User updateProfile(User user, Long userId) {
//        try {
//            User oldUser = userRepository.findById(userId)
//                    .orElseThrow(() -> new ResourceNotFoundException("User", "id", userId));
//            user.setId(userId);
//            user.setRoles(oldUser.getRoles());
//            return userRepository.save(user);
//        }catch (Exception e) {
//            log.error("Error: ", e);
//        }
//        return null;
//    }

    @Transactional
    @Override
    public void addRoleToUser(String username, String roleName) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User", "username", username));
        Role role = roleRepository.findByName(roleName).
                orElseThrow(() -> new BusinessException("Role not found",
                        "No role found with name: " + roleName,
                        HttpStatus.NOT_FOUND));
        user.getRoles().add(role);
        User newUser = userRepository.save(user);
        modelMapper.map(newUser, UserDto.class);
    }

    @Override
    public void checkUsernameExistence (String username) {
        userRepository.findByUsername(username).ifPresent(u -> {
            throw new BusinessException(
                    "Username already exists",
                    "The username '" + username + "' is already taken. Please choose a different username.",
                    HttpStatus.CONFLICT);
        });
    }

    @Override
    public User validateOwnership(Long userId) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String currentUsername = authentication.getName();

        User currentUser = userRepository.findByUsername(currentUsername)
                .orElseThrow(() -> new UsernameNotFoundException("User not found: " + currentUsername));

        if (isPatientOnly(currentUser) && !currentUser.getId().equals(userId)) {
            throw new AccessDeniedException("You can only action your own profile");
        }

        return currentUser;
    }

    @Override
    public void updateProfile(Long userId, UpdateDto userDto) {
        User oldUser = validateOwnership(userId);
        modelMapper.map(userDto, oldUser);
        userRepository.save(oldUser);
    }

    private boolean isPatientOnly(User user) {
        Role patientRole = roleRepository.findByName(EnumRole.PATIENT.getRoleName())
                .orElseThrow(() -> new EntityNotFoundException("Role not found"));
        return user.getRoles().contains(patientRole) && user.getRoles().size() == 1;
    }


}
