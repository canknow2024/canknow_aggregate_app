class NetworkConfig {
  // API基础地址
  static const String baseUrl = 'https://api.example.com'; // 替换为您的实际API地址
  
  // API版本
  static const String apiVersion = 'v1';
  
  // 完整的API基础URL
  static String get apiBaseUrl => '$baseUrl/api/$apiVersion';
  
  // 超时配置
  static const int connectTimeout = 30000; // 30秒
  static const int receiveTimeout = 30000; // 30秒
  
  // 重试配置
  static const int maxRetries = 3;
  static const int retryDelay = 1000; // 1秒
  
  // 请求头配置
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'User-Agent': 'CanknowAggregateApp/1.0.0',
  };
  
  // 是否启用调试日志
  static const bool enableDebugLogs = true;
  
  // 是否启用SSL证书验证（生产环境应该为true）
  static const bool verifySSLCertificate = true;
  
  // 缓存配置
  static const int cacheMaxAge = 300; // 5分钟
  static const int cacheMaxSize = 100; // 最大缓存条目数
  
  // 分页配置
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // 文件上传配置
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedFileTypes = [
    'image/jpeg',
    'image/png',
    'image/gif',
    'application/pdf',
    'text/plain',
  ];
  
  // 错误码映射
  static const Map<int, String> errorMessages = {
    400: '请求参数错误',
    401: '未授权，请重新登录',
    403: '禁止访问',
    404: '资源不存在',
    500: '服务器内部错误',
    502: '网关错误',
    503: '服务不可用',
    504: '网关超时',
  };
  
  // 获取错误信息
  static String getErrorMessage(int statusCode) {
    return errorMessages[statusCode] ?? '未知错误 ($statusCode)';
  }
  
  // 环境配置
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );
  
  // 是否为生产环境
  static bool get isProduction => environment == 'production';
  
  // 是否为开发环境
  static bool get isDevelopment => environment == 'development';
  
  // 是否为测试环境
  static bool get isTesting => environment == 'testing';
  
  // 根据环境获取API地址
  static String getApiUrl() {
    switch (environment) {
      case 'production':
        return 'https://api.canknow.com'; // 生产环境API地址
      case 'testing':
        return 'https://test-api.canknow.com'; // 测试环境API地址
      case 'development':
      default:
        return 'http://192.168.1.3'; // 开发环境API地址
    }
  }
} 