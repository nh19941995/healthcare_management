package org.example.healthcare_management.controllers;

import jakarta.validation.constraints.Pattern;
import lombok.AllArgsConstructor;
import org.example.healthcare_management.controllers.dto.ApiResponse;
import org.example.healthcare_management.services.UserService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@AllArgsConstructor
@RequestMapping("/admin")
public class AdminController {
    private final UserService userService;

    // url: localhost:8080/admin/updateRole/ababab@A111/ADMIN
//    @PutMapping("/updateRole/{userName}/{roleName}")
//    @PreAuthorize("hasRole('ADMIN')")
//    public ResponseEntity<ApiResponse> roleUpdate(
//            @PathVariable String userName,
//            @PathVariable @Pattern(regexp = "^(ADMIN|DOCTOR|PATIENT)$", message = "Invalid role name") String roleName
//    ) {
//        userService.addRoleToUser(userName, roleName);
//        return ResponseEntity.ok(new ApiResponse(true, "Role updated successfully!"));
//    }




}
