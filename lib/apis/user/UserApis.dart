import '../ApiServiceBase.dart';

class UserApis extends ApiServiceBase {
  UserApis._();

  static final UserApis _instance = UserApis._();

  factory UserApis() {
    return _instance;
  }

  static UserApis get instance => _instance;

  Future<Map<String, dynamic>> currentUser() {
    return httpService.get(
      '/api/user/open/user/currentUser',
    );
  }

  Future<Map<String, dynamic>> registerByEmail(data) {
    return httpService.post(
      '/api/user/open/user/registerByEmail',
      data: data
    );
  }

  Future<Map<String, dynamic>> registerByPhoneNumber(data) {
    return httpService.post(
        '/api/user/open/user/registerByPhoneNumber',
        data: data
    );
  }

  sendSmcCodeForBindPhone(data) {
    return httpService.post(
        '/api/user/open/user/sendSmcCodeForBindPhone',
        data: data
    );
  }

  bindPhone(data) {
    return httpService.post(
        '/api/user/open/user/bindPhone',
        data: data
    );
  }
}