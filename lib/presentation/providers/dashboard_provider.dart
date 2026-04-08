import 'package:flutter/material.dart';
import '../../domain/usecases/get_attendance_usecase.dart';
import '../../domain/usecases/get_leaves_usecase.dart';
import '../../domain/usecases/get_holidays_usecase.dart';
import '../../data/models/attendance_model.dart';
import '../../data/models/leave_model.dart';
import '../../data/models/holiday_model.dart';
import '../../core/utils/error_handler.dart';

class DashboardProvider extends ChangeNotifier {
  final GetAttendanceUseCase getAttendanceUseCase;
  final GetLeavesUseCase getLeavesUseCase;
  final GetHolidaysUseCase getHolidaysUseCase;
  
  DashboardProvider({
    required this.getAttendanceUseCase,
    required this.getLeavesUseCase,
    required this.getHolidaysUseCase,
  });
  
  bool _isLoading = false;
  String? _errorMessage;
  List<AttendanceModel> _attendance = [];
  List<LeaveModel> _leaves = [];
  List<HolidayModel> _holidays = [];
  AttendanceSummary? _attendanceSummary;
  LeaveBalance? _leaveBalance;
  
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<AttendanceModel> get attendance => _attendance;
  List<LeaveModel> get leaves => _leaves;
  List<HolidayModel> get holidays => _holidays;
  AttendanceSummary? get attendanceSummary => _attendanceSummary;
  LeaveBalance? get leaveBalance => _leaveBalance;
  
  // For backward compatibility with UI
  Map<String, dynamic> get stats => {
    'presentDays': _attendanceSummary?.totalPresent ?? 0,
    'leavesTaken': _leaveBalance?.usedLeaves ?? 0,
    'pendingRequests': _leaves.where((l) => l.status == 'Pending').length,
    'avgHours': _attendanceSummary?.averageHours ?? 0,
  };
  
  Future<void> loadDashboardData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      await Future.wait([
        _loadAttendance(),
        _loadLeaves(),
        _loadHolidays(),
      ]);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = ErrorHandler.handleError(e);
      _isLoading = false;
      notifyListeners();
      
      // Log error for debugging
      ErrorHandler.logError(e);
    }
  }
  
  Future<void> _loadAttendance() async {
    try {
      _attendance = await getAttendanceUseCase.execute();
      _attendanceSummary = await getAttendanceUseCase.repository.getAttendanceSummary();
    } catch (e) {
      _attendance = [];
      _attendanceSummary = null;
      rethrow;
    }
  }
  
  Future<void> _loadLeaves() async {
    try {
      _leaves = await getLeavesUseCase.execute();
      _leaveBalance = await getLeavesUseCase.repository.getLeaveBalance();
    } catch (e) {
      _leaves = [];
      _leaveBalance = null;
      rethrow;
    }
  }
  
  Future<void> _loadHolidays() async {
    try {
      _holidays = await getHolidaysUseCase.execute();
    } catch (e) {
      _holidays = [];
      rethrow;
    }
  }
  
  Future<void> refreshData() async {
    await loadDashboardData();
  }
  
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}