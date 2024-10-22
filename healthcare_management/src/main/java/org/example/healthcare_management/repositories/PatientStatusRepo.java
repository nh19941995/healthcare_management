package org.example.healthcare_management.repositories;

import org.example.healthcare_management.entities.PatientStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.web.bind.annotation.CrossOrigin;

@CrossOrigin(origins = "*")
public interface PatientStatusRepo extends JpaRepository<PatientStatus, Long> {
}
