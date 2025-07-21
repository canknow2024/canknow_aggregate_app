# 微信登录功能配置说明

## 概述

本项目已集成微信登录功能，包括登录、分享等功能。以下是详细的配置和使用说明。

## 1. 微信开放平台配置

### 1.1 注册微信开放平台账号
1. 访问 [微信开放平台](https://open.weixin.qq.com/)
2. 注册开发者账号
3. 创建移动应用

### 1.2 获取应用信息
在微信开放平台获取以下信息：
- **AppID**: 应用的唯一标识
- **AppSecret**: 应用密钥
- **Universal Link**: iOS通用链接（iOS应用需要）

## 2. 项目配置

### 2.1 更新配置文件
编辑 `lib/config/WechatConfig.dart` 文件，填入您的微信应用信息：

```dart
class WechatConfig {
  // 微信开放平台应用ID
  static const String appId = 'your_wechat_app_id'; // 替换为您的微信AppID
  
  // iOS通用链接
  static const String universalLink = 'your_universal_link'; // 替换为您的通用链接
  
  // 微信开放平台应用密钥
  static const String appSecret = 'your_wechat_app_secret'; // 替换为您的微信AppSecret
  
  // 其他配置...
}
```

### 2.2 Android 配置

#### 2.2.1 添加权限
在 `android/app/src/main/AndroidManifest.xml` 中添加权限：

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

#### 2.2.2 配置包名和签名
确保您的应用包名和签名与微信开放平台注册的一致。

### 2.3 iOS 配置

#### 2.3.1 配置 URL Schemes
在 `ios/Runner/Info.plist` 中添加：

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>weixin</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>wx${YOUR_APP_ID}</string>
        </array>
    </dict>
</array>
```

#### 2.3.2 配置 Universal Links
在 `ios/Runner/Info.plist` 中添加：

```xml
<key>com.apple.developer.associated-domains</key>
<array>
    <string>applinks:your-universal-link-domain.com</string>
</array>
```

## 3. 依赖安装

运行以下命令安装依赖：

```bash
flutter pub get
```

## 4. 使用方法

### 4.1 基本使用

在登录页面中，微信登录按钮已经集成：

```dart
import 'package:canknow_aggregate_app/widgets/WechatLoginButton.dart';

WechatLoginButton(
  size: 60,
  onSuccess: () {
    // 登录成功后的回调
  },
  onError: () {
    // 登录失败后的回调
  },
)
```

### 4.2 自定义使用

```dart
import 'package:canknow_aggregate_app/services/WechatLoginService.dart';

// 微信登录
try {
  final result = await WechatLoginService.login();
  // 处理登录结果
} catch (e) {
  // 处理错误
}

// 微信分享
try {
  final success = await WechatLoginService.shareToWechat(
    title: '分享标题',
    description: '分享描述',
    url: 'https://example.com',
    imageUrl: 'https://example.com/image.jpg',
  );
  // 处理分享结果
} catch (e) {
  // 处理错误
}
```

## 5. API 接口

### 5.1 微信登录接口
- **URL**: `/api/authorization/interface/oauth2/wechat/token`
- **Method**: POST
- **参数**:
  ```json
  {
    "code": "微信授权码",
    "grant_type": "wechat",
    "client_id": "应用ID",
    "client_secret": "应用密钥"
  }
  ```

### 5.2 微信绑定接口
- **URL**: `/api/authorization/interface/oauth2/wechat/bind`
- **Method**: POST
- **参数**:
  ```json
  {
    "code": "微信授权码",
    "grant_type": "wechat_bind",
    "client_id": "应用ID",
    "client_secret": "应用密钥"
  }
  ```

## 6. 错误处理

### 6.1 常见错误
- **微信未安装**: 提示用户安装微信应用
- **授权失败**: 检查微信开放平台配置
- **网络错误**: 检查网络连接
- **配置错误**: 检查 WechatConfig 配置

### 6.2 错误码说明
- `-1`: 微信未安装
- `-2`: 用户取消授权
- `-3`: 授权失败
- `-4`: 网络错误
- `-5`: 配置错误

## 7. 测试

### 7.1 真机测试
微信登录功能需要在真机上测试，模拟器无法使用微信SDK。

### 7.2 测试步骤
1. 确保微信应用已安装
2. 确保网络连接正常
3. 点击微信登录按钮
4. 在微信中完成授权
5. 检查登录结果

## 8. 注意事项

1. **包名一致性**: 确保应用包名与微信开放平台注册的一致
2. **签名一致性**: Android应用签名必须与微信开放平台注册的一致
3. **网络权限**: 确保应用有网络访问权限
4. **真机测试**: 必须在真机上测试，模拟器不支持
5. **配置检查**: 部署前检查所有配置是否正确

## 9. 故障排除

### 9.1 登录失败
1. 检查微信开放平台配置
2. 检查应用包名和签名
3. 检查网络连接
4. 查看错误日志

### 9.2 分享失败
1. 检查微信是否安装
2. 检查分享内容格式
3. 检查网络连接

### 9.3 配置问题
1. 检查 WechatConfig 配置
2. 检查 Android/iOS 配置文件
3. 重新安装依赖

## 10. 更新日志

- v1.0.0: 初始版本，支持微信登录和分享功能
- v1.1.0: 添加错误处理和配置检查
- v1.2.0: 优化UI组件和用户体验

## 11. 技术支持

如有问题，请参考：
- [微信开放平台文档](https://developers.weixin.qq.com/doc/)
- [Flutter 微信SDK文档](https://pub.dev/packages/fluwx)
- 项目 Issues 页面 