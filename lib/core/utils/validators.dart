import 'package:flutter/material.dart';

class Validators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    // Remove all whitespace
    final email = value.trim();
    
    if (email.isEmpty) {
      return 'Email cannot be empty';
    }
    
    // Regular expression for email validation
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address (e.g., name@example.com)';
    }
    
    return null;
  }
  
  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    
    if (value.length > 50) {
      return 'Password must be less than 50 characters';
    }
    
    // Optional: Add strength validation
    // bool hasUpperCase = value.contains(RegExp(r'[A-Z]'));
    // bool hasLowerCase = value.contains(RegExp(r'[a-z]'));
    // bool hasDigits = value.contains(RegExp(r'[0-9]'));
    // bool hasSpecialChars = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    
    // if (!hasUpperCase) {
    //   return 'Password must contain at least one uppercase letter';
    // }
    // if (!hasLowerCase) {
    //   return 'Password must contain at least one lowercase letter';
    // }
    // if (!hasDigits) {
    //   return 'Password must contain at least one number';
    // }
    
    return null;
  }
  
  // Confirm password validation
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != password) {
      return 'Passwords do not match';
    }
    
    return null;
  }
  
  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    
    final name = value.trim();
    
    if (name.length < 2) {
      return 'Name must be at least 2 characters long';
    }
    
    if (name.length > 50) {
      return 'Name must be less than 50 characters';
    }
    
    // Check if name contains only letters and spaces
    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    if (!nameRegex.hasMatch(name)) {
      return 'Name can only contain letters and spaces';
    }
    
    return null;
  }
  
  // Phone number validation
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Phone number is optional
    }
    
    final phone = value.trim();
    
    // Check if phone contains only digits, spaces, +, -, ()
    final phoneRegex = RegExp(r'^[0-9+\-\s()]{10,15}$');
    if (!phoneRegex.hasMatch(phone)) {
      return 'Please enter a valid phone number';
    }
    
    return null;
  }
  
  // Required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    if (value.trim().isEmpty) {
      return '$fieldName cannot be empty';
    }
    
    return null;
  }
  
  // Number validation
  static String? validateNumber(String? value, {int min = 0, int max = 100}) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    
    final number = int.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }
    
    if (number < min) {
      return 'Number must be at least $min';
    }
    
    if (number > max) {
      return 'Number must be at most $max';
    }
    
    return null;
  }
  
  // URL validation
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    
    final urlRegex = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
      caseSensitive: false,
    );
    
    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }
    
    return null;
  }
  
  // Date validation
  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    
    try {
      DateTime.parse(value);
      return null;
    } catch (e) {
      return 'Please enter a valid date (YYYY-MM-DD)';
    }
  }
  
  // Email format check (returns bool)
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    return emailRegex.hasMatch(email);
  }
  
  // Password strength check (returns 0-4)
  static int getPasswordStrength(String password) {
    int strength = 0;
    
    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[a-z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;
    
    return strength;
  }
  
  // Get password strength text
  static String getPasswordStrengthText(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return 'Weak';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Strong';
      case 5:
        return 'Very Strong';
      default:
        return 'Unknown';
    }
  }
  
  // Get password strength color
  static Color getPasswordStrengthColor(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow.shade700;
      case 4:
        return Colors.lightGreen;
      case 5:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}