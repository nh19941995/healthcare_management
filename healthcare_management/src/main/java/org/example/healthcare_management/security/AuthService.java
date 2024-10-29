package org.example.healthcare_management.security;

import jakarta.transaction.Transactional;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.healthcare_management.entities.Patient;
import org.example.healthcare_management.entities.Role;
import org.example.healthcare_management.entities.User;
import org.example.healthcare_management.enums.EnumRole;
import org.example.healthcare_management.enums.Status;
import org.example.healthcare_management.exceptions.BusinessException;
import org.example.healthcare_management.repositories.PatientRepo;
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

import java.util.Set;

@Service
@Slf4j
@AllArgsConstructor
public class AuthService {
    private final PatientRepo patientRepository;
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
    private final RoleRepo roleRepository;

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
    @Transactional
    public void register(User user) {
        log.info("Service - Register request for user: {}", user);

        // Kiểm tra xem username đã tồn tại chưa
        userService.checkUsernameExistence(user.getUsername());

        // Đặt trạng thái tài khoản là ACTIVE và mã hóa mật khẩu
        user.setStatus(Status.ACTIVE);
        user.setPassword(passwordEncoder.encode(user.getPassword()));

        // Tạo Patient và liên kết với User
        Patient patient = new Patient();
        patient.setUser(user);
        user.setPatient(patient); // liên kết hai chiều nếu cần thiết

        // Lưu User và Patient cùng lúc thông qua cascading
        userRepository.save(user);

        // Tạo vai trò bệnh nhân cho người dùng
        Role role = roleRepository.findByName(EnumRole.PATIENT.getRoleName())
                .orElseThrow(() -> new BusinessException("Role not found",
                        "No role found with name: " + EnumRole.PATIENT.getRoleName(),
                        HttpStatus.NOT_FOUND));
        user.setRoles(Set.of(role));

        userRepository.save(user);

        log.info("Service - Registration completed successfully for user: {}", user);
    }

}
