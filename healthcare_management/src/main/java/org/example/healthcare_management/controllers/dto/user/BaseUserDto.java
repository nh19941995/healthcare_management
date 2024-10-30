package org.example.healthcare_management.controllers.dto.user;

import lombok.Data;
import org.example.healthcare_management.entities.User;

import java.io.Serializable;

@Data
public class BaseUserDto implements Serializable {
    private Long id;
    private String fullname;
    private String email;

    public BaseUserDto(User user) {
        this.id = user.getId();
        this.fullname = user.getFullName();
        this.email = user.getEmail();
    }
}
