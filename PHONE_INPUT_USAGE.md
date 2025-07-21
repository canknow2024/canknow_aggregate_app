# 手机号格式化输入框组件使用说明

## 概述

`PhoneNumberInputField` 是一个专业的手机号格式化输入框组件，支持实时格式化显示为 `159 2705 1130` 的格式，提供良好的用户体验。

## 功能特点

- ✅ **实时格式化显示**: 输入时自动格式化为 `159 2705 1130` 格式
- ✅ **数字限制**: 只允许输入数字字符
- ✅ **长度限制**: 自动限制最大长度为11位
- ✅ **智能光标**: 自动调整光标位置，避免格式干扰
- ✅ **验证支持**: 支持表单验证和错误提示
- ✅ **主题适配**: 支持深色/浅色主题
- ✅ **自定义样式**: 支持自定义外观和样式

## 基本用法

```dart
import 'package:your_app/widgets/PhoneNumberInputField.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: PhoneNumberInputField(
          controller: _phoneController,
          hintText: '请输入手机号',
          onChanged: (cleanPhone) {
            print('纯数字手机号: $cleanPhone');
          },
        ),
      ),
    );
  }
}
```

## 属性说明

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `controller` | `TextEditingController?` | `null` | 文本控制器 |
| `hintText` | `String?` | `'请输入手机号'` | 提示文本 |
| `labelText` | `String?` | `null` | 标签文本 |
| `enabled` | `bool` | `true` | 是否启用 |
| `autofocus` | `bool` | `false` | 是否自动获取焦点 |
| `textInputAction` | `TextInputAction?` | `TextInputAction.next` | 键盘动作 |
| `onChanged` | `ValueChanged<String>?` | `null` | 文本变化回调（返回纯数字） |
| `validator` | `FormFieldValidator<String>?` | `null` | 验证函数 |
| `decoration` | `InputDecoration?` | `null` | 自定义装饰 |
| `style` | `TextStyle?` | `TextStyle(fontSize: 20)` | 文本样式 |
| `focusNode` | `FocusNode?` | `null` | 焦点节点 |
| `initialValue` | `String?` | `null` | 初始值 |

## 高级用法

### 1. 表单验证

```dart
PhoneNumberInputField(
  controller: _phoneController,
  validator: (value) {
    final cleanPhone = value?.replaceAll(RegExp(r'[^\d]'), '') ?? '';
    if (cleanPhone.isEmpty) {
      return '请输入手机号';
    }
    if (cleanPhone.length != 11) {
      return '请输入正确的手机号';
    }
    return null;
  },
)
```

### 2. 自定义样式

```dart
PhoneNumberInputField(
  controller: _phoneController,
  decoration: InputDecoration(
    hintText: '请输入手机号',
    prefixIcon: Icon(Icons.phone),
    border: OutlineInputBorder(),
  ),
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  ),
)
```

### 3. 获取纯数字手机号

```dart
// 方法1: 通过 onChanged 回调
PhoneNumberInputField(
  controller: _phoneController,
  onChanged: (cleanPhone) {
    // cleanPhone 是纯数字字符串
    print('手机号: $cleanPhone');
  },
)

// 方法2: 手动处理
String getCleanPhoneNumber() {
  return _phoneController.text.replaceAll(RegExp(r'[^\d]'), '');
}
```

### 4. 设置初始值

```dart
PhoneNumberInputField(
  controller: _phoneController,
  initialValue: '15927051130', // 会自动格式化为 159 2705 1130
)
```

## 在项目中的使用

### 1. 登录页面

```dart
// lib/pages/login/PhoneSmsLoginWidget.dart
PhoneNumberInputField(
  controller: _phoneController,
  hintText: '请输入手机号',
  autofocus: true,
  style: TextStyle(fontSize: 20),
)
```

### 2. 绑定手机号页面

```dart
// lib/pages/me/BindPhonePage.dart
PhoneNumberInputField(
  controller: _phoneController,
  hintText: '请输入手机号',
  autofocus: true,
  textInputAction: TextInputAction.next,
)
```

### 3. 编辑资料页面

```dart
// lib/pages/me/EditProfilePage.dart
PhoneNumberInputField(
  controller: controller,
  hintText: '请输入手机号',
  autofocus: true,
)
```

## 注意事项

1. **纯数字处理**: 组件内部会自动处理格式化，但发送到后端时需要使用纯数字格式
2. **长度验证**: 建议在提交前验证手机号长度为11位
3. **光标位置**: 组件会自动处理光标位置，避免格式化干扰用户输入
4. **主题适配**: 组件会自动适配深色/浅色主题

## 示例页面

可以查看 `lib/pages/example/PhoneInputExamplePage.dart` 来了解完整的使用示例。

## 更新日志

- **v1.0.0**: 初始版本，支持基本的手机号格式化功能
- 实时格式化显示
- 数字输入限制
- 智能光标调整
- 主题适配支持 