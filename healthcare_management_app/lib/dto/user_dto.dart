import 'role_dto.dart';
import 'doctor_dto.dart';

class UserDTO {
  final int? id;
  final String fullName;
  final String username;
  final String? email;
  final String? address;
  final String? phone;
  final String? avatar;
  final String gender;
  final String? description;
  final List<RoleDTO>? roles;
  final DoctorDTO? doctor;
  final DateTime createdAt;
  final String? status;
  final String? lockReason;
  final String? password;

  UserDTO({
   this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.address,
    required this.phone,
    this.avatar,
    required this.gender,
    this.description,
     this.roles,
    this.doctor,
    required this.createdAt,
    this.status,
    this.lockReason,
    this.password
  });

  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
      id: json['id'] as int,
      fullName: json['fullName'] as String,
      username: json['username'] as String,
      email: json['email'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      gender: json['gender'] as String,
      description: json['description'] as String?,
      roles:
           (json['roles'] as List<dynamic>)
          .map((role) => RoleDTO.fromJson(role))
          .toList()
          ,
      doctor: json['doctor'] != null ? DoctorDTO.fromJson(json['doctor']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      status: json['status'] as String,
      lockReason: json['lockReason'] as String?,
    );
  }
  Map<String, dynamic> toJson() => {
    "id": id,
    "address": address,
    "avatar": avatar,
    "created_at": createdAt?.toIso8601String(),
    "description": description,
    "email": email,
    "gender": gender,
    "lock_reason": lockReason,
    "password": password,
    "phone": phone,
    "status": status,
  };
}
