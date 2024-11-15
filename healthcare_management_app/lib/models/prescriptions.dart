import 'Medication.dart';

class PrescriptionRequest {
  final int appointmentId;
  final String medicalDiagnosis;
  final List<SelectedMedicine> medications;

  PrescriptionRequest({
    required this.appointmentId,
    required this.medicalDiagnosis,
    required this.medications,
  });

  // Phương thức chuyển đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      'appointmentId': appointmentId,
      'medicalDiagnosis': medicalDiagnosis,
      'medications': medications.map((e) => e.toJson()).toList(),
    };
  }

  // Phương thức tạo đối tượng từ JSON
  factory PrescriptionRequest.fromJson(Map<String, dynamic> json) {
    return PrescriptionRequest(
      appointmentId: json['appointmentId'],
      medicalDiagnosis: json['medicalDiagnosis'],
      medications: (json['medications'] as List<dynamic>)
          .map((e) => SelectedMedicine.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class SelectedMedicine {
  SelectedMedicine({
    required this.medicationId,
    required this.totalDosage,
    required this.dosageInstructions,
    required this.note,
  });

  final int? medicationId;
  final String? totalDosage;
  final String? dosageInstructions;
  final String? note;

  factory SelectedMedicine.fromJson(Map<String, dynamic> json){
    return SelectedMedicine(
      medicationId: json["medicationId"],
      totalDosage: json["totalDosage"],
      dosageInstructions: json["dosageInstructions"],
      note: json["note"],
    );
  }

  Map<String, dynamic> toJson() => {
    "medicationId": medicationId,
    "totalDosage": totalDosage,
    "dosageInstructions": dosageInstructions,
    "note": note,
  };

  @override
  String toString(){
    return "$medicationId, $totalDosage, $dosageInstructions, $note, ";
  }
}

