import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {
  static FToast? _fToast;
  static BuildContext? _globalContext;
  static bool _isInitialized = false;
  static final List<Map<String, dynamic>> _pendingToasts = [];

  static void init(BuildContext context) {
    _globalContext = context;
    _fToast = FToast();
    _fToast!.init(context);
    _isInitialized = true;
    
    // 显示所有待处理的 toast
    _showPendingToasts();
  }

  /// 显示待处理的 toast
  static void _showPendingToasts() {
    if (_pendingToasts.isNotEmpty) {
      for (final toastData in _pendingToasts) {
        _showToastInternal(
          toastData['message'] as String,
          backgroundColor: toastData['backgroundColor'] as Color,
          textColor: toastData['textColor'] as Color,
          icon: toastData['icon'] as IconData?,
          duration: toastData['duration'] as int,
        );
      }
      _pendingToasts.clear();
    }
  }

  /// 添加待处理的 toast
  static void _addPendingToast(
    String message, {
        Color? backgroundColor,
        Color? textColor,
        IconData? icon,
        int duration = 2,
  }) {
    _pendingToasts.add({
      'message': message,
      'backgroundColor': backgroundColor,
      'textColor': textColor,
      'icon': icon,
      'duration': duration,
    });
  }

  /// 显示成功消息
  static void showSuccess(String message) {
    _showToast(
      message,
      icon: Icons.check_circle_outline,
    );
  }

  /// 显示错误消息
  static void showError(String message) {
    _showToast(
      message,
      icon: Icons.error_outline,
    );
  }

  /// 显示警告消息
  static void showWarning(String message) {
    _showToast(
      message,
      icon: Icons.warning_amber_outlined,
    );
  }

  /// 显示信息消息
  static void showInfo(String message) {
    _showToast(
      message,
      icon: Icons.info_outline,
    );
  }

  /// 显示普通消息
  static void show(String message) {
    _showToast(
      message,
    );
  }

  /// 显示网络错误消息
  static void showNetworkError(String message) {
    _showToast(
      message,
      icon: Icons.wifi_off_outlined,
      duration: 3,
    );
  }

  /// 显示服务器错误消息
  static void showServerError(String message) {
    _showToast(
      message,
      icon: Icons.dns_outlined,
      duration: 4,
    );
  }

  /// 显示认证错误消息
  static void showAuthError(String message) {
    _showToast(
      message,
      icon: Icons.lock_outline,
      duration: 3,
    );
  }

  /// 私有方法：显示toast
  static void _showToast(
    String message, {
        Color? backgroundColor,
        Color? textColor,
        IconData? icon,
        int duration = 2,
  }) {
    // 如果还没有初始化，添加到待处理列表
    if (!_isInitialized) {
      _addPendingToast(
        message,
        backgroundColor: backgroundColor,
        textColor: textColor,
        icon: icon,
        duration: duration,
      );
      return;
    }

    _showToastInternal(
      message,
      backgroundColor: backgroundColor,
      textColor: textColor,
      icon: icon,
      duration: duration,
    );
  }

  /// 内部显示 toast 方法
  static void _showToastInternal(
    String message, {
        Color? backgroundColor,
        Color? textColor,
        IconData? icon,
        int duration = 2,
  }) {
    // 首先尝试使用默认的 Fluttertoast，它不依赖 Overlay
    try {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: 16.0,
      );
      return;
    }
    catch (e) {
      // 如果 Fluttertoast 失败，尝试使用自定义 toast
      print('Fluttertoast 失败，尝试使用自定义 toast: $e');
    }

    // 检查是否有可用的 FToast 实例
    if (_fToast != null && _globalContext != null) {
      try {
        // 使用自定义toast
        _fToast!.showToast(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: backgroundColor,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: textColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          gravity: ToastGravity.CENTER,
          toastDuration: Duration(seconds: duration),
        );
      }
      catch (e) {
        // 如果自定义 toast 也失败，打印错误信息
        print('自定义 toast 失败: $e');
        // 最后尝试使用最简单的 Fluttertoast
        try {
          Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
        }
        catch (e) {
          print('所有 toast 方法都失败: $e');
        }
      }
    }
    else {
      // 如果没有初始化，使用默认toast
      try {
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: backgroundColor,
          textColor: textColor,
          fontSize: 16.0,
        );
      }
      catch (e) {
        print('ToastUtil 未初始化，且 Fluttertoast 也失败: $e');
      }
    }
  }

  /// 取消所有toast
  static void cancel() {
    try {
      Fluttertoast.cancel();
    }
    catch (e) {
      print('取消 toast 失败: $e');
    }
  }
} 