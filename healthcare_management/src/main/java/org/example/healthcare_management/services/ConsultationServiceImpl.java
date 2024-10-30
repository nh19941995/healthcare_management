package org.example.healthcare_management.services;

import lombok.AllArgsConstructor;
import lombok.NonNull;
import org.example.healthcare_management.entities.Consultation;
import org.example.healthcare_management.repositories.ConsultationRepo;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
public class ConsultationServiceImpl implements ConsultationService {
    private final ConsultationRepo consultationRepo;


    @Override
    public Page<Consultation> findAll(@NonNull Pageable pageable) {
        return consultationRepo.findAll(pageable);
    }
}
