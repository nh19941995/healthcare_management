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
import org.example.healthcare_management.services.UserService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.time.LocalTime;
import java.util.HashSet;
import java.util.Set;

@Component
@AllArgsConstructor
public class DataInitializer {
    private final DoctorRepo doctorRepo;
    private final ClinicRepo clinicRepo;
    private final TimeSlotRepo timeSlotRepo;
    private final UserRepo userRepo;
    private final UserService userService;
    private final RoleRepo roleRepo;
    private final PatientStatusRepo patientStatusrepo;
    private final SpecializationRepo specializationrepo;
    private final PasswordEncoder passwordEncoder;

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



        if (specializationrepo.count()==0){
            specializationrepo.save(new Specialization(
                    "Cardiology",
                    "Deals with disorders of the heart and the cardiovascular system.",
                    "https://images.pexels.com/photos/28856242/pexels-photo-28856242/free-photo-of-ng-i-ph-n-th-gian-tren-bai-bi-n-nhi-t-d-i-d-y-cat.jpeg"
            ));

            specializationrepo.save(new Specialization(
                    "Dermatology",
                    "Deals with the skin, hair, nails, and its diseases.",
                    "https://images.pexels.com/photos/19639386/pexels-photo-19639386/free-photo-of-bi-n-b-bi-n-kinh-ram-k-ngh.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
            ));

            specializationrepo.save(new Specialization(
                    "Endocrinology",
                    "Deals with the endocrine system and its specific secretions called hormones.",
                    "https://images.pexels.com/photos/8760437/pexels-photo-8760437.jpeg"
            ));

            specializationrepo.save(new Specialization(
                    "Gastroenterology",
                    "Deals with the digestive system and its disorders.",
                    "https://images.pexels.com/photos/12590657/pexels-photo-12590657.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
            ));

            specializationrepo.save(new Specialization(
                    "Hematology",
                    "Deals with blood and the blood-forming organs.",
                    "https://images.pexels.com/photos/8907219/pexels-photo-8907219.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
            ));

        }

