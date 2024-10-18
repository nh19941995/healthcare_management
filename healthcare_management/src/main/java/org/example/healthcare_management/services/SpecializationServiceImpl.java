package org.example.healthcare_management.services;

import org.example.healthcare_management.entities.Specialization;
import org.example.healthcare_management.repositories.SpecializationRepo;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class SpecializationServiceImpl implements SpecializationService{

    private final SpecializationRepo specializationRepo;

    public SpecializationServiceImpl(SpecializationRepo specializationRepo) {
        this.specializationRepo = specializationRepo;
    }


}
