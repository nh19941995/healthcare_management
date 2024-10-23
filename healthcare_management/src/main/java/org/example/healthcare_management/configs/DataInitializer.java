package org.example.healthcare_management.configs;

import jakarta.annotation.PostConstruct;
import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import lombok.AllArgsConstructor;
import org.example.healthcare_management.entities.PatientStatus;
import org.example.healthcare_management.entities.Role;
import org.example.healthcare_management.entities.Specialization;
import org.example.healthcare_management.entities.User;
import org.example.healthcare_management.enums.Gender;
import org.example.healthcare_management.enums.Status;
import org.example.healthcare_management.repositories.PatientStatusRepo;
import org.example.healthcare_management.repositories.RoleRepo;
import org.example.healthcare_management.repositories.SpecializationRepo;
import org.example.healthcare_management.repositories.UserRepo;
import org.example.healthcare_management.services.UserService;
import org.springframework.stereotype.Component;

import java.util.HashSet;
import java.util.Set;

@Component
@AllArgsConstructor
public class DataInitializer {
    private final UserService userService;
    private final UserRepo userRepo;
    private final RoleRepo roleRepo;
    private final PatientStatusRepo patientStatusrepo;
    private final SpecializationRepo specializationrepo;

    @PostConstruct
    @Transactional
    public void init() {
        if (roleRepo.count() == 0){
            roleRepo.save(new Role("ADMIN", "Admin role"));
            roleRepo.save(new Role("DOCTOR", "Doctor role"));
            roleRepo.save(new Role("PATIENT", "Patient role"));
        }

        if (patientStatusrepo.count() == 0){
            // đang điều trị
            patientStatusrepo.save(new PatientStatus("Under treatment", "Patient is treatment"));
            // ra viện
            patientStatusrepo.save(new PatientStatus("Discharged", "Patient is Discharged"));
            // theo dõi chặt chẽ
            patientStatusrepo.save(new PatientStatus("Monitor", "Patient is Monitor"));
            // theo dõi bình thường
            patientStatusrepo.save(new PatientStatus( "Follow-up","Scheduled for follow-up appointment in one week"));
        }

        if (userRepo.count() == 0 && roleRepo.count() > 0) {
            Role adminRole = roleRepo.findByName("ADMIN").orElseThrow(() -> new EntityNotFoundException("Role not found"));
            Role doctorRole = roleRepo.findByName("DOCTOR").orElseThrow(() -> new EntityNotFoundException("Role not found"));
            Role patientRole = roleRepo.findByName("PATIENT").orElseThrow(() -> new EntityNotFoundException("Role not found"));

            // Admin
            User admin = User.builder()
                    .name("Nguyễn Trung Hiếu")
                    .username("godOfJava@999")
                    .password("$2a$10$VB8vkPK0KtCMctlmmvlVvO2HKDiO0YXgjxsjtKDNDmEPgbSVCpmBe")
                    .email("godOfJava@gmail.com")
                    .address("Trái Đất")
                    .phone("0773307333")
                    .gender(Gender.MALE)
                    .status(Status.ACTIVE)
                    .build();
            Set<Role> roles = new HashSet<>();
            roles.add(adminRole);
            roles.add(doctorRole);
            roles.add(patientRole);
            admin.setRoles(roles);
            userRepo.save(admin);

            // patient
            User user = User.builder()
                    .name("Obama")
                    .username("ababab@A111")
                    .password("$2a$10$wrbKk7zf9SONCY17gFOYXOTsv/nW4JtrIGWZBVH4.AemgOptA/NLG")
                    .email("abama@gmail.com")
                    .address("Trái Đất")
                    .phone("0273307333")
                    .gender(Gender.MALE)
                    .status(Status.ACTIVE)
                    .build();
            Set<Role> rolesUser = new HashSet<>();
            rolesUser.add(patientRole);
            user.setRoles(rolesUser);
            userRepo.save(user);
        }

        if (specializationrepo.count()==0){
            specializationrepo.save(new Specialization(
                    "Cardiology",
                    "Deals with disorders of the heart and the cardiovascular system.",
                    null
            ));

            specializationrepo.save(new Specialization(
                    "Dermatology",
                    "Deals with the skin, hair, nails, and its diseases.",
                    null
            ));

            specializationrepo.save(new Specialization(
                    "Endocrinology",
                    "Deals with the endocrine system and its specific secretions called hormones.",
                    null
            ));

            specializationrepo.save(new Specialization(
                    "Gastroenterology",
                    "Deals with the digestive system and its disorders.",
                    null
            ));

            specializationrepo.save(new Specialization(
                    "Hematology",
                    "Deals with blood and the blood-forming organs.",
                    null
            ));

        }


    }
}
