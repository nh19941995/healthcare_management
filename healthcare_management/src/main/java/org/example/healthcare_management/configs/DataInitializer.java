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
            rolerepo.save(new Role("ADMIN", "Admin role"));
            rolerepo.save(new Role("DOCTOR", "Doctor role"));
            rolerepo.save(new Role("PATIENT", "Patient role"));
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
            Role adminRole = rolerepo.findById(1L).orElseThrow(() -> new EntityNotFoundException("Role not found"));
            Role doctorRole = rolerepo.findById(2L).orElseThrow(() -> new EntityNotFoundException("Role not found"));
            Role patientRole = rolerepo.findById(3L).orElseThrow(() -> new EntityNotFoundException("Role not found"));
            userRepo.save(
                    User.builder()
                    .name("John Doe")
                    .email("john.doe@example.com")
                    .username("john")
                    .password("{noop}securePass123")
                    .address("123 Main St, Anytown, USA")
                    .phone("555-1234")
                    .gender(Gender.MALE)
                    .description("Senior Software Engineer")
                    .role(adminRole)
                    .status(Status.ACTIVE)
                    .build()

            );

            userRepo.save(User.builder()
                    .name("Jane Smith")
                    .email("jane.smith@example.com")
                    .username("jane")
                    .password("{noop}jane")
                    .address("456 Elm St, Another City, USA")
                    .phone("555-5678")
                    .gender(Gender.FEMALE)
                    .description("Product Manager")
                    .role(doctorRole)
                    .status(Status.ACTIVE)
                    .build());

            userRepo.save(User.builder()
                    .name("Alex Johnson")
                    .email("alex.johnson@example.com")
                    .username("alex")
                    .password("{noop}alex")
                    .address("789 Oak Ave, Somewhere, USA")
                    .phone("555-9012")
                    .gender(Gender.FEMALE)
                    .description("UX Designer")
                    .role(patientRole)
                    .status(Status.ACTIVE)
                    .build());

            userRepo.save(User.builder()
                    .name("Emily Brown")
                    .email("emily.brown@example.com")
                    .username("emily")
                    .password("{noop}emily")
                    .address("101 Pine Rd, Elsewhere, USA")
                    .phone("555-3456")
                    .gender(Gender.FEMALE)
                    .description("Data Scientist")
                    .role(patientRole)
                    .status(Status.ACTIVE)
                    .build());

            userRepo.save(User.builder()
                    .name("Michael Lee")
                    .email("michael.lee@example.com")
                    .username("michael")
                    .password("{noop}michael")
                    .address("202 Cedar Ln, Nowhere, USA")
                    .phone("555-7890")
                    .gender(Gender.MALE)
                    .description("Marketing Specialist")
                    .role(patientRole)
                    .status(Status.ACTIVE)
                    .build());
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
