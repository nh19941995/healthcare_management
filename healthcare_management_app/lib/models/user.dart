import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String name;
  final String email;
  final String? avatar;
  final String gender;
  final String description;

  User({
    required this.name,
    required this.email,
    this.avatar,
    required this.gender,
    required this.description,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}