package org.example.healthcare_management.services;

import org.example.healthcare_management.controllers.dto.DoctorDto;
import org.example.healthcare_management.entities.Doctor;

public interface DoctorService {
     DoctorDto updateProfile(DoctorDto doctorDto, String username);
     DoctorDto getDoctorProfile(String username);
}
