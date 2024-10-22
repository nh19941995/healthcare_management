package org.example.healthcare_management.services;

import lombok.AllArgsConstructor;
import org.example.healthcare_management.entities.Role;
import org.example.healthcare_management.repositories.RoleRepo;
import org.springframework.data.rest.webmvc.ResourceNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@AllArgsConstructor
public class RoleServiceImpl implements RoleService{
    private final RoleRepo roleRepo;

    @Override
    public Role findByName(String name) {
        return roleRepo.findByName(name).orElseThrow(() -> new ResourceNotFoundException("Role not found"));
    }
}
