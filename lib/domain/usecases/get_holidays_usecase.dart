import 'package:metaup_employee_dashboard/data/repositories/employee_repository.dart';
import '../../data/models/holiday_model.dart';

class GetHolidaysUseCase {
  final EmployeeRepository repository;
  
  GetHolidaysUseCase(this.repository);
  
  Future<List<HolidayModel>> execute() {
    return repository.getHolidays();
  }
}