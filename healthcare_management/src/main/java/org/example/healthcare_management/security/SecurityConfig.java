package org.example.healthcare_management.security;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity(prePostEnabled = true)
@Slf4j
@AllArgsConstructor
public class SecurityConfig {

    private final UserDetailsService userDetailsService;
    private final JwtRequestFilter jwtRequestFilter;
    private final JwtAuthenticationEntryPoint jwtAuthenticationEntryPoint;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authConfig) throws Exception {
        return authConfig.getAuthenticationManager();
    }
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .csrf(AbstractHttpConfigurer::disable) // Tắt CSRF
                .cors(Customizer.withDefaults()) // Tắt CORS
                // Xác thực tất cả các request
                .exceptionHandling(exception -> exception
                        .authenticationEntryPoint(jwtAuthenticationEntryPoint)
                )
                // Tắt quản lý session
                .sessionManagement(session -> session
                        .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                )
                // Cấu hình xác thực cho các request
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers(
                                "/auth/login",
                                "/auth/register",
                                "/api/public/**"  // Thêm endpoint này nếu bạn có các API công khai khác
                        ).permitAll()
                        // Đặt quy tắc phân quyền cho các endpoint của Spring Data REST

                        // User endpoint
                        .requestMatchers(HttpMethod.GET, "/users/**").permitAll()
                        .requestMatchers(HttpMethod.POST, "/users/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.PUT, "/users/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.DELETE, "/users/**").hasRole("ADMIN")
                        // Doctor endpoint
                        .requestMatchers(HttpMethod.GET, "/doctors/**").permitAll()
                        .requestMatchers(HttpMethod.POST, "/doctors/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.PUT, "/doctors/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.DELETE, "/doctors/**").hasRole("ADMIN")
                        // Patient endpoint
                        .requestMatchers(HttpMethod.GET, "/patients/**").permitAll()
                        .requestMatchers(HttpMethod.POST, "/patients/**").permitAll()
                        .requestMatchers(HttpMethod.PUT, "/patients/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.DELETE, "/patients/**").hasRole("ADMIN")
                        // Booking endpoint
                        .requestMatchers(HttpMethod.GET, "/bookings/**").permitAll()
                        .requestMatchers(HttpMethod.POST, "/bookings/**").hasRole("PATIENT")
                        .requestMatchers(HttpMethod.PUT, "/bookings/**").hasRole("PATIENT")
                        .requestMatchers(HttpMethod.DELETE, "/bookings/**").hasRole("PATIENT")
                        // clinic endpoint
                        .requestMatchers(HttpMethod.GET, "/clinics/**").permitAll()
                        .requestMatchers(HttpMethod.POST, "/clinics/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.PUT, "/clinics/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.DELETE, "/clinics/**").hasRole("ADMIN")
                        // role endpoint
                        .requestMatchers(HttpMethod.GET, "/roles/**").permitAll()
                        .requestMatchers(HttpMethod.POST, "/roles/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.PUT, "/roles/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.DELETE, "/roles/**").hasRole("ADMIN")
                        // shedule endpoint
                        .requestMatchers(HttpMethod.GET, "/schedules/**").permitAll()
                        .requestMatchers(HttpMethod.POST, "/schedules/**").hasRole("DOCTOR")
                        .requestMatchers(HttpMethod.PUT, "/schedules/**").hasRole("DOCTOR")
                        .requestMatchers(HttpMethod.DELETE, "/schedules/**").hasRole("DOCTOR")
                        // specializations endpoint
                        .requestMatchers(HttpMethod.GET, "/specializations/**").permitAll()
                        .requestMatchers(HttpMethod.POST, "/specializations/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.PUT, "/specializations/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.DELETE, "/specializations/**").hasRole("ADMIN")

                        .anyRequest().authenticated()
                )
                // Thêm Filter để xác thực token và set user vào SecurityContext
                .addFilterBefore(jwtRequestFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    // Nếu bạn có tài nguyên tĩnh cần bảo vệ, hãy giữ phương thức này
    @Bean
    public WebSecurityCustomizer webSecurityCustomizer() {
        return (web) -> web.ignoring().requestMatchers("/images/**", "/js/**", "/webjars/**");
    }
}