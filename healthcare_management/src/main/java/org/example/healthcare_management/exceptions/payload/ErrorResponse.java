package org.example.healthcare_management.exceptions.payload;


import java.time.LocalDateTime;
import lombok.Data;
import lombok.AllArgsConstructor;

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
