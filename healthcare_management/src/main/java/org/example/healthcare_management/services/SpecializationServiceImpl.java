package org.example.healthcare_management.services;

import org.example.healthcare_management.repositories.SpecializationRepo;
import org.springframework.stereotype.Service;

@Service
public class SpecializationServiceImpl implements SpecializationService{

    private final SpecializationRepo specializationRepo;

    public SpecializationServiceImpl(SpecializationRepo specializationRepo) {
        this.specializationRepo = specializationRepo;
    }


}