        if (clinicRepo.count()==0){
            Clinic clinic = Clinic.builder()
                    .name("Bệnh viện Đa khoa Quốc tế")
                    .address("Số 1, Đại Cồ Việt, Hai Bà Trưng, Hà Nội")
                    .phone("024 3974 3556")
                    .description("Bệnh viện Đa khoa Quốc tế là một trong những bệnh viện hàng đầu tại Hà Nội")
                    .image("https://phukhoaanviet.com/wp-content/uploads/anh-mong-to-10.jpg")
                    .build();
            clinicRepo.save(clinic);

            Clinic clinic1 = Clinic.builder()
                    .name("Bệnh viện Bạch Mai")
                    .address("Số 78, Đường Giải Phóng, Đồng Tâm, Hai Bà Trưng, Hà Nội")
                    .phone("024 3869 3736")
                    .description("Bệnh viện Bạch Mai là một trong những bệnh viện hàng đầu tại Hà Nội")
                    .image("https://phukhoaanviet.com/wp-content/uploads/anh-mong-to-50.jpg")
                    .build();
            clinicRepo.save(clinic1);

            Clinic clinic2 = Clinic.builder()
                    .name("Bệnh viện Việt Đức")
                    .address("Số 40, Tràng Tiền, Ho��n Kiếm, Hà Nội")
                    .description("Bệnh viện Việt Đức là một trong những bệnh viện hàng đầu tại Hà Nội")
                    .image("https://anhgaixinh.vn/wp-content/uploads/2023/02/gai-mac-do-gym-1-1.jpg")
                    .phone("024 3826 4135")
                    .build();
            clinicRepo.save(clinic2);

            Clinic clinic3 = Clinic.builder()
                    .name("Bệnh viện E")
                    .address("Số 87, Đường Giải Phóng, Đồng Tâm, Hai Bà Trưng, Hà Nội")
                    .description("Bệnh viện E là một trong những bệnh viện hàng đầu tại Hà Nội")
                    .image("https://gaixinhbikini.com/wp-content/uploads/2023/03/body-gai-tap-gym.jpg")
                    .phone("024 3869 3736")
                    .build();
            clinicRepo.save(clinic3);
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
                    .password(passwordEncoder.encode("godOfJava@999"))
                    .email("godOfJava@gmail.com")
                    .address("Trái Đất")
                    .phone("0773307333")
                    .gender(Gender.MALE)
                    .avatar("https://photo.znews.vn/w1920/Uploaded/rotnba/2024_03_03/Snapinsta.app_431047292_18331084978106327_9041942873238468114_n_1080.jpg")
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
                    .password(passwordEncoder.encode("ababab@A111"))
                    .email("abama@gmail.com")
                    .address("Trái Đất")
                    .phone("0273307333")
                    .avatar("https://images.pexels.com/photos/3622619/pexels-photo-3622619.jpeg")
                    .gender(Gender.MALE)
                    .status(Status.ACTIVE)
                    .build();

            Set<Role> rolesUser = new HashSet<>();
            rolesUser.add(patientRole);
            user.setRoles(rolesUser);
            userRepo.save(user);

            // doctor
            Specialization specialization1 = specializationrepo.findById(1L).orElseThrow(() -> new EntityNotFoundException("Specialization not found"));
            Specialization specialization2 = specializationrepo.findById(2L).orElseThrow(() -> new EntityNotFoundException("Specialization not found"));

            Clinic clinic1 = clinicRepo.findById(1L).orElseThrow(() -> new EntityNotFoundException("Clinic not found"));
            Clinic clinic2 = clinicRepo.findById(2L).orElseThrow(() -> new EntityNotFoundException("Clinic not found"));


            // tạo user cho doctor
            User UserDoctor = User.builder()
                    .fullName("Nguyễn Văn A")
                    .username("doctorA@A111")
                    .password(passwordEncoder.encode("doctorA@A111"))
                    .email("doctorA@gmail.com")
                    .address("Trái Đất")
                    .phone("0273307333")
                    .avatar("https://images.pexels.com/photos/11545333/pexels-photo-11545333.jpeg")
                    .gender(Gender.MALE)
                    .status(Status.ACTIVE)
                    .build();
            // tạo doctor
            Doctor doctor1 = new Doctor();
            doctor1.setUser(UserDoctor);
            doctor1.setSpecialization(specialization1);
            doctor1.setClinic(clinic1);
            doctor1.setStatus(Status.ACTIVE);
            doctor1.setAchievements("Đã có nhiều năm kinh nghiệm");
            doctor1.setMedicalTraining("Đại học Y Hà Nội");

            // lưu doctor
            doctorRepo.save(doctor1);
            // lưu user
            userRepo.save(UserDoctor);
            // set role cho user
            UserDoctor.getRoles().add(doctorRole);
            // lưu user
            userRepo.save(UserDoctor);

            // tạo user cho doctor
            User UserDoctor1 = User.builder()
                    .fullName("Nguyễn Văn B")
                    .username("doctorB@A111")
                    .password(passwordEncoder.encode("doctorB@A111"))
                    .email("doctorb@gmail.com")
                    .address("Trái Đất")
                    .phone("0213377333")
                    .avatar("https://images.pexels.com/photos/15793630/pexels-photo-15793630/free-photo-of-bi-n-th-i-trang-b-bi-n-ngay-l.jpeg")
                    .gender(Gender.MALE)
                    .status(Status.ACTIVE)
                    .build();
            // tạo doctor
            Doctor doctor2 = new Doctor();
            doctor2.setUser(UserDoctor1);
            doctor2.setSpecialization(specialization1);
            doctor2.setClinic(clinic1);
            doctor2.setStatus(Status.ACTIVE);
            doctor2.setAchievements("Đã có nhiều năm kinh nghiệm");
            doctor2.setMedicalTraining("Đại học Y Đà Nẵng");
            // lưu doctor
            doctorRepo.save(doctor2);
            // lưu user
            userRepo.save(UserDoctor1);
            // set role cho user
            UserDoctor1.getRoles().add(doctorRole);
            // lưu user
            userRepo.save(UserDoctor1);

            // tạo user cho doctor
            User UserDoctor2 = User.builder()
                    .fullName("Nguyễn Văn C")
                    .username("doctorC@A111")
                    .password(passwordEncoder.encode("doctorC@A111"))
                    .email("doctorc@gmail.com")
                    .address("Trái Đất")
                    .avatar("https://images.pexels.com/photos/28663059/pexels-photo-28663059.jpeg")
                    .phone("0213377383")
                    .gender(Gender.MALE)
                    .status(Status.ACTIVE)
                    .build();
            // tạo doctor
            Doctor doctor3 = new Doctor();
            doctor3.setUser(UserDoctor2);
            doctor3.setSpecialization(specialization1);
            doctor3.setClinic(clinic1);
            doctor3.setStatus(Status.ACTIVE);
            doctor3.setAchievements("Đã có nhiều năm kinh nghiệm");
            doctor3.setMedicalTraining("Đại học Y TP Hồ Chí Minh");
            // lưu doctor
            doctorRepo.save(doctor3);
            // lưu user
            userRepo.save(UserDoctor2);
            // set role cho user
            UserDoctor2.getRoles().add(doctorRole);
            // lưu user
            userRepo.save(UserDoctor2);


        }

    }
}
