import 'package:healthcare_management_app/dto/user_dto.dart';

import 'Clinic.dart';
import 'Specialization.dart';

class DoctorDetail {
  DoctorDetail({
    required this.userId,
    required this.doctorId,
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

  final int? userId;
  final int? doctorId;
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

  factory DoctorDetail.fromJson(Map<String, dynamic> json){
    return DoctorDetail(
      userId: json["userId"],
      doctorId: json["doctorId"],
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

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "doctorId": doctorId,
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

  @override
  String toString(){
    return "$userId, $doctorId, $achievements, $medicalTraining, $clinic, $specialization, $fullName, $email, $address, $phone, $avatar, $gender, $description, ";
  }
}

class Clinic {
  Clinic({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.description,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  final int? id;
  final String? name;
  final String? address;
  final String? phone;
  final String? description;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  factory Clinic.fromJson(Map<String, dynamic> json){
    return Clinic(
      id: json["id"],
      name: json["name"],
      address: json["address"],
      phone: json["phone"],
      description: json["description"],
      image: json["image"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "address": address,
    "phone": phone,
    "description": description,
    "image": image,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "deletedAt": deletedAt,
  };

  @override
  String toString(){
    return "$id, $name, $address, $phone, $description, $image, $createdAt, $updatedAt, $deletedAt, ";
  }
}



