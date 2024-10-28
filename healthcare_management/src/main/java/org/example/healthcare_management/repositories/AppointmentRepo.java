package org.example.healthcare_management.repositories;

import org.example.healthcare_management.entities.Appointment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.web.bind.annotation.CrossOrigin;

@CrossOrigin(origins = "*")
public interface AppointmentRepo extends JpaRepository<Appointment, Long> {
}
