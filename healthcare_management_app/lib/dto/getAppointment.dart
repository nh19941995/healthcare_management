class GetAppointment {
  GetAppointment({
    required this.appointmentId,
    required this.medicalDiagnosis,
    required this.medications,
  });

  final int? appointmentId;
  final String? medicalDiagnosis;
  final List<MedicationElement> medications;

  factory GetAppointment.fromJson(Map<String, dynamic> json){
    return GetAppointment(
      appointmentId: json["appointmentId"],
      medicalDiagnosis: json["medicalDiagnosis"],
      medications: json["medications"] == null ? [] : List<MedicationElement>.from(json["medications"]!.map((x) => MedicationElement.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "appointmentId": appointmentId,
    "medicalDiagnosis": medicalDiagnosis,
    "medications": medications.map((x) => x?.toJson()).toList(),
  };

  @override
  String toString(){
    return "$appointmentId, $medicalDiagnosis, $medications, ";
  }
}

class MedicationElement {
  MedicationElement({
    required this.medication,
    required this.totalDosage,
    required this.note,
    required this.dosageInstructions,
  });

  final MedicationMedication? medication;
  final String? totalDosage;
  final String? note;
  final String? dosageInstructions;

  factory MedicationElement.fromJson(Map<String, dynamic> json){
    return MedicationElement(
      medication: json["medication"] == null ? null : MedicationMedication.fromJson(json["medication"]),
      totalDosage: json["totalDosage"],
      note: json["note"],
      dosageInstructions: json["dosageInstructions"],
    );
  }

  Map<String, dynamic> toJson() => {
    "medication": medication?.toJson(),
    "totalDosage": totalDosage,
    "note": note,
    "dosageInstructions": dosageInstructions,
  };

  @override
  String toString(){
    return "$medication, $totalDosage, $note, $dosageInstructions, ";
  }
}

class MedicationMedication {
  MedicationMedication({
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

  factory MedicationMedication.fromJson(Map<String, dynamic> json){
    return MedicationMedication(
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
