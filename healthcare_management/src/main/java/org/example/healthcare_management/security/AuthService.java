package org.example.healthcare_management.security;

import jakarta.persistence.EntityNotFoundException;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.healthcare_management.entities.Role;
import org.example.healthcare_management.entities.User;
import org.example.healthcare_management.enums.Status;
import org.example.healthcare_management.exceptions.BusinessException;
import org.example.healthcare_management.repositories.RoleRepo;
import org.example.healthcare_management.repositories.UserRepo;
import org.example.healthcare_management.services.UserService;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.*;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.password.PasswordEncoder;
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
            throw new LockedException("", e);
        } catch (BadCredentialsException e) {
            // nếu username hoặc password không đúng
            throw new BadCredentialsException("", e);
        }
        // xác thực thành công, tạo token và trả về cho người dùng
        final UserDetails userDetails = userDetailsService.loadUserByUsername(username);
        return jwtTokenUtil.generateToken(userDetails);
    }

    // đăng ký tài khoản
    public User register(User user) {
        log.info("Service - Register request for userRegister: {}", user);
        userRepository.findByUsername(user.getUsername()).ifPresent(u -> {
            // kiểm tra xem username đã tồn tại chưa
            throw new BusinessException(
                    "Username already exists",
                    "The username '" + user.getUsername() + "' is already taken. Please choose a different username.",
                    HttpStatus.CONFLICT);
        });

        // mặc định role của user mới là PATIENT
        Role patientRole = roleRepo.findByName("PATIENT").orElseThrow(() -> new EntityNotFoundException("Role not found"));
        userService.addRoleToUser(user, patientRole);

        user.setStatus(Status.ACTIVE);
        log.info("Service - Register request for user: {}", user);
        // mã hóa mật khẩu trước khi lưu vào database
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        // Lưu user mới vào database thông qua UserRepo.
        return userRepository.save(user);
    }
}
