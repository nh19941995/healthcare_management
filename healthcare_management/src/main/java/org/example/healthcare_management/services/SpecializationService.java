package org.example.healthcare_management.services;

import org.example.healthcare_management.entities.Specialization;
import org.example.healthcare_management.services.crud.Count;
import org.example.healthcare_management.services.crud.Find;
import org.example.healthcare_management.services.crud.FindAll;
import org.example.healthcare_management.services.crud.Save;

public interface SpecializationService extends Save<Specialization>, FindAll<Specialization>, Count, Find<Specialization> {
}
