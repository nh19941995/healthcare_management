package org.example.healthcare_management.security;

import io.jsonwebtoken.ExpiredJwtException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
@Slf4j
@AllArgsConstructor
public class JwtRequestFilter extends OncePerRequestFilter {

    private static final Logger logger = LoggerFactory.getLogger(JwtRequestFilter.class);
    private final UserDetailsService userDetailsService;
    private final JwtTokenUtil jwtTokenUtil;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        log.info("Processing authentication for '{}'", request.getRequestURL());
        // Lấy token từ header: Lấy giá trị của header Authorization từ yêu cầu.
        final String requestTokenHeader = request.getHeader("Authorization");

        String username = null;
        String jwtToken = null;

        // JWT Token có định dạng "Bearer token". Xóa chuỗi "Bearer " và lấy token.
        if (requestTokenHeader != null && requestTokenHeader.startsWith("Bearer ")) {
            jwtToken = requestTokenHeader.substring(7);
            try {
                // Lấy username từ token
                username = jwtTokenUtil.extractUsername(jwtToken);
            } catch (IllegalArgumentException e) {
                // Nếu không thể lấy token
                logger.error("Unable to get JWT Token");
            } catch (ExpiredJwtException e) {
                // Nếu token hết hạn
                logger.error("JWT Token has expired");
            }
        } else {
            // Không định dạng đúng của token
            logger.warn("JWT Token does not begin with Bearer String");
        }

        // Kiểm tra người dùng và ngữ cảnh bảo mật:
        // Nếu username không null và không có xác thực nào trong SecurityContextHolder,
        // tiến hành xác thực người dùng.
        if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {
            //  Lấy thông tin người dùng từ UserDetails
            UserDetails userDetails = this.userDetailsService.loadUserByUsername(username);
            // Nếu token hợp lệ, set thông tin người dùng vào SecurityContext
            if (jwtTokenUtil.validateToken(jwtToken, userDetails)) {
                UsernamePasswordAuthenticationToken usernamePasswordAuthenticationToken =
                        new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
                usernamePasswordAuthenticationToken
                        .setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                SecurityContextHolder.getContext().setAuthentication(usernamePasswordAuthenticationToken);
            }
        }
        // Chuyển yêu cầu sang Filter tiếp theo
        filterChain.doFilter(request, response);
    }
}