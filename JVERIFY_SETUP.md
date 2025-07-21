# 极光手机号一键登录配置说明

## 1. 极光平台配置

### 1.1 注册极光开发者账号
1. 访问 [极光官网](https://www.jiguang.cn/)
2. 注册开发者账号并登录

### 1.2 创建应用
1. 在极光控制台创建新应用
2. 获取应用的 AppKey 和 AppSecret

### 1.3 配置一键登录
1. 在应用配置中启用"一键登录"功能
2. 配置运营商参数（移动、联通、电信）
3. 获取各运营商的 AppId 和 AppKey

## 2. Android 配置

### 2.1 添加权限
在 `android/app/src/main/AndroidManifest.xml` 中添加以下权限：

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
<uses-permission android:name="android.permission.READ_PHONE_STATE" />
<uses-permission android:name="android.permission.CHANGE_NETWORK_STATE" />
<uses-permission android:name="android.permission.WRITE_SETTINGS" />
```

### 2.2 初始化配置
在 `android/app/src/main/kotlin/com/canknow/canknow_aggregate_app/MainActivity.kt` 中添加初始化代码：

```kotlin
import cn.jpush.verify.JVerify
import cn.jpush.verify.JVerifyConfig

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // 初始化极光一键登录
        JVerify.setDebugMode(true) // 开发环境设置为true，生产环境设置为false
        
        val config = JVerifyConfig.Builder()
            .setAppKey("your_app_key") // 替换为您的AppKey
            .setChannel("your_channel") // 替换为您的渠道名
            .setAdvertisingId("your_advertising_id") // 可选，广告标识符
            .setIsProduction(false) // 开发环境设置为false，生产环境设置为true
            .build()
            
        JVerify.init(this, config)
    }
}
```

## 3. iOS 配置

### 3.1 添加权限
在 `ios/Runner/Info.plist` 中添加以下权限：

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

### 3.2 初始化配置
在 `ios/Runner/AppDelegate.swift` 中添加初始化代码：

```swift
import UIKit
import Flutter
import JVerify

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // 初始化极光一键登录
        JVerify.setDebugMode(true) // 开发环境设置为true，生产环境设置为false
        
        let config = JVerifyConfig()
        config.appKey = "your_app_key" // 替换为您的AppKey
        config.channel = "your_channel" // 替换为您的渠道名
        config.advertisingId = "your_advertising_id" // 可选，广告标识符
        config.isProduction = false // 开发环境设置为false，生产环境设置为true
        
        JVerify.init(config)
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
```

## 4. 后端接口配置

### 4.1 新增一键登录接口
在后端添加新的授权接口，支持 `grant_type: 'oneClickLogin'`：

```json
{
  "grant_type": "oneClickLogin",
  "client_id": "your_client_id",
  "client_secret": "your_client_secret",
  "login_token": "jverify_login_token"
}
```

### 4.2 验证登录Token
后端需要调用极光API验证登录Token的有效性：

```bash
POST https://api.verification.jpush.cn/v1/web/loginTokenVerify
Content-Type: application/json

{
  "loginToken": "jverify_login_token",
  "exID": "your_ex_id" // 可选，扩展字段
}
```

## 5. 测试

### 5.1 开发环境测试
1. 确保设备有SIM卡
2. 开启移动数据网络
3. 运行应用测试一键登录功能

### 5.2 生产环境部署
1. 将 `isProduction` 设置为 `true`
2. 将 `setDebugMode` 设置为 `false`
3. 使用正式环境的AppKey和配置

## 6. 注意事项

1. **网络要求**：一键登录需要移动数据网络，WiFi环境下可能无法使用
2. **运营商支持**：目前支持中国移动、中国联通、中国电信
3. **设备要求**：需要Android 4.4+或iOS 9.0+
4. **SIM卡要求**：设备必须插入有效的SIM卡
5. **权限要求**：需要读取手机状态权限

## 7. 错误码说明

常见错误码：
- 6000: 成功
- 6001: 用户取消登录
- 6002: 网络异常
- 6003: 未开启数据流量
- 6004: 获取token失败
- 6005: 预取号失败
- 6006-6050: 运营商维护升级

详细错误码请参考极光官方文档。 