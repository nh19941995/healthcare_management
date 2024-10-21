package org.example.healthcare_management.controllers;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class UserController {

//    private final UserRepo userRepository;

//    public UserController(UserRepo userRepository) {
//        this.userRepository = userRepository;
//    }

//    @GetMapping
////    @PreAuthorize("hasRole('ADMIN')")
//    public List<User> getAllUsers() {
//        return userRepository.findAll();
//    }

//    @GetMapping("/{id}")
////    @PreAuthorize("hasAnyRole('USER', 'ADMIN')")
//    public ResponseEntity<User> getUserById(@PathVariable Long id) {
//        User user = userRepository.findById(id)
//                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + id));
//        return ResponseEntity.ok(user);
//    }

    // Thêm các endpoint khác theo nhu cầu
}
