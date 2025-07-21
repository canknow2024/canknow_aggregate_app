import '../ApiServiceBase.dart';

class HotSearchApis extends ApiServiceBase {
  HotSearchApis._();

  static final HotSearchApis _instance = HotSearchApis._();

  factory HotSearchApis() {
    return _instance;
  }

  static HotSearchApis get instance => _instance;

  Future<Map<String, dynamic>> getAll(queryParameters) {
    return httpService.get(
      '/api/system/open/hotSearch/getAll',
      queryParameters: queryParameters,
    );
  }
}