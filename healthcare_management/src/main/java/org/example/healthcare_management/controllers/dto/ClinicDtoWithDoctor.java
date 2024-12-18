package org.example.healthcare_management.controllers.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.Set;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ClinicDtoWithDoctor {
    private Long id;
    private String name;
    private String address;
    private String phone;
    private String description;
    private String image;
    private LocalDateTime createdAt;
    private Set<DoctorDto> doctorsDto;
}
