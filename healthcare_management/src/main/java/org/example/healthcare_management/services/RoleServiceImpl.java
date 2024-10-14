package org.example.healthcare_management.services;

import org.example.healthcare_management.entities.Role;
import org.example.healthcare_management.repositories.RoleRepo;
import org.springframework.stereotype.Service;

@Service
public class RoleServiceImpl implements RoleService{
    private final RoleRepo roleRepo;

    public RoleServiceImpl(RoleRepo roleRepo) {
        this.roleRepo = roleRepo;
    }


    @Override
    public long count() {
        return roleRepo.count();
    }

    @Override
    public Iterable<Role> findAll() {
        return roleRepo.findAll();
    }

    @Override
    public Role save(Role role) {
        return roleRepo.save(role);
    }
}
