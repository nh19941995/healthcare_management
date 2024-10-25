package org.example.healthcare_management.services;

import lombok.AllArgsConstructor;
import org.example.healthcare_management.entities.Role;
import org.example.healthcare_management.exceptions.ResourceNotFoundException;
import org.example.healthcare_management.repositories.RoleRepo;
import org.springframework.stereotype.Service;


@Service
@AllArgsConstructor
public class RoleServiceImpl implements RoleService{
    private final RoleRepo roleRepo;

    @Override
    public Role findByName(String roleName) {
        return roleRepo.findByName(roleName).orElseThrow(() -> new ResourceNotFoundException("roleName", "roleName", roleName));
    }
}
