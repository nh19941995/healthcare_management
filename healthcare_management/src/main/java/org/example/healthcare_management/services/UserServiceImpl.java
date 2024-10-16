package org.example.healthcare_management.services;

import org.example.healthcare_management.entities.User;
import org.example.healthcare_management.repositories.UserRepo;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class UserServiceImpl implements UserService {
    private final RoleService roleService;
    private final UserRepo userRepository;

    public UserServiceImpl(UserRepo userRepository, RoleService roleService) {
        this.userRepository = userRepository;
        this.roleService = roleService;
    }

    @Override
    public long count() {
        return userRepository.count();
    }

    @Override
    public void delete(Long id) {
        userRepository.deleteById(id);
    }

    @Override
    public void delete(User user) {
        userRepository.delete(user);
    }

    @Override
    public Optional<User> findById(Long id) {
        return userRepository.findById(id);
    }

    @Override
    public Iterable<User> findAll() {
        return userRepository.findAll();
    }

    @Override
    public User save(User user) {
//        user.setRole(
//                roleService.findById(1L).orElseThrow(() -> new RuntimeException("Role not found"))
//        );
        // lấy ra LocalDateTime hiện tại và gán cho createdAt
        if (user.getCreatedAt() == null){
            user.setCreatedAt(java.time.LocalDateTime.now());
        }else {
            user.setUpdatedAt(java.time.LocalDateTime.now());
        }
        return userRepository.save(user);
    }
}
