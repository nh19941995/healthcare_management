package org.example.healthcare_management.security;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

@Component("userSecurity")
public class UserSecurity {

    public boolean isCurrentUser(String username) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null) {
            return false;
        }

        Object principal = authentication.getPrincipal();

        // Kiểm tra các trường hợp của principal
        if (principal instanceof UserDetails) {
            return ((UserDetails) principal).getUsername().equals(username);
        } else if (principal instanceof String) {
            return principal.equals(username);
        }

        return false;
    }
}
