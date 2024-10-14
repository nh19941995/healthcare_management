package org.example.healthcare_management.services;

import org.example.healthcare_management.entities.PatientStatus;
import org.example.healthcare_management.services.crud.Count;
import org.example.healthcare_management.services.crud.FindAll;
import org.example.healthcare_management.services.crud.Save;

public interface PatientStatusService extends Save<PatientStatus>, FindAll<PatientStatus>, Count {
}
