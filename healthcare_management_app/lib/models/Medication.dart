class Medication {
  Medication({
    required this.id,
    required this.name,
    required this.type,
    required this.manufacturer,
    required this.dosage,
    required this.instructions,
  });

  final int? id;
  final String? name;
  final String? type;
  final String? manufacturer;
  final String? dosage;
  final String? instructions;

  factory Medication.fromJson(Map<String, dynamic> json){
    return Medication(
      id: json["id"],
      name: json["name"],
      type: json["type"],
      manufacturer: json["manufacturer"],
      dosage: json["dosage"],
      instructions: json["instructions"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "type": type,
    "manufacturer": manufacturer,
    "dosage": dosage,
    "instructions": instructions,
  };

  @override
  String toString(){
    return "$id, $name, $type, $manufacturer, $dosage, $instructions, ";
  }
}
