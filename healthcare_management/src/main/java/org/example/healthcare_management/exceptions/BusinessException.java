package org.example.healthcare_management.exceptions;


import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
public class BusinessException extends RuntimeException {
    private final String details;
    private final HttpStatus status;

    public BusinessException(String message, String details, HttpStatus status) {
        super(message);
        this.details = details;
        this.status = status;
    }
}
