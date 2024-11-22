class UpdateUserForDoctorDto {
  UpdateUserForDoctorDto({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.address,
    required this.phone,
    required this.gender,
    required this.description,
    required this.achievements,
    required this.medicalTraining,
    required this.clinicId,
    required this.specializationId,
    this.avatar,
  });

  final int? id;
  final String? fullName;
  final String? username;
  final String? email;
  final String? address;
  final String? phone;
  final String? gender;
  final String? description;
  final String? achievements;
  final String? medicalTraining;
  final int? clinicId;
  final int? specializationId;
  final String? avatar;


  factory UpdateUserForDoctorDto.fromJson(Map<String, dynamic> json){
    return UpdateUserForDoctorDto(
      id: json["id"],
      fullName: json["fullName"],
      username: json["username"],
      email: json["email"],
      address: json["address"],
      phone: json["phone"],
      gender: json["gender"],
      description: json["description"],
      achievements: json["achievements"],
      medicalTraining: json["medicalTraining"],
      clinicId: json["clinicId"],
      specializationId: json["specializationId"],
      avatar: json["avatar"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullName": fullName,
    "username": username,
    "email": email,
    "address": address,
    "phone": phone,
    "gender": gender,
    "description": description,
    "achievements": achievements,
    "medicalTraining": medicalTraining,
    "clinicId": clinicId,
    "specializationId": specializationId,
    "avatar": avatar,
  };

  @override
  String toString(){
    return "$id, $fullName, $username, $email, $address, $phone, $gender, $description, $achievements, $medicalTraining, $clinicId, $specializationId,$avatar ";
  }
}
