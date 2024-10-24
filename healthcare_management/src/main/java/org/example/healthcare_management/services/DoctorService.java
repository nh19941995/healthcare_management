package org.example.healthcare_management.services;

import org.example.healthcare_management.entities.Doctor;

public interface DoctorService {
    void updateProfile(Doctor doctor, String username);
}
