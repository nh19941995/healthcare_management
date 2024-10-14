package org.example.healthcare_management.services;

import org.example.healthcare_management.entities.PatientStatus;
import org.example.healthcare_management.repositories.PatientStatusRepo;
import org.springframework.stereotype.Service;

@Service
public class PatientStatusServiceImpl implements PatientStatusService {
    private final PatientStatusRepo patientStatusRepo;

    public PatientStatusServiceImpl(PatientStatusRepo patientStatusRepo) {
        this.patientStatusRepo = patientStatusRepo;
    }

    @Override
    public long count() {
        return patientStatusRepo.count();
    }

    @Override
    public Iterable<PatientStatus> findAll() {
        return patientStatusRepo.findAll();
    }

    @Override
    public PatientStatus save(PatientStatus patientStatus) {
        return patientStatusRepo.saveAndFlush(patientStatus);
    }
}
