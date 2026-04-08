import 'package:flutter/material.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../data/models/user_model.dart';
import '../../core/utils/validators.dart';
import '../../core/utils/error_handler.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  
  AuthProvider({required this.loginUseCase});
  
  bool _isLoading = false;
  String? _errorMessage;
  UserModel? _user;
  
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;
  String? get userName => _user?.name;
  String? get userEmail => _user?.email;
  
  Future<bool> login(String email, String password) async {
    // Validate inputs before making API call
    final emailError = Validators.validateEmail(email);
    final passwordError = Validators.validatePassword(password);
    
    if (emailError != null) {
      _errorMessage = emailError;
      notifyListeners();
      return false;
    }
    
    if (passwordError != null) {
      _errorMessage = passwordError;
      notifyListeners();
      return false;
    }
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _user = await loginUseCase.execute(email.trim(), password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = ErrorHandler.handleError(e);
      _isLoading = false;
      notifyListeners();
      
      // Log error for debugging
      ErrorHandler.logError(e);
      
      return false;
    }
  }
  
  void logout() {
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }
  
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}