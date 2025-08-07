import 'dart:async';
import 'package:canknow_aggregate_app/config/WechatConfig.dart';
import 'package:fluwx/fluwx.dart';

class WechatUtil {
  static Fluwx fluwx = Fluwx();
  static FluwxCancelable? _authSubscription;
  static FluwxCancelable? _paySubscription;

  static initialize() async {
    await fluwx.registerApi(
      appId: WechatConfig.appId,
      doOnAndroid: true,
      doOnIOS: true,
      universalLink: WechatConfig.universalLink,
    );
    var result = await fluwx.isWeChatInstalled;
  }

  static Future<String> pay(Payment payment) async {
    final completer = Completer<String>();

    // 先取消之前的订阅
    _paySubscription?.cancel();

    // 添加新的订阅
    _paySubscription = fluwx.addSubscriber((response) {
      if (response is WeChatPaymentResponse) {
        if (response.errCode == 0) {
          completer.complete("");
        }
        else {
          completer.completeError('微信支付失败: ${response.errCode} - ${response.errStr}');
        }
      }
      else if (response is WeChatResponse && response.errCode != 0) {
        if (!completer.isCompleted) {
          completer.completeError('微信支付失败: ${response.errCode} - ${response.errStr}');
        }
      }
    });

    try {
      fluwx.pay(which: payment);

      // 添加超时处理
      return completer.future.timeout(
        Duration(seconds: 30),
        onTimeout: () {
          if (!completer.isCompleted) {
            completer.completeError('微信授权超时');
          }
          throw TimeoutException('微信授权超时', Duration(seconds: 30));
        },
      );
    }
    catch (e) {
      if (!completer.isCompleted) {
        completer.completeError('微信支付异常: $e');
      }
      rethrow;
    }
  }

  static Future<String> authorize() async {
    final completer = Completer<String>();
    
    // 先取消之前的订阅
    _authSubscription?.cancel();
    
    // 添加新的订阅
    _authSubscription = fluwx.addSubscriber((response) {
      if (response is WeChatAuthResponse) {
        if (!completer.isCompleted) {
          completer.complete(response.code);
        }
      }
      else if (response is WeChatResponse && response.errCode != 0) {
        if (!completer.isCompleted) {
          completer.completeError('微信授权失败: ${response.errCode} - ${response.errStr}');
        }
      }
    });

    try {
      fluwx.authBy(which: NormalAuth(scope: 'snsapi_userinfo', state: 'wechat_sdk_demo_test'));
      
      // 添加超时处理
      return completer.future.timeout(
        Duration(seconds: 30),
        onTimeout: () {
          if (!completer.isCompleted) {
            completer.completeError('微信授权超时');
          }
          throw TimeoutException('微信授权超时', Duration(seconds: 30));
        },
      );
    }
    catch (e) {
      if (!completer.isCompleted) {
        completer.completeError('微信授权异常: $e');
      }
      rethrow;
    }
  }

  static void dispose() {
    _authSubscription?.cancel();
    _authSubscription = null;
  }
} 