package org.example.healthcare_management.services;

import org.example.healthcare_management.entities.Role;
import org.example.healthcare_management.repositories.RoleRepo;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class RoleServiceImpl implements RoleService{
    private final RoleRepo roleRepo;

    public RoleServiceImpl(RoleRepo roleRepo) {
        this.roleRepo = roleRepo;
    }



}
