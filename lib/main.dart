import 'package:flutter/material.dart';
import 'package:metaup_employee_dashboard/presentation/screens/dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/themes/app_theme.dart';
import 'data/datasources/remote/api_service.dart';
import 'data/repositories/employee_repository_impl.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/get_attendance_usecase.dart';
import 'domain/usecases/get_leaves_usecase.dart';
import 'domain/usecases/get_holidays_usecase.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/dashboard_provider.dart';
import 'presentation/screens/login_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final apiService = ApiService();
  final repository = EmployeeRepositoryImpl(apiService: apiService, sharedPreferences: prefs);
  
  runApp(MyApp(
    loginUseCase: LoginUseCase(repository),
    getAttendanceUseCase: GetAttendanceUseCase(repository),
    getLeavesUseCase: GetLeavesUseCase(repository),
    getHolidaysUseCase: GetHolidaysUseCase(repository),
  ));
}

class MyApp extends StatelessWidget {
  final LoginUseCase loginUseCase;
  final GetAttendanceUseCase getAttendanceUseCase;
  final GetLeavesUseCase getLeavesUseCase;
  final GetHolidaysUseCase getHolidaysUseCase;
  
  const MyApp({
    super.key,
    required this.loginUseCase,
    required this.getAttendanceUseCase,
    required this.getLeavesUseCase,
    required this.getHolidaysUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(loginUseCase: loginUseCase),
        ),
        ChangeNotifierProvider(
          create: (_) => DashboardProvider(
            getAttendanceUseCase: getAttendanceUseCase,
            getLeavesUseCase: getLeavesUseCase,
            getHolidaysUseCase: getHolidaysUseCase,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Employee Dashboard',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const LoginScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/dashboard': (context) => const DashboardScreen(),
        },
      ),
    );
  }
}
