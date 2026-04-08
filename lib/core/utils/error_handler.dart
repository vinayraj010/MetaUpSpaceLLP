import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../themes/app_theme.dart';
class ErrorHandler {
  // Handle different types of errors
  static String handleError(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    } else if (error is Exception) {
      return _handleGenericException(error);
    } else if (error is String) {
      return error;
    } else {
      return AppConstants.unknownError;
    }
  }

  // Handle Dio-specific errors
  static String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return AppConstants.connectionTimeoutError;

      case DioExceptionType.sendTimeout:
        return AppConstants.sendTimeoutError;

      case DioExceptionType.receiveTimeout:
        return AppConstants.receiveTimeoutError;

      case DioExceptionType.badResponse:
        return _handleStatusCode(
          error.response?.statusCode,
          error.response?.data,
        );

      case DioExceptionType.cancel:
        return AppConstants.requestCancelledError;

      case DioExceptionType.connectionError:
        return AppConstants.noInternetError;

      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') ?? false) {
          return AppConstants.noInternetError;
        }
        return AppConstants.networkError;

      default:
        return AppConstants.unknownError;
    }
  }

  // Handle HTTP status codes
  static String _handleStatusCode(int? statusCode, dynamic responseData) {
    switch (statusCode) {
      case 400:
        return _extractErrorMessage(responseData) ??
            AppConstants.badRequestError;

      case 401:
        return AppConstants.unauthorizedError;

      case 403:
        return AppConstants.forbiddenError;

      case 404:
        return AppConstants.notFoundError;

      case 408:
        return AppConstants.requestTimeoutError;

      case 409:
        return AppConstants.conflictError;

      case 422:
        return _extractErrorMessage(responseData) ??
            AppConstants.validationError;

      case 429:
        return AppConstants.tooManyRequestsError;

      case 500:
        return AppConstants.internalServerError;

      case 501:
        return AppConstants.notImplementedError;

      case 502:
        return AppConstants.badGatewayError;

      case 503:
        return AppConstants.serviceUnavailableError;

      case 504:
        return AppConstants.gatewayTimeoutError;

      default:
        return '${AppConstants.serverError} (Status: $statusCode)';
    }
  }

  // Extract error message from response data
  static String? _extractErrorMessage(dynamic responseData) {
    if (responseData == null) return null;

    try {
      // Handle Map response
      if (responseData is Map) {
        if (responseData.containsKey('message')) {
          return responseData['message'].toString();
        }
        if (responseData.containsKey('error')) {
          return responseData['error'].toString();
        }
        if (responseData.containsKey('errors')) {
          final errors = responseData['errors'];
          if (errors is Map) {
            return errors.values.first.toString();
          }
          if (errors is List) {
            return errors.first.toString();
          }
        }
      }

      // Handle String response
      if (responseData is String) {
        return responseData;
      }
    } catch (e) {
      return null;
    }

    return null;
  }

  // Handle generic exceptions
  static String _handleGenericException(Exception error) {
    final errorString = error.toString();

    if (errorString.contains('SocketException')) {
      return AppConstants.noInternetError;
    }

    if (errorString.contains('FormatException')) {
      return AppConstants.dataParsingError;
    }

    return AppConstants.unknownError;
  }

  // Show error snackbar
  static void showErrorSnackBar(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
        duration: duration ?? const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  // Show success snackbar
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Show warning snackbar
  static void showWarningSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.warning_amber_outlined,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppTheme.warningColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // Show info snackbar
  static void showInfoSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Log error for debugging
  static void logError(dynamic error, {StackTrace? stackTrace}) {
    print('═══════════════════════════════════════════════════════');
    print('ERROR: ${error.toString()}');
    if (stackTrace != null) {
      print('STACK TRACE: $stackTrace');
    }
    print('═══════════════════════════════════════════════════════');
  }

  // Check if error is network related
  static bool isNetworkError(dynamic error) {
    if (error is DioException) {
      return error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout;
    }
    return error.toString().contains('SocketException') ||
        error.toString().contains('Network');
  }

  // Check if error is authentication related
  static bool isAuthError(dynamic error) {
    if (error is DioException) {
      return error.response?.statusCode == 401 ||
          error.response?.statusCode == 403;
    }
    return false;
  }

  // Get user-friendly error message for form validation
  static String getFormattedErrorMessage(String error) {
    // Capitalize first letter
    if (error.isEmpty) return error;
    return error[0].toUpperCase() + error.substring(1);
  }
}
