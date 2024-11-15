import 'package:healthcare_management_app/dto/user_dto.dart';
import 'package:healthcare_management_app/models/Time_slot.dart';

import 'Doctor_dto.dart';

class AppointmentDTO {
  final int id;
  final DateTime appointmentDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? deletedAt;
  late final String status;
  final Timeslots timeSlot;
  final DoctorDTO doctor;
  final UserDTO patient;

  AppointmentDTO({
    required this.id,
    required this.appointmentDate,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.status,
    required this.timeSlot,
    required this.doctor,
    required this.patient,
  });

  factory AppointmentDTO.fromJson(Map<String, dynamic> json) {
    return AppointmentDTO(
      id: json['id'],
      appointmentDate: DateTime.parse(json['appointmentDate']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      deletedAt: json['deletedAt'],
      status: json['status'],
      timeSlot: Timeslots.fromJson(json['timeSlot']),
      doctor: DoctorDTO.fromJson(json['doctor']),
      patient: UserDTO.fromJson(json['patient']),
    );
  }
}