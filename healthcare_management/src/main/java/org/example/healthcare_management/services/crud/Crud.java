package org.example.healthcare_management.services.crud;

public interface Crud<T> extends
        Delete<T>,
        Find<T>,
        FindAll<T>,
        Save<T>,
        Count
{

}
