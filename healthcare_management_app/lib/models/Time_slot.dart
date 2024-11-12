import 'package:intl/intl.dart';

class Timeslots {
  Timeslots({
    required this.id,
    required this.endAt,
    required this.startAt,
  });

  final int id;
  final String endAt;
  final String startAt;

  factory Timeslots.fromJson(Map<String, dynamic> json) {
    String endAt = json["endAt"] ?? '';
    String startAt = json["startAt"] ?? '';

    // Kiểm tra và chuyển đổi chuỗi thời gian thành DateTime
    DateTime? parsedEndAt = _parseTime(endAt);
    DateTime? parsedStartAt = _parseTime(startAt);

    if (parsedEndAt == null || parsedStartAt == null) {
      print("Thời gian không hợp lệ. Giá trị mặc định sẽ được sử dụng.");
    }

    return Timeslots(
      id: json["id"],
      endAt: endAt,
      startAt: startAt,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "endAt": endAt,
    "startAt": startAt,
  };

  @override
  String toString(){
    return "$id, $endAt, $startAt";
  }

  static DateTime? _parseTime(String timeString) {
    try {
      // Sử dụng định dạng "HH:mm:ss" để phù hợp với dữ liệu API
      return DateFormat("HH:mm:ss").parse(timeString);
    } catch (e) {
      print("Error parsing time: $e");
      return null; // Trả về null nếu không thể phân tích cú pháp
    }
  }
}
