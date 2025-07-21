# Android应用更新下载进度条问题解决方案

## 问题描述
Android应用在检查到更新时，下载进度条没有反应，无法显示下载进度。

## 问题原因分析

1. **MaterialLocalizations错误**：在应用初始化时调用UpdateChecker时缺少MaterialApp上下文
2. **Dart VM错误**：`_UpdateDialogState`类需要添加`@pragma('vm:entry-point')`注解
3. **Isolate通信问题**：FlutterDownloader的Isolate通信机制复杂且容易出错
4. **权限问题**：Android 10+ 需要额外的权限来访问外部存储

## 解决方案

### 1. 修复应用初始化问题

在 `lib/main.dart` 中移除在应用初始化时调用UpdateChecker的代码：

```dart
// 移除这段代码
child: Builder(
  builder: (context) {
    if (!kIsWeb) {
      UpdateChecker.checkUpdate(context); // 这行导致MaterialLocalizations错误
    }
    return Consumer(builder: (context, ref, _) {
      final locale = ref.watch(localeStore);
      return MyApp(locale: locale);
    });
  },
),
```

改为：

```dart
child: Consumer(builder: (context, ref, _) {
  final locale = ref.watch(localeStore);
  return MyApp(locale: locale);
}),
```

### 2. 使用Dio替代FlutterDownloader

由于FlutterDownloader的Isolate通信机制复杂，我们改用Dio进行下载，这样可以：

- 避免Isolate通信问题
- 简化代码逻辑
- 提供更好的错误处理
- 确保进度条正常更新

### 3. 更新Android权限配置

在 `android/app/src/main/AndroidManifest.xml` 中添加必要的权限：

```xml
<!-- 下载相关权限 -->
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />

<!-- Android 10+ 权限 -->
<uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE" />
```

在 `<application>` 标签中添加：

```xml
android:requestLegacyExternalStorage="true"
```

### 4. 简化的UpdateChecker实现

新的UpdateChecker使用Dio进行下载：

```dart
void _startDownload() async {
  setState(() {
    _downloading = true;
    _progress = 0;
    _error = null;
  });

  try {
    // 获取下载目录
    String savePath = await _getDownloadPath();
    final fileName = 'app_update_${widget.version}.apk';
    final filePath = '$savePath/$fileName';

    final dio = Dio();
    await dio.download(
      widget.url,
      filePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          final progress = (received / total * 100).round();
          setState(() {
            _progress = progress;
          });
        }
      },
    );

    // 下载完成后关闭对话框
    Navigator.of(context).pop();
  } catch (e) {
    setState(() {
      _downloading = false;
      _error = '下载启动失败: $e';
    });
  }
}
```

### 5. 测试功能

在设置页面添加了"测试下载功能"选项，使用简单的HTTP下载进行测试。

## 使用说明

### 测试下载功能

1. 进入应用设置页面
2. 点击"测试下载功能"
3. 点击"开始测试"按钮
4. 观察下载进度条是否正常显示

### 检查日志

在调试模式下，查看控制台输出：

```
开始下载APK: [URL]
保存路径: [路径]
下载进度: [进度]%
下载完成: [文件路径]
```

## 常见问题排查

### 1. 进度条不更新

- 检查网络连接
- 确认下载URL是否有效
- 查看控制台是否有错误日志

### 2. 下载失败

- 检查网络权限
- 确认存储权限
- 验证下载URL是否有效

### 3. 存储路径问题

- 检查 `getExternalStorageDirectory()` 返回值
- 使用备用路径方案
- 确认应用有写入权限

## 代码示例

### 基本使用

```dart
final dio = Dio();
await dio.download(
  'https://example.com/app.apk',
  '/path/to/save/app.apk',
  onReceiveProgress: (received, total) {
    if (total != -1) {
      final progress = (received / total * 100).round();
      print('下载进度: $progress%');
    }
  },
);
```

### 在UpdateChecker中使用

```dart
void _startDownload() async {
  setState(() {
    _downloading = true;
    _progress = 0;
  });

  try {
    final dio = Dio();
    await dio.download(
      widget.url,
      filePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          final progress = (received / total * 100).round();
          setState(() {
            _progress = progress;
          });
        }
      },
    );
    
    setState(() {
      _downloading = false;
    });
  } catch (e) {
    setState(() {
      _downloading = false;
      _error = '下载失败: $e';
    });
  }
}
```

## 优势

1. **简单可靠**：使用Dio替代FlutterDownloader，避免复杂的Isolate通信
2. **进度准确**：直接在主线程更新进度，确保UI响应
3. **错误处理**：更好的异常捕获和处理
4. **调试友好**：清晰的日志输出，便于问题排查

## 注意事项

1. **权限申请**：确保在运行时申请必要的权限
2. **网络检查**：下载前检查网络连接状态
3. **存储空间**：确保设备有足够的存储空间
4. **错误处理**：提供用户友好的错误提示
5. **后台下载**：Dio下载不支持后台下载，应用退出后下载会中断

## 相关文件

- `lib/utils/UpdateChecker.dart` - 更新检查器（使用Dio）
- `lib/utils/DownloadUtil.dart` - 下载工具类（包含简单下载方法）
- `android/app/src/main/AndroidManifest.xml` - Android权限配置
- `lib/pages/setting/SettingsPage.dart` - 设置页面（包含测试功能）
- `lib/main.dart` - 应用入口（移除初始化时的更新检查） 