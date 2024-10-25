package org.example.healthcare_management.controllers;

import lombok.AllArgsConstructor;
import org.example.healthcare_management.controllers.dto.ApiResponse;
import org.example.healthcare_management.entities.Doctor;
import org.example.healthcare_management.entities.User;
import org.example.healthcare_management.repositories.UserRepo;
import org.example.healthcare_management.services.UserService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;

@RestController
@RequestMapping("/api/users")
@AllArgsConstructor
public class UserController {

    private final UserRepo userRepository;
    private final UserService userService;

    // get all users
    // url:
    @GetMapping("/{username}")
//    @PreAuthorize("hasRole('ADMIN') or hasRole('DOCTOR') or @userSecurity.isCurrentUser(#username)")
    public ResponseEntity<User> getUserByUsername(@PathVariable String username) {

        // Kiểm tra xem người dùng hiện tại có phải là người sở hữu tài khoản không
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String currentUsername = authentication.getName();

        if (!currentUsername.equals(username)) {
            throw new RuntimeException("You can only view your own profile");
        }

        User user = userRepository.findByUsername(username).orElseThrow(() -> new RuntimeException("User not found: " + username));
        return ResponseEntity.ok(user);
    }

    // update user
    // url: localhost:8080/users/username
    @PutMapping("/{username}")
    @PreAuthorize("hasAnyRole('ADMIN', 'DOCTOR', 'PATIENT')")
    public ResponseEntity<User> updateUser(
            @RequestBody User user, @PathVariable String username
    ) {
        // Kiểm tra xem người dùng hiện tại có phải là người sở hữu tài khoản không
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String currentUsername = authentication.getName();
        if (!currentUsername.equals(username)) {
            throw new RuntimeException("You can only view your own profile");
        }
        userService.updateProfile(user, username);
        return ResponseEntity.ok(user);
    }

    // delete user
    // url: localhost:8080/users/username
    @DeleteMapping("/{username}")
    @PreAuthorize("hasAnyRole('ADMIN')")
    public ResponseEntity<ApiResponse> deleteUser(@PathVariable String username) {
        User user = userRepository.findByUsername(username).orElseThrow(() -> new RuntimeException("User not found: " + username));
        user.setDeletedAt(LocalDateTime.now());
        userService.update(user);
        return ResponseEntity.ok(new ApiResponse(true, "User deleted successfully!"));
    }






}
