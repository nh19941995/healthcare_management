package org.example.healthcare_management.services;

import lombok.AllArgsConstructor;
import org.example.healthcare_management.entities.Role;
import org.example.healthcare_management.repositories.RoleRepo;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public interface RoleService {
    Role findByName(String name);
}
