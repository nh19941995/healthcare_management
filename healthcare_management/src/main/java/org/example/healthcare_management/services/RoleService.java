package org.example.healthcare_management.services;

import org.example.healthcare_management.entities.Role;
import org.springframework.stereotype.Service;


@Service
public interface RoleService {
    Role findByName(String name);

    void checkUserRole(String username, String roleName);

}
