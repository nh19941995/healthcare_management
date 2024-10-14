package org.example.healthcare_management.services.crud;

public interface Delete<T> {
    void delete(Long id);
    void delete(T t);
}
