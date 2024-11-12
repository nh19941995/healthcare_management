import 'role_dto.dart';
import 'doctor_dto.dart';

class UserDTO {
  UserDTO({
     this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.address,
    required this.phone,
    required this.avatar,
    required this.gender,
    required this.description,
    required this.roles,
  });

  final int? id;
  final String? fullName;
  final String? username;
  final String? email;
  final String? address;
  final String? phone;
  final String? avatar;
  final String? gender;
  final String? description;
  late final List<Role> roles;

  factory UserDTO.fromJson(Map<String, dynamic> json){
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
      roles: json["roles"] == null ? [] : List<Role>.from(json["roles"]!.map((x) => Role.fromJson(x))),
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
    "roles": roles.map((x) => x?.toJson()).toList(),
  };

  @override
  String toString(){
    return "$id, $fullName, $username, $email, $address, $phone, $avatar, $gender, $description, $roles, ";
  }
}

class Role {
  Role({
     this.id,
     this.name,
    this.description,
  });

  final int? id;
   final String? name;
  final String? description;

  factory Role.fromJson(Map<String, dynamic> json){
    return Role(
      id: json["id"],
      name: json["name"],
      description: json["description"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
  };

  @override
  String toString(){
    return "$id, $name, $description, ";
  }
}

