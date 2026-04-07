import 'package:flutter/material.dart';

class DashboardProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  
  // Dashboard data
  Map<String, dynamic> _stats = {};
  List<Map<String, dynamic>> _attendance = [];
  List<Map<String, dynamic>> _leaves = [];
  List<Map<String, dynamic>> _holidays = [];
  
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic> get stats => _stats;
  List<Map<String, dynamic>> get attendance => _attendance;
  List<Map<String, dynamic>> get leaves => _leaves;
  List<Map<String, dynamic>> get holidays => _holidays;
  
  Future<void> loadDashboardData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      // Simulate API calls
      await Future.delayed(const Duration(seconds: 1));
      
      _stats = {
        'presentDays': 18,
        'leavesTaken': 5,
        'pendingRequests': 2,
        'avgHours': 7.8,
      };
      
      _attendance = [
        {'date': '2024-01-15', 'checkIn': '09:00 AM', 'checkOut': '06:00 PM', 'status': 'Present'},
        {'date': '2024-01-14', 'checkIn': '09:15 AM', 'checkOut': '06:00 PM', 'status': 'Late'},
        {'date': '2024-01-13', 'checkIn': '09:00 AM', 'checkOut': '05:30 PM', 'status': 'Present'},
      ];
      
      _leaves = [
        {'type': 'Casual Leave', 'startDate': '2024-01-20', 'endDate': '2024-01-22', 'status': 'Approved', 'days': 3, 'reason': 'Family function'},
        {'type': 'Sick Leave', 'startDate': '2024-01-10', 'endDate': '2024-01-11', 'status': 'Approved', 'days': 2, 'reason': 'Fever'},
        {'type': 'Annual Leave', 'startDate': '2024-02-01', 'endDate': '2024-02-10', 'status': 'Pending', 'days': 10, 'reason': 'Vacation'},
      ];
      
      _holidays = [
        {'name': 'Republic Day', 'date': '2024-01-26', 'day': 'Friday', 'type': 'Public'},
        {'name': 'Maha Shivaratri', 'date': '2024-03-08', 'day': 'Friday', 'type': 'Public'},
        {'name': 'Holi', 'date': '2024-03-25', 'day': 'Monday', 'type': 'Public'},
      ];
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load dashboard data';
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void refreshData() {
    loadDashboardData();
  }
  
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}