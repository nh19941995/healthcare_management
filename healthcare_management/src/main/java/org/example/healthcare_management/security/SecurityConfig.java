package org.example.healthcare_management.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.provisioning.JdbcUserDetailsManager;
import org.springframework.security.provisioning.UserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;

import javax.sql.DataSource;

@Configuration
public class SecurityConfig {
    @Bean
    public UserDetailsManager userDetailsManager(DataSource dataSource) {
        JdbcUserDetailsManager theUserDetailsManager = new JdbcUserDetailsManager(dataSource);

        // Câu lệnh SQL để lấy thông tin user
        theUserDetailsManager
            .setUsersByUsernameQuery(
                "SELECT username, password, CASE WHEN status = 'ACTIVE' THEN 1 ELSE 0 END as enabled " +
                        "FROM users WHERE username = ?"
            );

        // Câu lệnh SQL để lấy thông tin role của user
        theUserDetailsManager
            .setAuthoritiesByUsernameQuery(
                "SELECT users.username, CONCAT('ROLE_', roles.name) as authority " +
                        "FROM users INNER JOIN roles ON users.role_id = roles.id " +
                        "WHERE users.username = ?"
            );
        return theUserDetailsManager;
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http.authorizeHttpRequests(authorize -> authorize
                // users
                .requestMatchers(HttpMethod.GET, "/users").hasAnyRole("PATIENT", "DOCTOR", "ADMIN")
                .requestMatchers(HttpMethod.GET, "/users/**").hasAnyRole("PATIENT", "DOCTOR", "ADMIN")
                .requestMatchers(HttpMethod.POST, "/users").hasAnyRole("PATIENT", "DOCTOR", "ADMIN")
                .requestMatchers(HttpMethod.PUT, "/users").hasAnyRole( "DOCTOR", "ADMIN")
                .requestMatchers(HttpMethod.DELETE, "/users/{id}").hasRole("ADMIN")
                .anyRequest().authenticated()


        );

        http.httpBasic(Customizer.withDefaults());
        http.csrf(csrf -> csrf.disable());

        return http.build();
    }
}
