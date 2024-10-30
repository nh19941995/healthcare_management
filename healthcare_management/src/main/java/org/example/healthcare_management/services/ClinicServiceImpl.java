package org.example.healthcare_management.services;

import lombok.AllArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
public class ClinicServiceImpl implements ClinicService {

    private final ModelMapper modelMapper;


}
