package org.example.healthcare_management.configs;

import jakarta.annotation.PostConstruct;
import jakarta.transaction.Transactional;
import org.example.healthcare_management.entities.PatientStatus;
import org.example.healthcare_management.entities.Role;
import org.example.healthcare_management.entities.Specialization;
import org.example.healthcare_management.entities.User;
import org.example.healthcare_management.enums.Gender;
import org.example.healthcare_management.services.PatientStatusService;
import org.example.healthcare_management.services.RoleService;
import org.example.healthcare_management.services.SpecializationService;
import org.example.healthcare_management.services.UserService;
import org.springframework.stereotype.Component;

@Component
public class DataInitializer {
    private final UserService userService;
    private final RoleService roleService;
    private final PatientStatusService patientStatusService;
    private final SpecializationService specializationService;

    public DataInitializer(UserService userService, RoleService roleService, PatientStatusService patientStatusService, SpecializationService specializationService) {
        this.userService = userService;
        this.roleService = roleService;
        this.patientStatusService = patientStatusService;
        this.specializationService = specializationService;
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

        if (userService.count() == 0) {
            userService.save(User.builder()
                    .name("John Doe")
                    .email("john.doe@example.com")
                    .password("securePass123")
                    .address("123 Main St, Anytown, USA")
                    .phone("555-1234")
                    .gender(Gender.MALE)
                    .description("Senior Software Engineer")
                    .build());

            userService.save(User.builder()
                    .name("Jane Smith")
                    .email("jane.smith@example.com")
                    .password("strongPass456")
                    .address("456 Elm St, Another City, USA")
                    .phone("555-5678")
                    .gender(Gender.FEMALE)
                    .description("Product Manager")
                    .build());

            userService.save(User.builder()
                    .name("Alex Johnson")
                    .email("alex.johnson@example.com")
                    .password("complexPass789")
                    .address("789 Oak Ave, Somewhere, USA")
                    .phone("555-9012")
                    .gender(Gender.FEMALE)
                    .description("UX Designer")
                    .build());

            userService.save(User.builder()
                    .name("Emily Brown")
                    .email("emily.brown@example.com")
                    .password("safePass101")
                    .address("101 Pine Rd, Elsewhere, USA")
                    .phone("555-3456")
                    .gender(Gender.FEMALE)
                    .description("Data Scientist")
                    .build());

            userService.save(User.builder()
                    .name("Michael Lee")
                    .email("michael.lee@example.com")
                    .password("strongPass202")
                    .address("202 Cedar Ln, Nowhere, USA")
                    .phone("555-7890")
                    .gender(Gender.MALE)
                    .description("Marketing Specialist")
                    .build());
        }

        if (specializationService.count()==0){
            specializationService.save(new Specialization(
                    "Cardiology",
                    "Deals with disorders of the heart and the cardiovascular system.",
                    null
            ));

            specializationService.save(new Specialization(
                    "Dermatology",
                    "Deals with the skin, hair, nails, and its diseases.",
                    null
            ));

            specializationService.save(new Specialization(
                    "Endocrinology",
                    "Deals with the endocrine system and its specific secretions called hormones.",
                    null
            ));

            specializationService.save(new Specialization(
                    "Gastroenterology",
                    "Deals with the digestive system and its disorders.",
                    null
            ));

            specializationService.save(new Specialization(
                    "Hematology",
                    "Deals with blood and the blood-forming organs.",
                    null
            ));

        }


    }
}
