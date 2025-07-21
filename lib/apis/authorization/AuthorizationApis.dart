import 'dart:convert';
import 'package:dio/dio.dart';
import '../../config/AppConfig.dart';
import '../ApiServiceBase.dart';

class AuthorizationApis extends ApiServiceBase {
  AuthorizationApis._();
  
  static final AuthorizationApis _instance = AuthorizationApis._();
  
  factory AuthorizationApis() {
    return _instance;
  }
  
  static AuthorizationApis get instance => _instance;

  Future<Map<String, dynamic>> token(Map<String, dynamic> data) {
    final clientId = AppConfig.clientId;
    final clientSecret = AppConfig.clientSecret;
    final basicAuth = 'Basic ' + base64Encode(utf8.encode('$clientId:$clientSecret'));

    Map<String, dynamic> headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': basicAuth,
    };
    Options options = Options(headers: headers);

    var formData = FormData.fromMap(data);
    return httpService.post(
        '/api/authorization/interface/oauth2/token',
        data: formData,
        options: options
    );
  }

  send(Map<String, dynamic> data) {
    return httpService.post(
        '/api/authorization/interface/sms-code/send',
        data: data
    );
  }
}