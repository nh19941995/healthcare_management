package org.example.healthcare_management.exceptions.payload;


import lombok.AllArgsConstructor;
import lombok.Data;

import java.time.LocalDateTime;

// lớp này chứa thông tin lỗi trả về cho client

@Data
@AllArgsConstructor
public class ErrorResponse {
    private LocalDateTime timestamp;
    private String message;
    private String details;
    private int status;

    public ErrorResponse(String message, String details, int status) {
        this.timestamp = LocalDateTime.now();
        this.message = message;
        this.details = details;
        this.status = status;
    }
}
