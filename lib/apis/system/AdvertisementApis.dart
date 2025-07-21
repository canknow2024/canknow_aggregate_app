import '../ApiServiceBase.dart';

class AdvertisementApis extends ApiServiceBase {
  AdvertisementApis._();

  static final AdvertisementApis _instance = AdvertisementApis._();

  factory AdvertisementApis() {
    return _instance;
  }

  static AdvertisementApis get instance => _instance;

  Future<Map<String, dynamic>> find({required String clientId, required String scene}) {
    return httpService.get(
      '/api/system/open/advertisement/find',
      queryParameters: {
        'clientId': clientId,
        'scene': scene,
      },
    );
  }

  Future<Map<String, dynamic>> getAll({required String clientId, required String scene}) {
    return httpService.get(
      '/api/system/open/advertisement/getAll',
      queryParameters: {
        'clientId': clientId,
        'scene': scene,
      },
    );
  }
}