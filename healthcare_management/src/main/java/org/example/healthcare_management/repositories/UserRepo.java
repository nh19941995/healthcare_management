package org.example.healthcare_management.repositories;

import org.example.healthcare_management.entities.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepo extends JpaRepository<User, Long> {
}
