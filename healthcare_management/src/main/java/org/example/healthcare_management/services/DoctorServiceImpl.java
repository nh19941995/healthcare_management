package org.example.healthcare_management.services;

import lombok.AllArgsConstructor;
import org.example.healthcare_management.entities.Doctor;
import org.example.healthcare_management.entities.User;
import org.example.healthcare_management.repositories.DoctorRepo;
import org.example.healthcare_management.repositories.UserRepo;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
public class DoctorServiceImpl implements DoctorService {
    UserRepo userRepo;
    private final DoctorRepo doctorRepo;

    @Override
    public void updateProfile(Doctor doctor, String username) {
        User user = userRepo.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
        Doctor oldDoctor = user.getDoctor();
        if (oldDoctor != null) {
            oldDoctor = doctor;
            doctorRepo.save(oldDoctor);
        }
    }
}
