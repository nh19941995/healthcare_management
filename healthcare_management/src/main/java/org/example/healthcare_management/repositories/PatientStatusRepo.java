package org.example.healthcare_management.repositories;

import org.example.healthcare_management.entities.PatientStatus;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PatientStatusRepo extends JpaRepository<PatientStatus, Long> {
}
