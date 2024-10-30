package org.example.healthcare_management.repositories;

import org.example.healthcare_management.entities.Consultation;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.lang.NonNull;
import org.springframework.web.bind.annotation.CrossOrigin;

@CrossOrigin(origins = "*")
public interface ConsultationRepo extends JpaRepository<Consultation, Long> {

    @Override
    @NonNull
    Page<Consultation> findAll(@NonNull Pageable pageable);
}
