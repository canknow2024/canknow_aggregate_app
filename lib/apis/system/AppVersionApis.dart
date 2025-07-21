import '../ApiServiceBase.dart';

class AppVersionApis extends ApiServiceBase {
  AppVersionApis._();

  static final AppVersionApis _instance = AppVersionApis._();

  factory AppVersionApis() {
    return _instance;
  }

  static AppVersionApis get instance => _instance;

  Future<Map<String, dynamic>> getLatest({required String clientId, required String platform}) {
    return httpService.get(
      '/api/system/open/appVersion/getLatest',
      queryParameters: {
        'clientId': clientId,
        'platform': platform,
      },
    );
  }
}