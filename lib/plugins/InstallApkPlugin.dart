import 'dart:async';
import 'package:flutter/services.dart';

class InstallApkPlugin {
  static const MethodChannel _channel = MethodChannel('install_apk_plugin');

  static Future<String> get platformVersion async {
    final String version = (await _channel.invokeMethod('getPlatformVersion')) as String;
    return version;
  }

  static Future<bool> installApk(String path) async {
    try {
      final bool isSuccess = (await _channel.invokeMethod('installApk', {'path': path})) as bool;
      return isSuccess;
    }
    on PlatformException catch (e) {
      print('安装APK失败: ${e.code} - ${e.message}');
      return false;
    }
    catch (e) {
      print('安装APK异常: $e');
      return false;
    }
  }
}