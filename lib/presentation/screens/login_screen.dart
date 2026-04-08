import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/dashboard_provider.dart';
import 'dashboard_screen.dart';
import '../../core/themes/app_theme.dart';
import '../../core/utils/validators.dart';
import '../../core/utils/error_handler.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(AuthProvider authProvider, DashboardProvider dashboardProvider) async {
    if (_formKey.currentState!.validate()) {
      final success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
      
      if (success && mounted) {
        // Show success message
        ErrorHandler.showSuccessSnackBar(context, 'Login successful!');
        
        await dashboardProvider.loadDashboardData();
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const DashboardScreen()),
          );
        }
      } else if (mounted && authProvider.errorMessage != null) {
        // Show error message
        ErrorHandler.showErrorSnackBar(context, authProvider.errorMessage!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.business_center,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sign in to continue',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: Validators.validateEmail,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _handleLogin(authProvider, context.read<DashboardProvider>()),
                          validator: Validators.validatePassword,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: authProvider.isLoading
                        ? null
                        : () => _handleLogin(authProvider, context.read<DashboardProvider>()),
                    child: authProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Login'),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          'Demo Credentials',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Email: demo@example.com\nPassword: any (min 6 chars)',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}