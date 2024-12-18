import 'package:healthcare_management_app/models/Specialization.dart';

class DoctorDTO {
  DoctorDTO({
    required this.userId,
    required this.doctorId,
    required this.username,
    required this.achievements,
    required this.medicalTraining,
    required this.clinicId,
    this.specialization,
    required this.fullName,
    required this.email,
    required this.address,
    required this.phone,
    required this.avatar,
    required this.gender,
    required this.description,
  });

  final int? userId;
  final int? doctorId;
  final String username;
  final String? achievements;
  final String? medicalTraining;
  final int? clinicId;
  final Specialization? specialization;
  final String? fullName;
  final String? email;
  final String? address;
  final String? phone;
  final String? avatar;
  final String? gender;
  final String? description;

  factory DoctorDTO.fromJson(Map<String, dynamic> json) {
    return DoctorDTO(
      userId: json["userId"],
      doctorId: json["doctorId"],
      username: json["username"],
      achievements: json["achievements"],
      medicalTraining: json["medicalTraining"],
      clinicId: json["clinicId"],
      // Ensure specialization is parsed into a Specialization object
      specialization: json["specialization"] != null
          ? Specialization.fromJson(json["specialization"])
          : null,
      fullName: json["fullName"],
      email: json["email"],
      address: json["address"],
      phone: json["phone"],
      avatar: json["avatar"],
      gender: json["gender"],
      description: json["description"],
    );
  }

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "doctorId": doctorId,
    "username": username,
    "achievements": achievements,
    "medicalTraining": medicalTraining,
    "clinicId": clinicId,
    "specialization": specialization?.toJson(), // Ensure to call toJson() on specialization
    "fullName": fullName,
    "email": email,
    "address": address,
    "phone": phone,
    "avatar": avatar,
    "gender": gender,
    "description": description,
  };

  @override
  String toString() {
    return "$userId, $doctorId, $username, $achievements, $medicalTraining, $clinicId, $specialization, $fullName, $email, $address, $phone, $avatar, $gender, $description, ";
  }
}
