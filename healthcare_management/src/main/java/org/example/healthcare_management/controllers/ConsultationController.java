package org.example.healthcare_management.controllers;


import lombok.AllArgsConstructor;
import org.example.healthcare_management.entities.Consultation;
import org.example.healthcare_management.services.ConsultationService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/consultations")
@AllArgsConstructor
public class ConsultationController {

    private final ConsultationService consultationService;


    // URL: http://localhost:8080/api/consultations
    @GetMapping("")
    public ResponseEntity<Page<Consultation>> findAll(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size
    ) {
        Pageable pageable = Pageable.ofSize(size).withPage(page);
        return ResponseEntity.ok(consultationService.findAll(pageable));
    }


}
