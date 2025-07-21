import '../ApiServiceBase.dart';

class TaskApis extends ApiServiceBase {
  TaskApis._();

  static final TaskApis _instance = TaskApis._();

  factory TaskApis() {
    return _instance;
  }

  static TaskApis get instance => _instance;

  Future<Map<String, dynamic>> get(queryParameters) {
    return httpService.get(
      '/api/task/open/task/get',
      queryParameters: queryParameters,
    );
  }

  Future<Map<String, dynamic>> getAll(queryParameters) {
    return httpService.get(
      '/api/task/open/task/getAll',
      queryParameters: queryParameters,
    );
  }

  Future<Map<String, dynamic>> getAllByPage(queryParameters) {
    return httpService.get(
      '/api/task/open/task/getAllByPage',
      queryParameters: queryParameters,
    );
  }

  create(data) {
    return httpService.post(
      '/api/task/open/task/create',
      data: data,
    );
  }

  createFromTemplate(data) {
    return httpService.post(
      '/api/task/open/task/createFromTemplate',
      data: data,
    );
  }

  createByAI(data) {
    return httpService.post(
      '/api/task/open/task/createByAI',
      data: data,
    );
  }
}