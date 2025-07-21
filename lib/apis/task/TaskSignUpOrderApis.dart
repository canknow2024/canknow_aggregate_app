import '../ApiServiceBase.dart';

class TaskSignUpOrderApis extends ApiServiceBase {
  TaskSignUpOrderApis._();

  static final TaskSignUpOrderApis _instance = TaskSignUpOrderApis._();

  factory TaskSignUpOrderApis() {
    return _instance;
  }

  static TaskSignUpOrderApis get instance => _instance;

  create(data) {
    return httpService.post(
      '/api/task/open/taskSignUpOrder/create',
      data: data,
    );
  }

  pay(queryParameters) {
    return httpService.get(
      '/api/task/open/taskSignUpOrder/pay',
      queryParameters: queryParameters,
    );
  }
}