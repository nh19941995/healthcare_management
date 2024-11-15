class UpdateDoctorDto {
  UpdateDoctorDto({
    required this.achievements,
    required this.medicalTraining,
    required this.clinicId,
    required this.specializationId,
    required this.fullName,
    required this.email,
    required this.address,
    required this.phone,
    this.avatar,
    required this.gender,
    required this.description,
  });

  final String? achievements;
  final String? medicalTraining;
  final int? clinicId;
  final int? specializationId;
  final String? fullName;
  final String? email;
  final String? address;
  final String? phone;
  final String? avatar;
  final String? gender;
  final String? description;

  factory UpdateDoctorDto.fromJson(Map<String, dynamic> json){
    return UpdateDoctorDto(
      achievements: json["achievements"],
      medicalTraining: json["medicalTraining"],
      clinicId: json["clinicId"],
      specializationId: json["specializationId"],
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
    "achievements": achievements,
    "medicalTraining": medicalTraining,
    "clinicId": clinicId,
    "specializationId": specializationId,
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
    return "$achievements, $medicalTraining, $clinicId, $specializationId, $fullName, $email, $address, $phone, $avatar, $gender, $description, ";
  }

}
