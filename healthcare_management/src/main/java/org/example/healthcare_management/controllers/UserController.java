package org.example.healthcare_management.controllers;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.healthcare_management.controllers.dto.ApiResponse;
import org.example.healthcare_management.controllers.dto.UserDto;
import org.example.healthcare_management.entities.Doctor;
import org.example.healthcare_management.entities.User;
import org.example.healthcare_management.repositories.UserRepo;
import org.example.healthcare_management.services.UserService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;

@Slf4j
@RestController
@RequestMapping("/api/users")
@AllArgsConstructor
public class UserController {

    private final UserRepo userRepository;
    private final UserService userService;

    // lấy thông tin user theo username
    // url: localhost:8080/users/username
    @GetMapping("/{username}")
    public ResponseEntity<UserDto> getUserByUsername(@PathVariable String username) {

        // Kiểm tra xem người dùng hiện tại có phải là người sở hữu tài khoản không
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String currentUsername = authentication.getName();
        log.info("currentUsername: " + currentUsername);

        if (!currentUsername.equals(username)) {
            throw new RuntimeException("You can only view your own profile");
        }

        User user = userRepository.findByUsername(username).orElseThrow(() -> new RuntimeException("User not found: " + username));
        UserDto userDto =  userService.convertToDTO(user);
        return ResponseEntity.ok(userDto);
    }

    // update theo username
    // url: localhost:8080/users/username
    @PutMapping("/{username}")
    public ResponseEntity<UserDto> updateUser(
            @RequestBody UserDto userDto, @PathVariable String username
    ) {
        // Kiểm tra xem người dùng hiện tại có phải là người sở hữu tài khoản không
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String currentUsername = authentication.getName();
        if (!currentUsername.equals(username)) {
            throw new RuntimeException("You can only view your own profile");
        }
        UserDto newUser = userService.updateProfile(userDto, username);
        return ResponseEntity.ok(newUser);
    }

    @GetMapping("")
    public ResponseEntity<Page<UserDto>> getAllUsers(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size
    ) {
        Pageable pageable = PageRequest.of(page, size);
        return ResponseEntity.ok(userService.findAll(pageable));
    }



    // delete user
    // url: localhost:8080/users/username
//    @DeleteMapping("/{username}")
//    @PreAuthorize("hasAnyRole('ADMIN')")
//    public ResponseEntity<ApiResponse> deleteUser(@PathVariable String username) {
//        User user = userRepository.findByUsername(username).orElseThrow(() -> new RuntimeException("User not found: " + username));
//        user.setDeletedAt(LocalDateTime.now());
//        userService.update(user);
//        return ResponseEntity.ok(new ApiResponse(true, "User deleted successfully!"));
//    }






}
