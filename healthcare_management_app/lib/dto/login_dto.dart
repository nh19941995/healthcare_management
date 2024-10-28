class LoginDto {
  LoginDto({
    required this.username,
  });

  final String? username;

  factory LoginDto.fromJson(Map<String, dynamic> json){
    return LoginDto(
      username: json["username"],
    );
  }

  Map<String, dynamic> toJson() => {
    "username": username,
  };

  @override
  String toString(){
    return "$username";
  }
}
