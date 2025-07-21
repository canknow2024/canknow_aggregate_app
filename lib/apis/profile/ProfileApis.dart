import '../ApiServiceBase.dart';

class ProfileApis extends ApiServiceBase {
  ProfileApis._();

  static final ProfileApis _instance = ProfileApis._();

  factory ProfileApis() {
    return _instance;
  }

  static ProfileApis get instance => _instance;

  Future<Map<String, dynamic>> getProfile() {
    return httpService.get(
      '/api/user/open/profile/getProfile',
    );
  }

  Future<Map<String, dynamic>> updateProfile(data) {
    return httpService.post(
      '/api/user/open/profile/updateProfile',
      data: data
    );
  }
}