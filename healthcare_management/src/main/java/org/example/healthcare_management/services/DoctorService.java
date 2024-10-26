package org.example.healthcare_management.services;

import org.example.healthcare_management.controllers.dto.DoctorDto;
import org.example.healthcare_management.entities.Doctor;

public interface DoctorService {
     void updateProfile(DoctorDto doctor, String username);
     DoctorDto getDoctorProfile(String username);
}
