class Clinic {
  Clinic({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.description,
    required this.image,
    required this.createdAt,
  });

  final int? id;
  final String name;
  final String? address;
  final String? phone;
  final dynamic description;
  final dynamic image;
  final DateTime? createdAt;

  factory Clinic.fromJson(Map<String, dynamic> json){
    return Clinic(
      id: json["id"],
      name: json["name"],
      address: json["address"],
      phone: json["phone"],
      description: json["description"],
      image: json["image"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
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
  };

  @override
  String toString(){
    return "$id, $name, $address, $phone, $description, $image, $createdAt, ";
  }
}
