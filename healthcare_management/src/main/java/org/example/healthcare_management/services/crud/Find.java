package org.example.healthcare_management.services.crud;

import java.util.Optional;

public interface Find <T> {
    Optional<T> findById(Long id);
}
