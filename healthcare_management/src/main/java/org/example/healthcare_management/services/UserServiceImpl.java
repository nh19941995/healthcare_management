package org.example.healthcare_management.services;

import jakarta.transaction.Transactional;
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


    @Override
    public User findByUsername(String username) {
        return userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User", "username", username));
    }

    @Override
    public Page<User> findAll(@NonNull Pageable pageable) {
        return userRepository.findAll(pageable);
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
    public UserDto updateProfile(UserDto userDto, String username) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User", "username", username));
//        user.s
//        user.setLastName(userDto.getLastName());
//        user.setPhone(userDto.getPhone());
//        user.setAddress(userDto.getAddress());
//        user.setGender(userDto.getGender());
//        user.setDob(userDto.getDob());
        return convertToDTO(userRepository.save(user));
    }


    @Override
    public UserDto create(User entity) {
        Role role = roleRepository.findByName(EnumRole.PATIENT.getRoleName())
                .orElseThrow(() -> new BusinessException("Role not found",
                        "No role found with name: " + EnumRole.PATIENT.getRoleName(),
                        HttpStatus.NOT_FOUND));
        User user = new User();
        user.setRoles(Set.of(role));
        return convertToDTO(userRepository.save(user));
    }

    @Override
    public Optional<User> findById(Long id) {
        return Optional.empty();
    }

    @Override
    public UserDto update(Long id, UserDto dtoEntity) {
        return null;
    }

    @Override
    public void delete(Long id) {

    }

    @Override
    public boolean exists(Long id) {
        return false;
    }
}
