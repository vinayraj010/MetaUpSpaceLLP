class HolidayModel {
  final String name;
  final String date;
  final String day;
  final String type;
  
  HolidayModel({
    required this.name,
    required this.date,
    required this.day,
    required this.type,
  });
  
  factory HolidayModel.fromJson(Map<String, dynamic> json) {
    return HolidayModel(
      name: json['name'] ?? '',
      date: json['date'] ?? '',
      day: json['day'] ?? '',
      type: json['type'] ?? 'Public',
    );
  }
}