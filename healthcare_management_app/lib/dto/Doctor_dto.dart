// models/doctor_dto.dart
class DoctorDTO {
  final int? id;
  final String achievements;
  final String medicalTraining;
  final int clinicId;
  final int specializationId;
  final String status;
  final String? lockReason;
  final String username;
  final String? avatar;

  DoctorDTO({
    required this.id,
    required this.achievements,
    required this.medicalTraining,
    required this.clinicId,
    required this.specializationId,
    required this.status,
    this.lockReason,
    required this.username,
    this.avatar,
  });

  // Factory method để tạo một đối tượng DoctorDTO từ JSON
  factory DoctorDTO.fromJson(Map<String, dynamic> json) {
    return DoctorDTO(
      id: json['id'],
      achievements: json['achievements'] ?? '',
      medicalTraining: json['medicalTraining'] ?? '',
      clinicId: json['clinicId'],
      specializationId: json['specializationId'],
      status: json['status'],
      lockReason: json['lockReason'],
      username: json['username'],
      avatar: json['avatar'],
    );
  }
}
