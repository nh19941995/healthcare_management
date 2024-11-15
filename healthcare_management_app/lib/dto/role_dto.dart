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
