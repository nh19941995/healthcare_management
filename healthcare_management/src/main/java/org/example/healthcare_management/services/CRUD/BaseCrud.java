package org.example.healthcare_management.services.CRUD;

import java.util.Optional;

public interface BaseCrud<T,O> {
    O create(T entity);
    Optional<T> findById(Long id);
    O update(Long id, O dtoEntity);
    void delete(Long id);
    boolean exists(Long id);
}
