import '../ApiServiceBase.dart';

class WalletApis extends ApiServiceBase {
  WalletApis._();

  static final WalletApis _instance = WalletApis._();

  factory WalletApis() {
    return _instance;
  }

  static WalletApis get instance => _instance;

  Future<Map<String, dynamic>> getWalletInfo() {
    return httpService.get(
      '/api/pay/open/wallet/getWalletInfo'
    );
  }

  recharge(data) {
    return httpService.post(
      '/api/pay/open/wallet/recharge',
      data: data,
    );
  }

  pay(data) {
    return httpService.post(
      '/api/pay/open/wallet/pay',
      data: data,
    );
  }
}