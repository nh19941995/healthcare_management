package org.example.healthcare_management.services;

import org.example.healthcare_management.repositories.PatientStatusRepo;
import org.springframework.stereotype.Service;

@Service
public class PatientStatusServiceImpl implements PatientStatusService {
    private final PatientStatusRepo patientStatusRepo;

    public PatientStatusServiceImpl(PatientStatusRepo patientStatusRepo) {
        this.patientStatusRepo = patientStatusRepo;
    }


}
