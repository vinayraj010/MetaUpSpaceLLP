import '../../data/models/user_model.dart';
import '../../data/models/attendance_model.dart';
import '../../data/models/leave_model.dart';
import '../../data/models/holiday_model.dart';

abstract class EmployeeRepository {
  Future<UserModel> login(String email, String password);
  Future<List<AttendanceModel>> getAttendance();
  Future<List<LeaveModel>> getLeaves();
  Future<List<HolidayModel>> getHolidays();
  Future<AttendanceSummary> getAttendanceSummary();
  Future<LeaveBalance> getLeaveBalance();
}