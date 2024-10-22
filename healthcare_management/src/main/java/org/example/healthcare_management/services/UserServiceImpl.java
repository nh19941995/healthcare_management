package org.example.healthcare_management.services;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.healthcare_management.entities.Role;
import org.example.healthcare_management.entities.User;
import org.example.healthcare_management.repositories.UserRepo;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@Slf4j
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {
    private final UserRepo userRepository;

    @Override
    public User save(User user) {
        log.info("Saving new user {} to the database", user.getName());
        return userRepository.save(user);
    }

    @Transactional
    @Override
    public User update(User user) {
        log.info("Updating user {} in the database", user.getName());
        return userRepository.save(user);
    }

    @Override
    public User findById(Long id) {
        log.info("Fetching user with id {}", id);
        Optional<User> user = userRepository.findById(id);
        return user.orElse(null);
    }

    @Override
    public List<User> findAll() {
        log.info("Fetching all users");
        return userRepository.findAll();
    }

    @Transactional
    @Override
    public void delete(Long id) {
        log.info("Deleting user with id {}", id);
        userRepository.deleteById(id);
    }

    @Transactional
    @Override
    public void addRoleToUser(User user, Role role) {
        if (user != null && role != null) {
            log.info("Adding role {} to user {}", role.getName(), user.getName());
            user.addRole(role);
            userRepository.save(user);
        } else {
            log.warn("Attempted to add null role to user or add role to null user");
        }
    }

    @Transactional
    @Override
    public void removeRoleFromUser(User user, Role role) {
        if (user != null && role != null) {
            log.info("Removing role {} from user {}", role.getName(), user.getName());
            user.removeRole(role);
            userRepository.save(user);
        } else {
            log.warn("Attempted to remove null role from user or remove role from null user");
        }
    }
}
