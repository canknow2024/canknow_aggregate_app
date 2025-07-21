import '../utils/LocalStorage.dart';
import '../utils/TextUtil.dart';

class TokenServices {
  static bool get isAuthorized {
    return TextUtil.isNotEmpty(getToken());
  }

  static setToken(String token) {
    LocalStorage.setString('token', token);
  }

  static String? getToken() {
    return LocalStorage.getString('token');
  }

  static clearToken() {
    LocalStorage.remove('token');
  }
}