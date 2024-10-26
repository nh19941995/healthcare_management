package org.example.healthcare_management.controllers;

import lombok.AllArgsConstructor;
import org.example.healthcare_management.controllers.dto.ApiResponse;
import org.example.healthcare_management.entities.Doctor;
import org.example.healthcare_management.entities.User;
import org.example.healthcare_management.services.DoctorService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

@RestController
@AllArgsConstructor
@RequestMapping("/api/doctors")
public class DoctorController {
    private final DoctorService doctorService;


    // url: localhost:8080/api/doctors/updateProfile/username
    @PutMapping("/updateProfile/{username}")
    public ResponseEntity<ApiResponse> updateProfile(
            @RequestBody Doctor doctor,@PathVariable String username
    ) {
        // Kiểm tra xem người dùng hiện tại có phải là người sở hữu tài khoản không
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String currentUsername = authentication.getName();

        if (!currentUsername.equals(username)) {
            throw new RuntimeException("You can only view your own profile");
        }

        doctorService.updateProfile(doctor, username);
        return ResponseEntity.ok(
                new ApiResponse(true, "Profile updated successfully!"));
    }




}
