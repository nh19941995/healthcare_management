package org.example.healthcare_management.services;

import lombok.AllArgsConstructor;
import org.example.healthcare_management.entities.Role;
import org.example.healthcare_management.entities.User;
import org.example.healthcare_management.exceptions.ResourceNotFoundException;
import org.example.healthcare_management.repositories.RoleRepo;
import org.springframework.stereotype.Service;


@Service
@AllArgsConstructor
public class RoleServiceImpl implements RoleService{
    private final RoleRepo roleRepo;
    private final UserService userService;

    @Override
    public Role findByName(String roleName) {
        return roleRepo.findByName(roleName).orElseThrow(() -> new ResourceNotFoundException("roleName", "roleName", roleName));
    }

    @Override
    public void checkUserRole(String username, String roleName) {
        User user = userService.findByUsername(username);
        Role role = this.findByName(roleName);
        if (!user.getRoles().contains(role)) {
            throw new ResourceNotFoundException("role", "role", roleName);
        }
    }
}
