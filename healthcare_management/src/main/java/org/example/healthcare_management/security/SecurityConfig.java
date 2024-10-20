package org.example.healthcare_management.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.provisioning.JdbcUserDetailsManager;
import org.springframework.security.provisioning.UserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import javax.sql.DataSource;
import java.util.Arrays;
import java.util.List;

@Configuration
@EnableWebSecurity
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
        http
                // kích hoạt CORS
                .cors(Customizer.withDefaults())
                // kích hoạt bảo mật cho các request
                .authorizeHttpRequests(authorize -> authorize
                    // public
                .requestMatchers("/public/**").permitAll()
                    // users
                .requestMatchers(HttpMethod.GET, "/users").hasAnyRole("PATIENT", "DOCTOR", "ADMIN")
                .requestMatchers(HttpMethod.GET, "/users/**").hasAnyRole("PATIENT", "DOCTOR", "ADMIN")
                .requestMatchers(HttpMethod.POST, "/users").hasAnyRole("PATIENT", "DOCTOR", "ADMIN")
                .requestMatchers(HttpMethod.PUT, "/users").hasAnyRole( "DOCTOR", "ADMIN")
                .requestMatchers(HttpMethod.DELETE, "/users/{id}").hasRole("ADMIN")

                .anyRequest().authenticated()


        );

        http.httpBasic(Customizer.withDefaults());
        http.csrf(AbstractHttpConfigurer::disable);

        return http.build();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOriginPatterns(List.of("*")); // Cho phép tất cả các origins
        configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        configuration.setAllowedHeaders(List.of("*"));
        configuration.setAllowCredentials(true);
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }
}
