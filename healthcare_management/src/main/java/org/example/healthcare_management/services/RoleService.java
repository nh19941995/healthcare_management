package org.example.healthcare_management.services;

import org.example.healthcare_management.entities.Role;
import org.example.healthcare_management.services.crud.Count;
import org.example.healthcare_management.services.crud.FindAll;
import org.example.healthcare_management.services.crud.Save;

public interface RoleService extends Save<Role>, FindAll<Role>, Count {
}
