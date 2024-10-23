package org.example.healthcare_management.controllers;

import lombok.AllArgsConstructor;
import org.example.healthcare_management.controllers.dto.ApiResponse;
import org.example.healthcare_management.entities.Role;
import org.example.healthcare_management.entities.User;
import org.example.healthcare_management.repositories.RoleRepo;
import org.example.healthcare_management.repositories.UserRepo;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

@RestController
@AllArgsConstructor
public class AdminController {
    private final UserRepo userRepository;
    private final RoleRepo roleRepository;

    // url: localhost:8080/admin/updateRole/ababab@A111/ADMIN
    @GetMapping("/admin/updateRole/{userName}/{roleName}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse> roleUpdate(@PathVariable String userName, @PathVariable String roleName) {
        User user = userRepository.findByUsername(userName).orElseThrow(() -> new RuntimeException("User not found: " + userName));
        Role newRole = roleRepository.findByName(roleName).orElseThrow(() -> new RuntimeException("Role not found: " + roleName));
        user.addRole(newRole);
        return ResponseEntity.ok(new ApiResponse(true, "Role updated successfully!"));
    }



}
