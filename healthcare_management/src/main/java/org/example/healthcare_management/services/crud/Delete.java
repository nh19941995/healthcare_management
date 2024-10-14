package org.example.healthcare_management.services.crud;

public interface Delete<T> {
    Long delete(Long id);
    Long delete(T t);
}
