class AppConstants {
  // App Info
  static const String appName = 'Employee Dashboard';
  static const String appVersion = '1.0.0';
  
  // API Endpoints (Replace with your actual API endpoints)
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  // For real API, use: static const String baseUrl = 'https://your-api-domain.com/api/v1';
  
  static const String loginEndpoint = '/auth/login';
  static const String attendanceEndpoint = '/attendance';
  static const String leavesEndpoint = '/leaves';
  static const String holidaysEndpoint = '/holidays';
  static const String userProfileEndpoint = '/user/profile';
  static const String dashboardStatsEndpoint = '/dashboard/stats';
  
  // Shared Preferences Keys
  static const String tokenKey = 'auth_token';
  static const String userEmailKey = 'user_email';
  static const String userNameKey = 'user_name';
  static const String userIdKey = 'user_id';
  static const String userAvatarKey = 'user_avatar';
  static const String isLoggedInKey = 'is_logged_in';
  static const String rememberMeKey = 'remember_me';
  
  // UI Strings
  static const String loginTitle = 'Welcome Back';
  static const String loginSubtitle = 'Sign in to continue';
  static const String emailHint = 'Email';
  static const String passwordHint = 'Password';
  static const String loginButton = 'Login';
  static const String logoutButton = 'Logout';
  static const String dashboardTitle = 'Dashboard';
  static const String settingsTitle = 'Settings';
  static const String profileTitle = 'Profile';
  
  // Error Messages
  static const String networkError = 'Network error occurred. Please check your connection.';
  static const String serverError = 'Server error occurred. Please try again later.';
  static const String unknownError = 'An unknown error occurred. Please try again.';
  static const String invalidEmail = 'Please enter a valid email address';
  static const String invalidPassword = 'Password must be at least 6 characters';
  static const String weakPassword = 'Password is too weak';
  static const String emptyField = 'This field cannot be empty';
  
  // Dio Error Messages
  static const String connectionTimeoutError = 'Connection timeout. Please check your internet connection.';
  static const String sendTimeoutError = 'Request timeout. Please try again.';
  static const String receiveTimeoutError = 'Response timeout. Please try again.';
  static const String requestCancelledError = 'Request was cancelled.';
  static const String noInternetError = 'No internet connection. Please check your network.';
  static const String badRequestError = 'Bad request. Please check your input.';
  static const String unauthorizedError = 'Unauthorized. Please login again.';
  static const String forbiddenError = 'Access denied. You don\'t have permission.';
  static const String notFoundError = 'Resource not found.';
  static const String requestTimeoutError = 'Request timeout.';
  static const String conflictError = 'Conflict occurred.';
  static const String validationError = 'Validation error. Please check your input.';
  static const String tooManyRequestsError = 'Too many requests. Please try again later.';
  static const String internalServerError = 'Internal server error. Please try again later.';
  static const String notImplementedError = 'Feature not implemented yet.';
  static const String badGatewayError = 'Bad gateway. Please try again later.';
  static const String serviceUnavailableError = 'Service unavailable. Please try again later.';
  static const String gatewayTimeoutError = 'Gateway timeout. Please try again later.';
  static const String dataParsingError = 'Error parsing data.';
  
  // Success Messages
  static const String loginSuccess = 'Login successful!';
  static const String logoutSuccess = 'Logged out successfully!';
  static const String dataLoadedSuccess = 'Data loaded successfully!';
  static const String refreshSuccess = 'Data refreshed successfully!';
  
  // Loading Messages
  static const String loadingLogin = 'Logging in...';
  static const String loadingDashboard = 'Loading dashboard...';
  static const String loadingData = 'Loading data...';
  static const String refreshingData = 'Refreshing data...';
  
  // Validation Patterns
  static const String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phonePattern = r'^[0-9+\-\s()]{10,15}$';
  static const String urlPattern = r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$';
  static const String namePattern = r'^[a-zA-Z\s]+$';
  
  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String displayDateFormat = 'MMM d, yyyy';
  static const String displayDateTimeFormat = 'MMM d, yyyy hh:mm a';
  static const String timeFormat = 'hh:mm a';
  
  // Pagination
  static const int defaultPageSize = 10;
  static const int maxPageSize = 50;
  
  // Cache Duration (in seconds)
  static const int cacheDuration = 300; // 5 minutes
  
  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 500);
  static const Duration longAnimationDuration = Duration(milliseconds: 800);
  
  // Debounce Duration
  static const Duration debounceDuration = Duration(milliseconds: 500);
  static const Duration throttleDuration = Duration(milliseconds: 1000);
}