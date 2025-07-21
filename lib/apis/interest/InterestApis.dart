import '../ApiServiceBase.dart';

class InterestApis extends ApiServiceBase {
  InterestApis._();

  static final InterestApis _instance = InterestApis._();

  factory InterestApis() {
    return _instance;
  }

  static InterestApis get instance => _instance;

  Future<Map<String, dynamic>> get(queryParameters) {
    return httpService.get(
      '/api/user/open/interest/get',
      queryParameters: queryParameters,
    );
  }

  Future<Map<String, dynamic>> getAll(queryParameters) {
    return httpService.get(
      '/api/user/open/interest/getAll',
      queryParameters: queryParameters,
    );
  }

  Future<Map<String, dynamic>> getAllByPage(queryParameters) {
    return httpService.get(
      '/api/user/open/interest/getAllByPage',
      queryParameters: queryParameters,
    );
  }
}