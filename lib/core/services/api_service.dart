import 'package:dio/dio.dart';

// Service class for API-related configurations and requests
class ApiService {
  ApiService();

  // Configure Dio options
  BaseOptions getApiOptions() {
    final apiOptions = BaseOptions(
      baseUrl: "https://jsonplaceholder.typicode.com", // Base API URL
      connectTimeout: const Duration(seconds: 5), // Connection timeout duration
    );
    return apiOptions;
  }

  // Create a Dio instance
  Dio getApi() {
    return Dio(getApiOptions());
  }
}
