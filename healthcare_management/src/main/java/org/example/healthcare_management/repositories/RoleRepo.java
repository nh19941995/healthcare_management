package org.example.healthcare_management.repositories;

import org.example.healthcare_management.entities.Role;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RoleRepo extends JpaRepository<Role, Long> {
}
