package org.example.healthcare_management.services;

import org.example.healthcare_management.entities.Consultation;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.lang.NonNull;

public interface ConsultationService {
    Page<Consultation> findAll(@NonNull Pageable pageable);
}
