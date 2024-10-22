package org.example.healthcare_management.security;

import jakarta.persistence.EntityNotFoundException;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.healthcare_management.controllers.dto.UserRegister;
import org.example.healthcare_management.entities.Role;
import org.example.healthcare_management.entities.User;
import org.example.healthcare_management.enums.Status;
import org.example.healthcare_management.repositories.RoleRepo;
import org.example.healthcare_management.repositories.UserRepo;
import org.example.healthcare_management.services.RoleService;
import org.example.healthcare_management.services.UserService;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.stereotype.Service;

@Service
@Slf4j
@AllArgsConstructor
public class AuthService {
    private final RoleRepo roleRepo;
    private final UserService userService;
    // dùng để thực hiện các thao tác liên quan đến User
    private final UserRepo userRepository;
    // dùng để mã hóa mật khẩu
    private final PasswordEncoder passwordEncoder;
    // dùng để tạo và kiểm tra token
    private final JwtTokenUtil jwtTokenUtil;
    // dùng để load thông tin User
    private final UserDetailsService userDetailsService;
    // dùng để thực hiện xác thực người dùng
    private final AuthenticationManager authenticationManager;

    // đăng nhập
    public String login(String username, String password) throws Exception {
        log.info("Login request for user: {}", username);
        try {
            // xác thực người dùng với username và password
            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(username, password)
            );
            // Nếu xác thực thành công, set authentication vào SecurityContext.
            SecurityContextHolder.getContext().setAuthentication(authentication);
        } catch (DisabledException e) {
            // nếu tài khoản bị vô hiệu hóa
            throw new Exception("USER_DISABLED", e);
        } catch (BadCredentialsException e) {
            // nếu username hoặc password không đúng
            throw new Exception("INVALID_CREDENTIALS", e);
        }
        // xác thực thành công, tạo token và trả về cho người dùng
        final UserDetails userDetails = userDetailsService.loadUserByUsername(username);
        return jwtTokenUtil.generateToken(userDetails);
    }

    // đăng ký tài khoản
    public User register(UserRegister userRegister) {
        log.info("Service - Register request for userRegister: {}", userRegister);
        userRepository.findByUsername(userRegister.getUsername()).ifPresent(u -> {
            throw new RuntimeException("Username already exists");
        });
        User newUser = userRegister.toUser();
        // mặc định role của user mới là PATIENT
        Role patientRole = roleRepo.findByName("PATIENT").orElseThrow(() -> new EntityNotFoundException("Role not found"));
        userService.addRoleToUser(newUser, patientRole);

        newUser.setStatus(Status.ACTIVE);
        log.info("Service - Register request for user: {}", newUser);
        // mã hóa mật khẩu trước khi lưu vào database
        newUser.setPassword(passwordEncoder.encode(userRegister.getPassword()));
        // Lưu user mới vào database thông qua UserRepo.
        return userRepository.save(newUser);
    }
}
