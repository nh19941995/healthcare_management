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

    @Override
    public long count() {
        return specializationRepo.count();
    }

    @Override
    public Optional<Specialization> findById(Long id) {
        return specializationRepo.findById(id);
    }

    @Override
    public Iterable<Specialization> findAll() {
        return specializationRepo.findAll();
    }

    @Override
    public Specialization save(Specialization specialization) {
        // lấy ra LocalDateTime hiện tại và gán cho createdAt
        if (specialization.getCreatedAt() == null){
            specialization.setCreatedAt(java.time.LocalDateTime.now());
        }
        return specializationRepo.saveAndFlush(specialization);
    }
}
