import '../ApiServiceBase.dart';

class TaskTemplateApis extends ApiServiceBase {
  TaskTemplateApis._();

  static final TaskTemplateApis _instance = TaskTemplateApis._();

  factory TaskTemplateApis() {
    return _instance;
  }

  static TaskTemplateApis get instance => _instance;

  Future<Map<String, dynamic>> get(queryParameters) {
    return httpService.get(
      '/api/task/open/taskTemplate/get',
      queryParameters: queryParameters,
    );
  }

  Future<Map<String, dynamic>> getAll(queryParameters) {
    return httpService.get(
      '/api/task/open/taskTemplate/getAll',
      queryParameters: queryParameters,
    );
  }

  Future<Map<String, dynamic>> getAllByPage(queryParameters) {
    return httpService.get(
      '/api/task/open/taskTemplate/getAllByPage',
      queryParameters: queryParameters,
    );
  }
}