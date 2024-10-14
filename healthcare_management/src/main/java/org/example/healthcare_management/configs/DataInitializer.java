package org.example.healthcare_management.configs;

import jakarta.annotation.PostConstruct;
import jakarta.transaction.Transactional;
import org.example.healthcare_management.entities.PatientStatus;
import org.example.healthcare_management.entities.Role;
import org.example.healthcare_management.entities.User;
import org.example.healthcare_management.services.PatientStatusService;
import org.example.healthcare_management.services.RoleService;
import org.example.healthcare_management.services.UserService;
import org.springframework.stereotype.Component;

@Component
public class DataInitializer {
    private final UserService userService;
    private final RoleService roleService;
    private final PatientStatusService patientStatusService;



    public DataInitializer(UserService userService, RoleService roleService, PatientStatusService patientStatusService) {
        this.userService = userService;
        this.roleService = roleService;
        this.patientStatusService = patientStatusService;
    }

    @PostConstruct
    @Transactional
    public void init() {
        if (roleService.count() == 0){
            roleService.save(new Role("ADMIN", "Admin role"));
            roleService.save(new Role("DOCTOR", "Doctor role"));
            roleService.save(new Role("PATIENT", "Patient role"));
        }

        if (patientStatusService.count() == 0){
            // đang điều trị
            patientStatusService.save(new PatientStatus("Under treatment", "Patient is treatment"));
            // ra viện
            patientStatusService.save(new PatientStatus("Discharged", "Patient is Discharged"));
            // theo dõi chặt chẽ
            patientStatusService.save(new PatientStatus("Monitor", "Patient is Monitor"));
            // theo dõi bình thường
            patientStatusService.save(new PatientStatus( "Follow-up","Scheduled for follow-up appointment in one week"));
        }

        if (userService.count() == 0){
            userService.save(User.builder()
                    .name("admin")
                    .email("email")
                    .password("password")
                    .role(roleService.findById(1L).get())
                    .


    }
}
