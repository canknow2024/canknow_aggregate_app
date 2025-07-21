import '../ApiServiceBase.dart';

class TaskTopicApis extends ApiServiceBase {
  TaskTopicApis._();

  static final TaskTopicApis _instance = TaskTopicApis._();

  factory TaskTopicApis() {
    return _instance;
  }

  static TaskTopicApis get instance => _instance;

  Future<Map<String, dynamic>> getAll(queryParameters) {
    return httpService.get(
      '/api/task/open/taskTopic/getAll',
      queryParameters: queryParameters,
    );
  }


  Future<Map<String, dynamic>> getAllByPage(queryParameters) {
    return httpService.get(
      '/api/task/open/taskTopic/getAllByPage',
      queryParameters: queryParameters,
    );
  }
}