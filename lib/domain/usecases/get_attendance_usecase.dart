import 'package:metaup_employee_dashboard/domain/repositories/employee_repository.dart';
import '../../data/models/attendance_model.dart';

class GetAttendanceUseCase {
  final EmployeeRepository repository;
  
  GetAttendanceUseCase(this.repository);
  
  Future<List<AttendanceModel>> execute() {
    return repository.getAttendance();
  }
}