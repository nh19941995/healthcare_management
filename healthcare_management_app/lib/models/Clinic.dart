class Clinic {
  Clinic({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.description,
    required this.image,
    required this.createdAt,
     this.updatedAt,
    this.deletedAt,
  });

  final int? id;
  final String name;
  final String? address;
  final String? phone;
  final dynamic description;
  final dynamic image;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  factory Clinic.fromJson(Map<String, dynamic> json){
    return Clinic(
      id: json["id"],
      name: json["name"],
      address: json["address"],
      phone: json["phone"],
      description: json["description"],
      image: json["image"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: DateTime.tryParse(json["deletedAt"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "address": address,
    "phone": phone,
    "description": description,
    "image": image,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "deleteAt": deletedAt?.toIso8601String(),
  };

  @override
  String toString(){
    return "$id, $name, $address, $phone, $description, $image, $createdAt,$updatedAt,$deletedAt";
  }
}
