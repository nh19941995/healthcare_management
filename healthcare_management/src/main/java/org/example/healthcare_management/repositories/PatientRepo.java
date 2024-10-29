package org.example.healthcare_management.repositories;

import org.example.healthcare_management.entities.Patient;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PatientRepo extends JpaRepository<Patient, Long> {
}
