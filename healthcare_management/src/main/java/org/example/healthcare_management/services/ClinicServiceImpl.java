package org.example.healthcare_management.services;

import lombok.AllArgsConstructor;
import org.example.healthcare_management.controllers.dto.ClinicDto;
import org.example.healthcare_management.entities.Clinic;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

import java.util.Set;
import java.util.stream.Collectors;

@Service
@AllArgsConstructor
public class ClinicServiceImpl implements ClinicService {

    private final ModelMapper modelMapper;

    @Override
    public Clinic convertToEntity(ClinicDto clinicDto) {
        return modelMapper.map(clinicDto, Clinic.class);
    }

    @Override
    public ClinicDto convertToDTO(Clinic clinic) {
        return modelMapper.map(clinic, ClinicDto.class);
    }

    @Override
    public Set<ClinicDto> convertToDTOs(Set<Clinic> clinics) {
        return clinics.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toSet());
    }

    @Override
    public Set<Clinic> convertToEntities(Set<ClinicDto> clinicDtos) {
        return clinicDtos.stream()
                .map(this::convertToEntity)
                .collect(Collectors.toSet());
    }
}
