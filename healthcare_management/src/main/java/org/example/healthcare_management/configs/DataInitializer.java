package org.example.healthcare_management.configs;

import jakarta.annotation.PostConstruct;
import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import lombok.AllArgsConstructor;
import org.example.healthcare_management.entities.*;
import org.example.healthcare_management.enums.EnumRole;
import org.example.healthcare_management.enums.Gender;
import org.example.healthcare_management.enums.Status;
import org.example.healthcare_management.repositories.*;
import org.springframework.stereotype.Component;

import java.time.LocalTime;
import java.util.HashSet;
import java.util.Set;

@Component
@AllArgsConstructor
public class DataInitializer {
    private final TimeSlotRepo timeSlotRepo;
    private final UserRepo userRepo;
    private final RoleRepo roleRepo;
    private final PatientStatusRepo patientStatusrepo;
    private final SpecializationRepo specializationrepo;

    @PostConstruct
    @Transactional
    public void init() {
        if (timeSlotRepo.count() == 0) {
            TimeSlot timeSlot_1 = TimeSlot.builder()
                    .startAt(LocalTime.of(7, 30))
                    .endAt(LocalTime.of(8, 30))
                    .build();

            TimeSlot timeSlot_2 = TimeSlot.builder()
                    .startAt(LocalTime.of(8, 30))
                    .endAt(LocalTime.of(9, 30))
                    .build();

            TimeSlot timeSlot_3 = TimeSlot.builder()
                    .startAt(LocalTime.of(9, 30))
                    .endAt(LocalTime.of(10, 30))
                    .build();

            TimeSlot timeSlot_4 = TimeSlot.builder()
                    .startAt(LocalTime.of(10, 30))
                    .endAt(LocalTime.of(11, 30))
                    .build();

            TimeSlot timeSlot_5 = TimeSlot.builder()
                    .startAt(LocalTime.of(13, 30))
                    .endAt(LocalTime.of(14, 30))
                    .build();

            TimeSlot timeSlot_6 = TimeSlot.builder()
                    .startAt(LocalTime.of(14, 30))
                    .endAt(LocalTime.of(15, 30))
                    .build();

            TimeSlot timeSlot_7 = TimeSlot.builder()
                    .startAt(LocalTime.of(15, 30))
                    .endAt(LocalTime.of(16, 30))
                    .build();

            TimeSlot timeSlot_8 = TimeSlot.builder()
                    .startAt(LocalTime.of(16, 30))
                    .endAt(LocalTime.of(17, 30))
                    .build();

            timeSlotRepo.save(timeSlot_1);
            timeSlotRepo.save(timeSlot_2);
            timeSlotRepo.save(timeSlot_3);
            timeSlotRepo.save(timeSlot_4);
            timeSlotRepo.save(timeSlot_5);
            timeSlotRepo.save(timeSlot_6);
            timeSlotRepo.save(timeSlot_7);
            timeSlotRepo.save(timeSlot_8);
        }

        if (roleRepo.count() == 0){
            roleRepo.save(new Role(EnumRole.ADMIN.getRoleName(), "Admin role"));
            roleRepo.save(new Role(EnumRole.DOCTOR.getRoleName(), "Doctor role"));
            roleRepo.save(new Role(EnumRole.PATIENT.getRoleName(), "Patient role"));
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
            Role adminRole = roleRepo.findByName(
                    EnumRole.ADMIN.getRoleName()
            ).orElseThrow(() -> new EntityNotFoundException("Role not found"));

            Role doctorRole = roleRepo.findByName(
                    EnumRole.DOCTOR.getRoleName()
            ).orElseThrow(() -> new EntityNotFoundException("Role not found"));

            Role patientRole = roleRepo.findByName(
                    EnumRole.PATIENT.getRoleName()
            ).orElseThrow(() -> new EntityNotFoundException("Role not found"));

            // Admin
            User admin = User.builder()
                    .fullName("Nguyễn Trung Hiếu")
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
                    .fullName("Obama")
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
