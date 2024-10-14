package org.example.healthcare_management.configs;

import jakarta.annotation.PostConstruct;
import jakarta.transaction.Transactional;
import org.example.healthcare_management.entities.Role;
import org.example.healthcare_management.entities.User;
import org.example.healthcare_management.services.RoleService;
import org.example.healthcare_management.services.UserService;
import org.springframework.stereotype.Component;

@Component
public class DataInitializer {
    private final UserService userService;
    private final RoleService roleService;



    public DataInitializer(UserService userService, RoleService roleService) {
        this.userService = userService;
        this.roleService = roleService;
    }

    @PostConstruct
    @Transactional
    public void init() {
        if (roleService.count() == 0){
            roleService.save(new Role("ADMIN", "Admin role"));
            roleService.save(new Role("DOCTOR", "Doctor role"));
            roleService.save(new Role("PATIENT", "Patient role"));
        }
    }
}
