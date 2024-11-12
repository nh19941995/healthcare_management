class RoleDTO {
  final int id;
  final String name;
  final String description;

  RoleDTO({
    required this.id,
    required this.name,
    required this.description,
  });

  factory RoleDTO.fromJson(Map<String, dynamic> json) {
    return RoleDTO(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}
