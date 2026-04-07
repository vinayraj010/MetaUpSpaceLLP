import 'package:metaup_employee_dashboard/data/repositories/employee_repository.dart';
import '../../data/models/leave_model.dart';

class GetLeavesUseCase {
  final EmployeeRepository repository;
  
  GetLeavesUseCase(this.repository);
  
  Future<List<LeaveModel>> execute() {
    return repository.getLeaves();
  }
}