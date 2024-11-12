class ApiAppointmentDTO {
  final String patientUsername;
  final String doctorUsername;
  final int timeSlotId;
  final String appointmentDate;

  ApiAppointmentDTO({
    required this.patientUsername,
    required this.doctorUsername,
    required this.timeSlotId,
    required this.appointmentDate,
  });

  // Phương thức chuyển đổi từ JSON sang đối tượng
  factory ApiAppointmentDTO.fromJson(Map<String, dynamic> json) {
    return ApiAppointmentDTO(
      patientUsername: json['patientUsername'],
      doctorUsername: json['doctorUsername'],
      timeSlotId: json['timeSlotId'],
      appointmentDate: json['appointmentDate'],
    );
  }
}
