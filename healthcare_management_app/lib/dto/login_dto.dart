class LoginDto {
  LoginDto({
    required this.username,
    required this.password,
  });

  final String? username;
  final String? password;

  factory LoginDto.fromJson(Map<String, dynamic> json){
    return LoginDto(
      username: json["username"],
      password: json["password"],
    );
  }

  Map<String, dynamic> toJson() => {
    "username": username,
    "password": password,
  };

  @override
  String toString(){
    return "$username, $password, ";
  }
}
