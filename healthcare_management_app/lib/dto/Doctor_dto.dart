class DoctorDTO {
  final int id;
  final String achievements;
  final String medicalTraining;
  final int? clinicId;
  final int? specializationId;
  final String status;
  final String? lockReason;
  final String username;
  final String? avatar;

  DoctorDTO({
    required this.id,
    required this.achievements,
    required this.medicalTraining,
    this.clinicId,
    this.specializationId,
    required this.status,
    this.lockReason,
    required this.username,
    this.avatar,
  });

  factory DoctorDTO.fromJson(Map<String, dynamic> json) {
    try {
      return DoctorDTO(
        id: json['id'] as int? ?? 0,
        achievements: json['achievements'] as String? ?? '',
        medicalTraining: json['medicalTraining'] as String? ?? '',
        clinicId: json['clinicId'] as int?,
        specializationId: json['specializationId'] as int?,
        status: json['status'] as String? ?? 'unknown',
        lockReason: json['lockReason'] as String?,
        username: json['username'] as String? ?? 'defaultUser',
        avatar: json['avatar'] as String?,
      );
    } catch (e) {
      throw Exception("Error parsing DoctorDTO: $e");
    }
  }

}
