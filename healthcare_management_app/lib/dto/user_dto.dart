import 'package:healthcare_management_app/dto/role_dto.dart';

class UserDTO {
  UserDTO({
    this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.address,
    required this.phone,
    this.avatar,
    required this.gender,
    required this.description,
    this.roles,
    this.deletedAt, // Thêm trường deletedAt
    this.lockReason, // Thêm trường lockReason
  });

  final int? id;
  final String? fullName;
  final String username;
  final String? email;
  final String? address;
  final String? phone;
  final String? avatar;
  final String? gender;
  final String? description;
  late final List<Role>? roles;
  final String? deletedAt; // Trường deletedAt
   String? lockReason; // Trường lockReason

  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
      id: json["id"],
      fullName: json["fullName"],
      username: json["username"],
      email: json["email"],
      address: json["address"],
      phone: json["phone"],
      avatar: json["avatar"],
      gender: json["gender"],
      description: json["description"],
      roles: json["roles"] == null
          ? []
          : List<Role>.from(json["roles"]!.map((x) => Role.fromJson(x))),
      deletedAt: json["deletedAt"], // Lấy giá trị deletedAt từ JSON
      lockReason: json["lockReason"], // Lấy giá trị lockReason từ JSON
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullName": fullName,
    "username": username,
    "email": email,
    "address": address,
    "phone": phone,
    "avatar": avatar,
    "gender": gender,
    "description": description,
    "roles": roles?.map((x) => x?.toJson()).toList(),
    "deletedAt": deletedAt, // Thêm trường deletedAt vào JSON
    "lockReason": lockReason, // Thêm trường lockReason vào JSON
  };

  @override
  String toString() {
    return "$id, $fullName, $username, $email, $address, $phone, $avatar, $gender, $description, $roles, $deletedAt, $lockReason, ";
  }
}