import 'package:healthcare_management_app/models/Clinic.dart';
import 'package:healthcare_management_app/models/Specialization.dart';

class GetDoctorProfile {
  GetDoctorProfile({
    required this.userId,
    required this.doctorId,
    required this.username,
    required this.achievements,
    required this.medicalTraining,
    required this.clinic,
    required this.specialization,
    required this.fullName,
    required this.email,
    required this.address,
    required this.phone,
    required this.avatar,
    required this.gender,
    required this.description,
  });

  final int userId;
  final int doctorId;
  final String username;
  final String? achievements;
  final String? medicalTraining;
  final Clinic? clinic;
  final Specialization? specialization;
  final String? fullName;
  final String? email;
  final String? address;
  final String? phone;
  final String? avatar;
  final String? gender;
  final String? description;

  // Phương thức từ JSON chuyển thành đối tượng DoctorProfileDto
  factory GetDoctorProfile.fromJson(Map<String, dynamic> json) {
    return GetDoctorProfile(
      userId: json["userId"],
      doctorId: json["doctorId"],
      username: json["username"],
      achievements: json["achievements"],
      medicalTraining: json["medicalTraining"],
      clinic: json["clinic"] == null ? null : Clinic.fromJson(json["clinic"]),
      specialization: json["specialization"] == null ? null : Specialization.fromJson(json["specialization"]),
      fullName: json["fullName"],
      email: json["email"],
      address: json["address"],
      phone: json["phone"],
      avatar: json["avatar"],
      gender: json["gender"],
      description: json["description"],
    );
  }

  // Phương thức chuyển đối tượng thành JSON
  Map<String, dynamic> toJson() => {
        "userId": userId,
        "doctorId": doctorId,
        "username": username,
        "achievements": achievements,
        "medicalTraining": medicalTraining,
        "clinic": clinic?.toJson(),
         "specialization": specialization?.toJson(),
        "fullName": fullName,
        "email": email,
        "address": address,
        "phone": phone,
        "avatar": avatar,
        "gender": gender,
        "description": description,
      };

  // Phương thức toString() để hiển thị thông tin đối tượng
  @override
  String toString() {
    return "$userId, $doctorId, $username, $achievements, $medicalTraining, ${clinic.toString()}, ${specialization.toString()}, $fullName, $email, $address, $phone, $avatar, $gender, $description";
  }
}
