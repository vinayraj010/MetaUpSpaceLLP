class AttendanceModel {
  final String date;
  final String checkIn;
  final String checkOut;
  final String status;
  final int totalHours;
  
  AttendanceModel({
    required this.date,
    required this.checkIn,
    required this.checkOut,
    required this.status,
    required this.totalHours,
  });
  
  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      date: json['date'] ?? '',
      checkIn: json['checkIn'] ?? '09:00 AM',
      checkOut: json['checkOut'] ?? '06:00 PM',
      status: json['status'] ?? 'Present',
      totalHours: json['totalHours'] ?? 8,
    );
  }
}

class AttendanceSummary {
  final int totalPresent;
  final int totalAbsent;
  final int totalLate;
  final double averageHours;
  
  AttendanceSummary({
    required this.totalPresent,
    required this.totalAbsent,
    required this.totalLate,
    required this.averageHours,
  });
}