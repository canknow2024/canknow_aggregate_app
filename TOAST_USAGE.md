# Toast 消息提示功能使用说明

## 概述

本项目集成了 `fluttertoast` 包，提供了统一的 Toast 消息提示功能，并在 `HttpService` 中集成了错误拦截和自动显示错误消息的功能。

## 功能特性

### 1. ToastUtil 工具类

提供了多种类型的 Toast 消息：

- **成功消息**: `ToastUtil.showSuccess(message)`
- **错误消息**: `ToastUtil.showError(message)`
- **警告消息**: `ToastUtil.showWarning(message)`
- **信息消息**: `ToastUtil.showInfo(message)`
- **网络错误**: `ToastUtil.showNetworkError(message)`
- **服务器错误**: `ToastUtil.showServerError(message)`
- **认证错误**: `ToastUtil.showAuthError(message)`
- **普通消息**: `ToastUtil.show(message)`

### 2. HttpService 错误拦截

`HttpService` 现在会自动拦截各种网络错误并显示相应的 Toast 消息：

#### HTTP 状态码错误处理
- **400**: 请求参数错误
- **401**: 登录已过期，自动清除token并显示认证错误
- **403**: 没有权限访问
- **404**: 请求的资源不存在
- **405**: 请求方法不允许
- **408**: 请求超时
- **429**: 请求过于频繁
- **500**: 服务器内部错误
- **502**: 网关错误
- **503**: 服务暂时不可用
- **504**: 网关超时

#### 网络连接错误处理
- **连接超时**: 网络超时，请检查网络连接
- **发送超时**: 网络超时，请检查网络连接
- **接收超时**: 网络超时，请检查网络连接
- **连接错误**: 网络连接错误，请检查网络设置
- **请求取消**: 请求被取消
- **证书错误**: 证书验证失败
- **未知错误**: 未知网络错误

## 使用方法

### 1. 基本使用

```dart
import 'package:canknow_aggregate_app/utils/ToastUtil.dart';

// 显示成功消息
ToastUtil.showSuccess('操作成功！');

// 显示错误消息
ToastUtil.showError('操作失败！');

// 显示警告消息
ToastUtil.showWarning('警告信息！');

// 显示信息消息
ToastUtil.showInfo('提示信息！');
```

### 2. 在 HttpService 中的自动处理

```dart
import 'package:canknow_aggregate_app/services/HttpService.dart';

// 发起网络请求，错误会自动被拦截并显示Toast
try {
  final result = await HttpService.instance.get('/api/data');
  // 处理成功响应
} catch (e) {
  // 错误已经被HttpService自动处理并显示Toast
  // 这里可以添加额外的错误处理逻辑
}
```

### 3. 自定义错误处理

```dart
// 如果需要自定义错误处理，可以在catch块中调用ToastUtil
try {
  final result = await HttpService.instance.post('/api/submit', data: formData);
  ToastUtil.showSuccess('提交成功！');
} catch (e) {
  // HttpService已经显示了错误Toast，这里可以添加额外处理
  print('自定义错误处理: $e');
}
```

## 初始化

ToastUtil 会在应用启动时自动初始化，无需手动调用。

## 图标说明

所有 Toast 消息都使用了 Material Design 图标：

- ✅ 成功: `Icons.check_circle_outline`
- ❌ 错误: `Icons.error_outline`
- ⚠️ 警告: `Icons.warning_amber_outlined`
- ℹ️ 信息: `Icons.info_outline`
- 📶 网络: `Icons.wifi_off_outlined`
- 🌐 服务器: `Icons.dns_outlined`
- 🔒 认证: `Icons.lock_outline`

## 测试

可以运行 `ToastTestPage` 来测试各种 Toast 消息效果：

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const ToastTestPage()),
);
```

## 注意事项

1. Toast 消息会在屏幕中央显示，持续2-4秒（根据消息类型）
2. 网络错误会自动显示，无需手动处理
3. 401错误会自动清除用户token并显示认证错误消息
4. 服务器错误（5xx）会显示更长时间（4秒）
5. 可以使用 `ToastUtil.cancel()` 取消所有正在显示的Toast 

## 问题描述

在 Flutter 应用中，当在 `HttpService` 拦截器中调用 `ToastUtil.showAuthError()` 等方法时，可能会出现以下错误：

```
DartError: Error: Overlay is null. 
Please don't use top of the widget tree context (such as Navigator or MaterialApp) or 
create overlay manually in MaterialApp builder.
```

## 错误原因

这个错误通常发生在以下情况：

1. `HttpService` 是单例模式，在应用启动时就被初始化
2. 拦截器中的 Toast 调用可能在 `ToastUtil.init()` 被调用之前执行
3. 即使 `ToastUtil.init()` 被调用了，在拦截器中调用时可能没有正确的 BuildContext

## 解决方案

### 1. 改进的 ToastUtil 类

我们改进了 `ToastUtil` 类，添加了以下功能：

- **初始化状态跟踪**：使用 `_isInitialized` 标志跟踪是否已初始化
- **待处理队列**：使用 `_pendingToasts` 列表存储未初始化时的 Toast 请求
- **安全显示机制**：在 `init()` 方法中显示所有待处理的 Toast
- **错误处理**：添加了 try-catch 块来处理各种异常情况

### 2. 关键改进点

#### 初始化检查
```dart
static void _showToast(String message, ...) {
  // 如果还没有初始化，添加到待处理列表
  if (!_isInitialized) {
    _addPendingToast(message, ...);
    return;
  }
  
  _showToastInternal(message, ...);
}
```

#### 待处理队列
```dart
static final List<Map<String, dynamic>> _pendingToasts = [];

static void _addPendingToast(String message, ...) {
  _pendingToasts.add({
    'message': message,
    'backgroundColor': backgroundColor,
    'textColor': textColor,
    'icon': icon,
    'duration': duration,
  });
}
```

#### 初始化时显示待处理 Toast
```dart
static void init(BuildContext context) {
  _globalContext = context;
  _fToast = FToast();
  _fToast!.init(context);
  _isInitialized = true;
  
  // 显示所有待处理的 toast
  _showPendingToasts();
}
```

### 3. 使用方式

#### 在应用初始化时
在 `app.dart` 的 `MaterialApp.router` 的 `builder` 中初始化：

```dart
builder: (context, child) {
  // 初始化ToastUtil
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ToastUtil.init(context);
  });
  return child!;
},
```

#### 在任何地方调用
现在可以在任何地方安全地调用 Toast 方法：

```dart
// 在 HttpService 拦截器中
ToastUtil.showAuthError('认证失败');

// 在页面中
ToastUtil.showSuccess('操作成功');

// 在网络错误处理中
ToastUtil.showNetworkError('网络连接失败');
```

### 4. 错误处理

如果 Toast 显示失败，系统会：

1. 首先尝试使用 `Fluttertoast.showToast()`
2. 如果失败，尝试使用自定义的 `FToast`
3. 如果都失败，打印错误信息但不会崩溃应用

### 5. 优势

- **安全性**：不会因为 Overlay 为空而崩溃
- **可靠性**：确保所有 Toast 都能正确显示
- **灵活性**：支持在应用初始化前调用 Toast
- **兼容性**：向后兼容现有的 Toast 调用方式

## 注意事项

1. 确保在 `MaterialApp` 的 `builder` 中调用 `ToastUtil.init(context)`
2. Toast 调用是异步的，不会阻塞主线程
3. 如果应用初始化失败，Toast 会使用默认的 `Fluttertoast` 显示
4. 所有 Toast 调用都是安全的，不会导致应用崩溃 