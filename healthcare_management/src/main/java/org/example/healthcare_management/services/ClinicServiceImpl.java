package org.example.healthcare_management.services;

import lombok.AllArgsConstructor;
import org.example.healthcare_management.controllers.dto.ClinicDtoWithDoctor;
import org.example.healthcare_management.entities.Clinic;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

import java.util.Set;
import java.util.stream.Collectors;

@Service
@AllArgsConstructor
public class ClinicServiceImpl implements ClinicService {

    private final ModelMapper modelMapper;


}
