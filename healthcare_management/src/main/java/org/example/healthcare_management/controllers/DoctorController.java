package org.example.healthcare_management.controllers;

import lombok.AllArgsConstructor;
import org.example.healthcare_management.controllers.dto.DoctorDto;
import org.example.healthcare_management.repositories.UserRepo;
import org.example.healthcare_management.services.DoctorService;
import org.modelmapper.ModelMapper;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

@RestController
@AllArgsConstructor
@RequestMapping("/api/doctors")
public class DoctorController {
    private final DoctorService doctorService;
    private final UserRepo userRepo;
    private final ModelMapper modelMapper;


    // url: localhost:8080/api/doctors/username
    @PutMapping("/{username}")
    public ResponseEntity<DoctorDto> updateProfile(
            @RequestBody DoctorDto doctorDto,@PathVariable String username
    ) {
        // Kiểm tra xem người dùng hiện tại có phải là người sở hữu tài khoản không
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String currentUsername = authentication.getName();

        if (!currentUsername.equals(username)) {
            throw new RuntimeException("You can only view your own profile");
        }
        doctorService.updateProfile(doctorDto, username);
        return ResponseEntity.ok(doctorDto);
    }

    // url: localhost:8080/api/doctors/username
    @GetMapping("/{username}")
    public ResponseEntity<DoctorDto> getDoctorProfile(@PathVariable String username) {
        // Kiểm tra xem người dùng hiện tại có phải là người sở hữu tài khoản không
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String currentUsername = authentication.getName();

        if (!currentUsername.equals(username)) {
            throw new RuntimeException("You can only view your own profile");
        }
        DoctorDto doctorDto = doctorService.getDoctorProfile(username);
        return ResponseEntity.ok(doctorDto);
    }





}
