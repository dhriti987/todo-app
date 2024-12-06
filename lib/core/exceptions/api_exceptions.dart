import 'package:dio/dio.dart';

// Custom exception class for handling API-related errors
class ApiException implements Exception {
  final DioException exception; // The Dio exception object
  final List<String> error; // Custom error messages

  ApiException({required this.exception, required this.error});

  // Returns error messages based on exception type
  List<String> call() {
    switch (exception.type) {
      case DioExceptionType.connectionError:
        return [
          "Connectivity Error",
          "Could not Connect to the Server, Please Check Your Internet Connection."
        ];
      default:
        return error; // Return the provided error messages
    }
  }
}
