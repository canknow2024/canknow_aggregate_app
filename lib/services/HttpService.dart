import 'package:canknow_aggregate_app/services/TokenServices.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../config/NetworkConfig.dart';
import '../utils/TextUtil.dart';
import '../utils/ToastUtil.dart';

class HttpService {
  late Dio _dio;
  static HttpService? _instance;

  HttpService._() {
    _dio = Dio(BaseOptions(
      baseUrl: NetworkConfig.getApiUrl(),
      connectTimeout: Duration(milliseconds: NetworkConfig.connectTimeout),
      receiveTimeout: Duration(milliseconds: NetworkConfig.receiveTimeout),
      headers: NetworkConfig.defaultHeaders,
      validateStatus: (status) {
        return status != null && status < 500;
      },
    ));

    _setupInterceptors();
  }

  static HttpService get instance {
    _instance ??= HttpService._();
    return _instance!;
  }

  void _setupInterceptors() {
    // 请求拦截器
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // 添加token到请求头
        final token = TokenServices.getToken();

        if (TextUtil.isNotEmpty(token)) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        
        // 添加时间戳和签名（可选的安全措施）
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        options.headers['X-Timestamp'] = timestamp.toString();
        
        // 添加请求ID用于追踪
        options.headers['X-Request-ID'] = _generateRequestId();
        
        handler.next(options);
      },
      onResponse: (response, handler) {
        if (response.statusCode! >= 200 && response.statusCode! < 300) {
          if (response.data != null) {
            if (response.data is String) {

            }
            else if (response.data is Map) {
              Map<String, dynamic> data = response.data;

              if (data['code'] == 500) {
                ToastUtil.show(data['message']);
              }
            }
          }
        }
        else if (response.statusCode == 401) {
          TokenServices.clearToken();
          const message = '登录已过期，请重新登录';
          ToastUtil.showAuthError(message);
        }
        else {
          _handleHttpError(response);
        }
        handler.next(response);
      },
      onError: (e, handler) async {
        if (e.response != null) {
          String? message = e.message;

          if (e.response!.statusCode == 401) {
            await TokenServices.clearToken();
            message = '登录已过期，请重新登录';
            ToastUtil.showAuthError(message);
            // 跳转到登录页面
          }
          else if (e.response?.data?['code'] == 5001) {
            message = e.response!.data['data'][0] as String;
            ToastUtil.showError(message);
          }
          else if (e.response?.data is Map) {
            if (TextUtil.isNotEmpty(e.response!.data['message'] as String?)) {
              message = e.response!.data['message'] as String;
              ToastUtil.showError(message);
            }
          }
          else {
            _handleHttpError(e.response);
          }
        }
        else {
          _handleNetworkError(e);
        }
        handler.next(e);
      },
    ));

    // 日志拦截器（仅在调试模式下启用）
    if (NetworkConfig.enableDebugLogs) {
      _dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ));
    }

    // 重试拦截器
    _dio.interceptors.add(RetryInterceptor(
      dio: _dio,
      logPrint: print,
      retries: NetworkConfig.maxRetries,
      retryDelays: List.generate(
        NetworkConfig.maxRetries,
        (index) => Duration(milliseconds: NetworkConfig.retryDelay * (index + 1)),
      ),
    ));
  }

  // 生成请求ID
  String _generateRequestId() {
    return DateTime.now().millisecondsSinceEpoch.toString() + (1000 + DateTime.now().microsecond % 9000).toString();
  }

  // 处理HTTP错误
  void _handleHttpError(Response? response) {
    final statusCode = response?.statusCode;
    String message;
    
    switch (statusCode) {
      case 400:
        message = '请求参数错误';
        break;
      case 403:
        message = '没有权限访问此资源';
        break;
      case 404:
        message = '请求的资源不存在';
        break;
      case 405:
        message = '请求方法不允许';
        break;
      case 408:
        message = '请求超时';
        break;
      case 429:
        message = '请求过于频繁，请稍后再试';
        break;
      case 500:
        message = '服务器内部错误';
        ToastUtil.showServerError(message);
        return;
      case 502:
        message = '网关错误';
        ToastUtil.showServerError(message);
        return;
      case 503:
        message = '服务暂时不可用';
        ToastUtil.showServerError(message);
        return;
      case 504:
        message = '网关超时';
        ToastUtil.showServerError(message);
        return;
      default:
        message = '请求失败 (${statusCode ?? '未知'})';
    }
    
    ToastUtil.showError(message);
  }

  // 处理网络错误
  void _handleNetworkError(DioException e) {
    String message;
    
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = '网络超时，请检查网络连接';
        break;
      case DioExceptionType.connectionError:
        message = '网络连接错误，请检查网络设置';
        break;
      case DioExceptionType.cancel:
        message = '请求被取消';
        break;
      case DioExceptionType.badCertificate:
        message = '证书验证失败';
        break;
      case DioExceptionType.unknown:
        message = '未知网络错误';
        break;
      default:
        message = '网络错误: ${e.message}';
    }
    
    ToastUtil.showNetworkError(message);
  }

  // GET请求
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path, 
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse(response);
    }
    catch (e) {
      throw _handleError(e);
    }
  }

  // POST请求
  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse(response);
    }
    catch (e) {
      throw _handleError(e);
    }
  }

  // PUT请求
  Future<T> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse(response);
    }
    catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE请求
  Future<T> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // 文件上传
  Future<Map<String, dynamic>> uploadFile(
    String path, {
    required String filePath,
    String? fileName,
    Map<String, dynamic>? formData,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final formDataObj = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
        ...?formData,
      });

      final response = await _dio.post(
        path,
        data: formDataObj,
        onSendProgress: onSendProgress,
      );
      return _handleResponse(response);
    }
    catch (e) {
      throw _handleError(e);
    }
  }

  // 处理响应
  _handleResponse<T>(Response response) {
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      if (response.data is Map<String, dynamic>) {
        if (response.data['data'] != null) {
          return response.data['data'];
        }
      }
      return response.data;
    }
    throw HttpException(
      NetworkConfig.getErrorMessage(response.statusCode!),
      response.statusCode,
    );
  }

  // 处理错误
  Exception _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return HttpException('网络超时，请检查网络连接');
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          return HttpException(
            NetworkConfig.getErrorMessage(statusCode ?? 0),
            statusCode,
          );
        case DioExceptionType.cancel:
          return HttpException('请求被取消');
        case DioExceptionType.connectionError:
          return HttpException('网络连接错误，请检查网络设置');
        default:
          return HttpException('网络错误: ${error.message}');
      }
    }
    return HttpException('未知错误: $error');
  }

  // 获取Dio实例（用于高级用法）
  Dio get dio => _dio;
}

class HttpException implements Exception {
  final String message;
  final int? statusCode;

  HttpException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

// 重试拦截器
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final Function(String) logPrint;
  final int retries;
  final List<Duration> retryDelays;

  RetryInterceptor({
    required this.dio,
    required this.logPrint,
    required this.retries,
    required this.retryDelays,
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    var extra = err.requestOptions.extra;
    var retryCount = extra['retryCount'] ?? 0;

    if (_shouldRetry(err) && retryCount < retries) {
      extra['retryCount'] = retryCount + 1;

      logPrint('重试请求 ${err.requestOptions.path} (${retryCount + 1}/$retries)');

      await Future.delayed(retryDelays[retryCount]);

      try {
        final response = await dio.fetch(err.requestOptions);
        handler.resolve(response);
        return;
      }
      catch (e) {
        handler.next(err);
        return;
      }
    }

    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
           err.type == DioExceptionType.sendTimeout ||
           err.type == DioExceptionType.receiveTimeout ||
           err.type == DioExceptionType.connectionError ||
           (err.response?.statusCode ?? 0) >= 500;
  }
}
