import 'package:metaup_employee_dashboard/domain/repositories/employee_repository.dart';
import '../../data/models/user_model.dart';

class LoginUseCase {
  final EmployeeRepository repository;
  
  LoginUseCase(this.repository);
  
  Future<UserModel> execute(String email, String password) {
    return repository.login(email, password);
  }
}