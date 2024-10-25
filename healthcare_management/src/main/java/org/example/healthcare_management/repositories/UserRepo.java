package org.example.healthcare_management.repositories;

import org.example.healthcare_management.entities.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.lang.NonNull;


import java.util.Optional;

@CrossOrigin(origins = "*")
public interface UserRepo extends JpaRepository<User, Long> {
    Optional<User> findByUsername(String username);

    @Override
    @NonNull
    Page<User> findAll(@NonNull Pageable pageable);
}
