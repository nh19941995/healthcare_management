class Booking {
  Booking({
    required this.id,
    required this.appointmentDate,
    required this.createdAt,
    required this.deletedAt,
    required this.status,
    required this.updatedAt,
    required this.doctorId,
    required this.patientId,
    required this.timeSlotId,
  });

  final String? id;
  final DateTime? appointmentDate;
  final DateTime? createdAt;
  final dynamic deletedAt;
  final String? status;
  final DateTime? updatedAt;
  final String? doctorId;
  final String? patientId;
  final String? timeSlotId;

  factory Booking.fromJson(Map<String, dynamic> json){
    return Booking(
      id: json["id"],
      appointmentDate: DateTime.tryParse(json["appointmentDate"] ?? ""),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
      status: json["status"],
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      doctorId: json["doctorId"],
      patientId: json["patientId"],
      timeSlotId: json["timeSlotId"],
    );
  }

  // Map<String, dynamic> toJson() => {
  //   "id": id,
  //   "appointmentDate": "${appointmentDate?.year.toString().padLeft(4'0')}-${appointmentDate.month.toString().padLeft(2'0')}-${appointmentDate.day.toString().padLeft(2'0')}",
  //   "createdAt": "${createdAt.year.toString().padLeft(4'0')}-${createdAt.month.toString().padLeft(2'0')}-${createdAt.day.toString().padLeft(2'0')}",
  //   "deletedAt": deletedAt,
  //   "status": status,
  //   "updatedAt": "${updatedAt.year.toString().padLeft(4'0')}-${updatedAt.month.toString().padLeft(2'0')}-${updatedAt.day.toString().padLeft(2'0')}",
  //   "doctorId": doctorId,
  //   "patientId": patientId,
  //   "timeSlotId": timeSlotId,
  // };

  @override
  String toString(){
    return "$id, $appointmentDate, $createdAt, $deletedAt, $status, $updatedAt, $doctorId, $patientId, $timeSlotId, ";
  }
}
