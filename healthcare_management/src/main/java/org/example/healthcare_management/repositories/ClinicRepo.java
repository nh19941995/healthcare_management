package org.example.healthcare_management.repositories;

import org.example.healthcare_management.entities.Clinic;
import org.example.healthcare_management.entities.Doctor;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.web.bind.annotation.CrossOrigin;

@CrossOrigin(origins = "*")
public interface ClinicRepo extends JpaRepository<Clinic, Long> {
}
