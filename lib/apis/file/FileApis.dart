import 'package:dio/dio.dart';
import '../ApiServiceBase.dart';

class FileApis extends ApiServiceBase {
  FileApis._();

  static final FileApis _instance = FileApis._();

  factory FileApis() {
    return _instance;
  }

  static FileApis get instance => _instance;

  Future<Map<String, dynamic>> upload(file) {
    FormData formData = FormData.fromMap({
      "file": file
    });
    return httpService.post(
        '/api/file/common/file/upload',
        data: formData
    );
  }

  Future<Map<String, dynamic>> uploadBase64ByOssId(String base64, String fileName) {
    Map<String, dynamic> data = {
      "base64": base64,
      "path": "file/" + fileName
    };
    return httpService.post(
        '/api/file/common/file/uploadBase64ByOssId',
        data: data
    );
  }
}