package org.example.healthcare_management.services.CRUD;

public interface BaseCrud<T,O> {
    T findById(Long id);
    O update(Long id, O dtoEntity);
    void delete(Long id);
    boolean exists(Long id);
}
