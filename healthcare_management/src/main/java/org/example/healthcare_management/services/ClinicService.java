package org.example.healthcare_management.services;

import org.example.healthcare_management.controllers.dto.ClinicDto;
import org.example.healthcare_management.entities.Clinic;

import java.util.List;
import java.util.Set;

public interface ClinicService {
    Clinic convertToEntity(ClinicDto clinicDto);
    ClinicDto convertToDTO(Clinic clinic);
    Set<ClinicDto> convertToDTOs(Set<Clinic> clinics);
    Set<Clinic> convertToEntities(Set<ClinicDto> clinicDtos);
}
