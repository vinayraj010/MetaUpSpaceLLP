import 'package:metaup_employee_dashboard/domain/repositories/employee_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../datasources/remote/api_service.dart';
import '../models/user_model.dart';
import '../models/attendance_model.dart';
import '../models/leave_model.dart';
import '../models/holiday_model.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final ApiService apiService;
  final SharedPreferences sharedPreferences;
  
  EmployeeRepositoryImpl({
    required this.apiService,
    required this.sharedPreferences,
  });
  
  @override
  Future<UserModel> login(String email, String password) async {
    // For demo purposes, simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    if (email.isNotEmpty && password.length >= 6) {
      final user = UserModel(
        id: '1',
        email: email,
        name: email.split('@')[0],
        token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
      );
      
      await sharedPreferences.setString('token', user.token);
      await sharedPreferences.setString('user_email', user.email);
      await sharedPreferences.setString('user_name', user.name);
      await sharedPreferences.setBool('is_logged_in', true);
      
      return user;
    } else {
      throw Exception('Invalid credentials');
    }
  }
  
  @override
  Future<List<AttendanceModel>> getAttendance() async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock data
    return [
      AttendanceModel(
        date: '2024-01-15',
        checkIn: '09:00 AM',
        checkOut: '06:00 PM',
        status: 'Present',
        totalHours: 8,
      ),
      AttendanceModel(
        date: '2024-01-14',
        checkIn: '09:15 AM',
        checkOut: '06:00 PM',
        status: 'Late',
        totalHours: 8,
      ),
      AttendanceModel(
        date: '2024-01-13',
        checkIn: '09:00 AM',
        checkOut: '05:30 PM',
        status: 'Present',
        totalHours: 7,
      ),
    ];
  }
  
  @override
  Future<List<LeaveModel>> getLeaves() async {
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      LeaveModel(
        id: '1',
        type: 'Casual Leave',
        startDate: '2024-01-20',
        endDate: '2024-01-22',
        status: 'Approved',
        reason: 'Family function',
        days: 3,
      ),
      LeaveModel(
        id: '2',
        type: 'Sick Leave',
        startDate: '2024-01-10',
        endDate: '2024-01-11',
        status: 'Approved',
        reason: 'Fever',
        days: 2,
      ),
      LeaveModel(
        id: '3',
        type: 'Annual Leave',
        startDate: '2024-02-01',
        endDate: '2024-02-10',
        status: 'Pending',
        reason: 'Vacation',
        days: 10,
      ),
    ];
  }
  
  @override
  Future<List<HolidayModel>> getHolidays() async {
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      HolidayModel(
        name: 'Republic Day',
        date: '2024-01-26',
        day: 'Friday',
        type: 'Public',
      ),
      HolidayModel(
        name: 'Maha Shivaratri',
        date: '2024-03-08',
        day: 'Friday',
        type: 'Public',
      ),
      HolidayModel(
        name: 'Holi',
        date: '2024-03-25',
        day: 'Monday',
        type: 'Public',
      ),
    ];
  }
  
  @override
  Future<AttendanceSummary> getAttendanceSummary() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return AttendanceSummary(
      totalPresent: 18,
      totalAbsent: 2,
      totalLate: 1,
      averageHours: 7.8,
    );
  }
  
  @override
  Future<LeaveBalance> getLeaveBalance() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return LeaveBalance(
      casualLeaves: 12,
      sickLeaves: 10,
      annualLeaves: 15,
      usedLeaves: 5,
    );
  }
}