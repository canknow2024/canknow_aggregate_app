import '../ApiServiceBase.dart';

class TaskCategoryApis extends ApiServiceBase {
  TaskCategoryApis._();

  static final TaskCategoryApis _instance = TaskCategoryApis._();

  factory TaskCategoryApis() {
    return _instance;
  }

  static TaskCategoryApis get instance => _instance;

  Future<Map<String, dynamic>> getAll(queryParameters) {
    return httpService.get(
      '/api/task/open/taskCategory/getAll',
      queryParameters: queryParameters,
    );
  }

  Future<Map<String, dynamic>> getAllByPage(queryParameters) {
    return httpService.get(
      '/api/task/open/taskCategory/getAllByPage',
      queryParameters: queryParameters,
    );
  }
}