package org.example.healthcare_management.controllers.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.example.healthcare_management.enums.Status;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class DoctorDtoInDetailClinic {
    private Long id;
    private String achievements;
    private String medicalTraining;
    private Long clinicId;
    private Long specializationId;
    private Status status;
    private String lockReason;
    private String username;
    private String avatar;
}
