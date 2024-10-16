package org.example.healthcare_management.repositories;

import org.example.healthcare_management.entities.Specialization;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SpecializationRepo extends JpaRepository<Specialization, Long> {
}
