package org.example.healthcare_management.rest;

import org.example.healthcare_management.entities.Role;
import org.example.healthcare_management.services.RoleService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("")
public class Test {

    private final RoleService roleService;

    public Test(RoleService roleService) {
        this.roleService = roleService;
    }

    @GetMapping("/test")
    public Role test() {
        return roleService.findById(1L).orElseThrow(() -> new RuntimeException("Role not found"));
    }
}
