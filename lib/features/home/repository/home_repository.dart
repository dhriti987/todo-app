import 'package:dio/dio.dart';
import 'package:todo/core/exceptions/api_exceptions.dart';
import 'package:todo/core/services/api_service.dart';
import 'package:todo/models/task_model.dart';

class HomeRepository {
  final ApiService apiService;
  final getTasksUrl = "/todos";

  HomeRepository({required this.apiService});

  // Fetch tasks from the API
  Future<List<Task>> getAllTasks() async {
    Dio api = apiService.getApi();

    try {
      var response = await api.get(getTasksUrl);
      // Return first 5 tasks
      return Task.listFromJson(response.data).sublist(0, 5);
    } on DioException catch (e) {
      // Handle API errors
      throw ApiException(
          exception: e, error: ['Unexpected Error', 'Error fetching tasks']);
    }
  }
}
