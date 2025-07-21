# 蜗牛打卡

一个基于Flutter的聚合应用，集成了完整的网络请求封装和用户认证系统。

## 功能特性

- 🔐 完整的用户认证系统（登录、注册、登出）
- 🌐 强大的网络请求封装（基于Dio）
- 🔄 自动Token刷新机制
- 📱 响应式UI设计
- 🌍 国际化支持
- 🎨 主题切换功能
- 📊 用户信息管理

## 网络请求封装架构

### 核心组件

1. **HttpService** (`lib/services/http_service.dart`)
   - 基于Dio的HTTP客户端封装
   - 自动Token管理和刷新
   - 请求/响应拦截器
   - 错误处理和重试机制
   - 文件上传支持

2. **ApiService** (`lib/services/api_service.dart`)
   - 具体的API接口实现
   - 登录、注册、用户信息管理等
   - 统一的响应格式处理

3. **NetworkConfig** (`lib/utils/network_config.dart`)
   - 网络配置管理
   - 环境配置（开发/测试/生产）
   - 超时、重试等参数配置

4. **AuthProvider** (`lib/providers/auth_provider.dart`)
   - 用户认证状态管理
   - 集成API服务
   - 本地状态持久化

### 使用示例

#### 1. 基本HTTP请求

```dart
// 获取数据
final data = await HttpService.instance.get<Map<String, dynamic>>(
  '/api/users',
  fromJson: (json) => json as Map<String, dynamic>,
);

// 发送数据
final response = await HttpService.instance.post<Map<String, dynamic>>(
  '/api/users',
  data: {'name': 'John', 'email': 'john@example.com'},
  fromJson: (json) => json as Map<String, dynamic>,
);
```

#### 2. 用户认证

```dart
// 登录
final success = await ref.read(authProvider.notifier).login(
  'username',
  'password',
);

// 注册
final success = await ref.read(authProvider.notifier).register(
  'username',
  'password',
  'email@example.com',
);

// 登出
await ref.read(authProvider.notifier).logout();
```

#### 3. 文件上传

```dart
final response = await HttpService.instance.uploadFile<Map<String, dynamic>>(
  '/api/upload',
  filePath: '/path/to/file.jpg',
  fileName: 'avatar.jpg',
  formData: {'type': 'avatar'},
  onSendProgress: (sent, total) {
    print('上传进度: ${(sent / total * 100).toStringAsFixed(0)}%');
  },
);
```

### 配置说明

#### 环境配置

在 `lib/utils/network_config.dart` 中配置不同环境的API地址：

```dart
static String getApiUrl() {
  switch (environment) {
    case 'production':
      return 'https://api.canknow.com';
    case 'testing':
      return 'https://test-api.canknow.com';
    case 'development':
    default:
      return 'http://localhost:8080';
  }
}
```

#### 运行环境

```bash
# 开发环境
flutter run --dart-define=ENVIRONMENT=development

# 测试环境
flutter run --dart-define=ENVIRONMENT=testing

# 生产环境
flutter run --dart-define=ENVIRONMENT=production
```

### Token管理

系统自动处理Token的存储、刷新和过期：

1. **自动存储**: 登录成功后自动保存Token到本地
2. **自动刷新**: Token过期时自动使用refreshToken刷新
3. **自动清理**: 登出或刷新失败时自动清除本地Token

### 错误处理

统一的错误处理机制：

- 网络超时自动重试
- HTTP状态码错误映射
- 用户友好的错误提示
- 详细的错误日志

### 安全特性

- Bearer Token认证
- 请求时间戳验证
- 请求ID追踪
- SSL证书验证
- 敏感信息本地加密存储

## 项目结构

```
lib/
├── models/           # 数据模型
│   └── api_response.dart
├── services/         # 服务层
│   ├── http_service.dart
│   └── api_service.dart
├── providers/        # 状态管理
│   └── auth_provider.dart
├── pages/           # 页面
│   ├── login_page.dart
│   ├── home_page.dart
│   └── settings_page.dart
├── utils/           # 工具类
│   └── network_config.dart
└── main.dart        # 应用入口
```

## 安装和运行

1. 安装依赖：
```bash
flutter pub get
```

2. 生成代码（如果需要）：
```bash
flutter packages pub run build_runner build
```

3. 运行应用：
```bash
flutter run
```

## 依赖包

- `dio`: HTTP客户端
- `pretty_dio_logger`: 网络请求日志
- `json_annotation`: JSON序列化
- `crypto`: 加密功能
- `shared_preferences`: 本地存储
- `flutter_riverpod`: 状态管理
- `go_router`: 路由管理
- `easy_localization`: 国际化

## 注意事项

1. 请根据实际API地址修改 `NetworkConfig.getApiUrl()` 方法
2. 生产环境请确保启用SSL证书验证
3. 敏感信息请使用安全的存储方式
4. 定期更新依赖包以修复安全漏洞

## 贡献

欢迎提交Issue和Pull Request来改进这个项目。

## 许可证

MIT License
