import '../ApiServiceBase.dart';

class SettingApis extends ApiServiceBase {
  SettingApis._();

  static final SettingApis _instance = SettingApis._();

  factory SettingApis() {
    return _instance;
  }

  static SettingApis get instance => _instance;

  Future<Map<String, dynamic>> getApplicationSetting(queryParameters) {
    return httpService.get(
      '/api/system/open/setting/getApplicationSetting',
      queryParameters: queryParameters,
    );
  }

  Future<Map<String, dynamic>> getServiceAgreement() {
    return httpService.get(
      '/api/system/open/setting/getApplicationSetting',
      queryParameters: {
        "name": "application.serviceAgreement"
      },
    );
  }

  Future<Map<String, dynamic>> getPrivacyPolicy() {
    return httpService.get(
      '/api/system/open/setting/getApplicationSetting',
      queryParameters: {
        "name": "application.privacyPolicy"
      },
    );
  }
}