class Register {
  Register({
    required this.username,
    required this.password,
    required this.gender,
    required this.email,
    required this.phone,
    required this.address,
    required this.fullName,
    required this.description,
    required this.avatar
  });

  final String? username;
  final String? password;
  final String? gender;
  final String? email;
  final String? phone;
  final String? address;
  final String? fullName;
  final String? description;
  final String? avatar;

  factory Register.fromJson(Map<String, dynamic> json){
    return Register(
      username: json["username"],
      password: json["password"],
      gender: json["gender"],
      email: json["email"],
      phone: json["phone"],
      address: json["address"],
      fullName: json["fullName"],
      description: json["description"],
      avatar: json["avatar"],
    );
  }

  Map<String, dynamic> toJson() => {
    "username": username,
    "password": password,
    "gender": gender,
    "email": email,
    "phone": phone,
    "address": address,
    "fullName": fullName,
    "description": description,
    "avatar": avatar
  };

  @override
  String toString(){
    return "$username, $password, $gender, $email, $phone, $address, $fullName, $description, $avatar";
  }
}
