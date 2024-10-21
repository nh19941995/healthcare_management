package org.example.healthcare_management.configs;

import jakarta.annotation.PostConstruct;
import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
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
import org.example.healthcare_management.services.PatientStatusService;
import org.example.healthcare_management.services.RoleService;
import org.example.healthcare_management.services.SpecializationService;
import org.example.healthcare_management.services.UserService;
import org.springframework.stereotype.Component;

@Component
public class DataInitializer {
    private final UserRepo userRepo;
    private final RoleRepo rolerepo;
    private final PatientStatusRepo patientStatusrepo;
    private final SpecializationRepo specializationrepo;

    public DataInitializer(UserRepo userRepo, RoleRepo rolerepo, PatientStatusRepo patientStatusrepo, SpecializationRepo specializationrepo) {
        this.userRepo = userRepo;
        this.rolerepo = rolerepo;
        this.patientStatusrepo = patientStatusrepo;
        this.specializationrepo = specializationrepo;
    }

    @PostConstruct
    @Transactional
    public void init() {
        if (rolerepo.count() == 0){
            rolerepo.save(new Role("ROLE_ADMIN", "Admin role"));
            rolerepo.save(new Role("ROLE_DOCTOR", "Doctor role"));
            rolerepo.save(new Role("ROLE_PATIENT", "Patient role"));
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

        if (userRepo.count() == 0) {
            User user = User.builder()
                    .name("Nguyễn Trung Hiếu")
                    .username("godOfJava@999")
                    .password("$2a$10$VB8vkPK0KtCMctlmmvlVvO2HKDiO0YXgjxsjtKDNDmEPgbSVCpmBe")
                    .email("godOfJava@gmail.com")
                    .address("Trái Đất")
                    .phone("0773307333")
                    .gender(Gender.MALE)
                    .status(Status.ACTIVE)
                    .role(rolerepo.findByName("ROLE_ADMIN").orElseThrow(() -> new EntityNotFoundException("Role not found")))
                    .build();
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
