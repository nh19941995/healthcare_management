package org.example.healthcare_management.services;

import org.example.healthcare_management.entities.Role;
import org.example.healthcare_management.entities.User;

import java.util.List;

public interface UserService {
    User save(User user);
    User update(User user);
    User findById(Long id);
//    User findByUsername(String username);
    List<User> findAll();
    void delete(Long id);
    void addRoleToUser(String username, String roleName);
    void removeRoleFromUser(User user, Role role);

}
