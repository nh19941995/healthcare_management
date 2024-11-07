package org.example.healthcare_management.controllers;

import lombok.AllArgsConstructor;
import org.example.healthcare_management.controllers.dto.ClinicDtoNoDoctor;
import org.example.healthcare_management.controllers.dto.ClinicDtoWithDoctor;
import org.example.healthcare_management.entities.Clinic;
import org.example.healthcare_management.repositories.ClinicRepo;
import org.modelmapper.ModelMapper;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RequestMapping("/api/clinics")
@RestController
@AllArgsConstructor
public class ClinicController {
    private final ClinicRepo clinicRepository;
    private final ModelMapper modelMapper;

    // url: localhost:8080/api/clinics
    @GetMapping("")
    public ResponseEntity<List<ClinicDtoNoDoctor>> getAllClinics() {
        List<Clinic> clinics = clinicRepository.findAll();
        List<ClinicDtoNoDoctor> clinicDtoWithDoctor = clinics.stream()
                .map(clinic -> modelMapper.map(clinic, ClinicDtoNoDoctor.class))
                .toList();
        return ResponseEntity.ok(clinicDtoWithDoctor);
    }

    // url: localhost:8080/api/clinics/1
    @GetMapping("/{id}")
    public ResponseEntity<ClinicDtoWithDoctor> getClinicById(@PathVariable Long id) {
        Clinic clinic = clinicRepository.findById(id).orElseThrow(() -> new RuntimeException("Clinic not found: " + id));
        ClinicDtoWithDoctor ClinicDtoWithDoctor = modelMapper.map(clinic, ClinicDtoWithDoctor.class);
        return ResponseEntity.ok(ClinicDtoWithDoctor);
    }


}
