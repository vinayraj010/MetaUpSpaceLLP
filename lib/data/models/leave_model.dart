class LeaveModel {
  final String id;
  final String type;
  final String startDate;
  final String endDate;
  final String status;
  final String reason;
  final int days;
  
  LeaveModel({
    required this.id,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.reason,
    required this.days,
  });
  
  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
      id: json['id']?.toString() ?? '',
      type: json['type'] ?? 'Casual Leave',
      startDate: json['startDate'] ?? '2024-01-01',
      endDate: json['endDate'] ?? '2024-01-05',
      status: json['status'] ?? 'Pending',
      reason: json['reason'] ?? 'Personal reasons',
      days: json['days'] ?? 5,
    );
  }
}

class LeaveBalance {
  final int casualLeaves;
  final int sickLeaves;
  final int annualLeaves;
  final int usedLeaves;
  
  LeaveBalance({
    required this.casualLeaves,
    required this.sickLeaves,
    required this.annualLeaves,
    required this.usedLeaves,
  });
}