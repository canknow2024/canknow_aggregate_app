import '../ApiServiceBase.dart';

class UserTaskApis extends ApiServiceBase {
  UserTaskApis._();

  static final UserTaskApis _instance = UserTaskApis._();

  factory UserTaskApis() {
    return _instance;
  }

  static UserTaskApis get instance => _instance;

  getMyTaskStatistic() {
    return httpService.get(
      '/api/task/open/userTask/getMyTaskStatistic'
    );
  }

  getAll(queryParameters) {
    return httpService.get(
      '/api/task/open/userTask/getAll',
      queryParameters: queryParameters,
    );
  }

  getMakeUpCheckInUserTasks() {
    return httpService.get(
      '/api/task/open/userTask/getMakeUpCheckInUserTasks',
    );
  }

  makeUpCheckIn(data) {
    return httpService.post(
      '/api/task/open/userTask/makeUpCheckIn',
      data: data,
    );
  }

  getConsecutiveCheckInDays() {
    return httpService.get(
      '/api/task/open/userTask/getConsecutiveCheckInDays',
    );
  }

  create(data) {
    return httpService.post(
      '/api/task/open/userTask/create',
      data: data,
    );
  }

  checkIn(id) {
    return httpService.post(
      '/api/task/open/userTask/checkIn',
      data: {'userTaskId': id},
    );
  }
}