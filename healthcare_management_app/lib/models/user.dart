class User {
  User({
    required this.id,
    required this.address,
    required this.avatar,
    required this.createdAt,
    required this.deletedAt,
    required this.description,
    required this.email,
    required this.gender,
    required this.lockReason,
    required this.name,
    required this.password,
    required this.phone,
    required this.status,
    required this.updatedAt,
    required this.roleId,
  });

  final String? id;
  final String? address;
  final String? avatar;
  final DateTime? createdAt;
  final dynamic deletedAt;
  final String? description;
  final String? email;
  final String? gender;
  final dynamic lockReason;
  final String? name;
  final String? password;
  final String? phone;
         String? status;
  final DateTime? updatedAt;
  final int? roleId;

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json["id"],
      address: json["address"],
      avatar: json["avatar"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      deletedAt: json["deleted_at"],
      description: json["description"],
      email: json["email"],
      gender: json["gender"],
      lockReason: json["lock_reason"],
      name: json["name"],
      password: json["password"],
      phone: json["phone"],
      status: json["status"],
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      roleId: json["role_id"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "address": address,
    "avatar": avatar,
    "created_at": createdAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "description": description,
    "email": email,
    "gender": gender,
    "lock_reason": lockReason,
    "name": name,
    "password": password,
    "phone": phone,
    "status": status,
    "updated_at": updatedAt?.toIso8601String(),
    "role_id": roleId,
  };

  @override
  String toString(){
    return "$id, $address, $avatar, $createdAt, $deletedAt, $description, $email, $gender, $lockReason, $name, $password, $phone, $status, $updatedAt, $roleId, ";
  }
}
