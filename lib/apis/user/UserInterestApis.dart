import '../ApiServiceBase.dart';

class UserInterestApis extends ApiServiceBase {
  UserInterestApis._();

  static final UserInterestApis _instance = UserInterestApis._();

  factory UserInterestApis() {
    return _instance;
  }

  static UserInterestApis get instance => _instance;

  Future<Map<String, dynamic>> getAll(queryParameters) {
    return httpService.get(
      '/api/user/open/userInterest/getAll',
      queryParameters: queryParameters,
    );
  }

  create(data) {
    return httpService.post(
      '/api/user/open/userInterest/create',
      data: data,
    );
  }
}