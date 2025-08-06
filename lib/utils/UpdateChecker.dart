import 'dart:io';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../apis/system/AppVersionApis.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../config/AppConfig.dart';
import '../plugins/InstallApkPlugin.dart';
import 'ToastUtil.dart';

class UpdateChecker {
  static bool _checking = false;

  static Future<void> checkUpdate(BuildContext context, {bool showNoUpdateToast = false}) async {
    if (kIsWeb) return;

    if (_checking) return;

    _checking = true;

    try {
      final info = await PackageInfo.fromPlatform();
      final currentVersion = info.version;
      final platform = Platform.isAndroid ? 'android' : (Platform.isIOS ? 'ios' : 'other');
      final result = await AppVersionApis.instance.getLatest(clientId: AppConfig.clientId, platform: platform);
      final latestVersion = result['version'] ?? '';
      final forceUpdate = result['forceUpdate'] ?? false;
      final downloadUrl = result['downloadUrl'] ?? '';
      final changeLogs = result['changeLogs'] ?? '';

      if (_isNewerVersion(latestVersion, currentVersion) && downloadUrl.isNotEmpty) {
        _showUpdateDialog(context, latestVersion, changeLogs, forceUpdate, downloadUrl);
      }
      else if (showNoUpdateToast) {
        ToastUtil.showSuccess('当前已是最新版本');
      }
    }
    catch (e) {
      print('检查更新失败: $e');
    }
    finally {
      _checking = false;
    }
  }

  static bool _isNewerVersion(String latest, String current) {
    List<int> l = latest.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    List<int> c = current.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    for (int i = 0; i < l.length; i++) {
      if (i >= c.length || l[i] > c[i]) return true;
      if (l[i] < c[i]) return false;
    }
    return false;
  }

  static void _showUpdateDialog(BuildContext context, String version, String changeLogs, bool force, String url) {
    showDialog(
      context: context,
      barrierDismissible: !force,
      builder: (context) {
        return _UpdateDialog(
          version: version,
          changeLogs: changeLogs,
          force: force,
          url: url,
        );
      },
    );
  }
}

class _UpdateDialog extends StatefulWidget {
  final String version;
  final String changeLogs;
  final bool force;
  final String url;
  const _UpdateDialog({required this.version, required this.changeLogs, required this.force, required this.url});
  @override
  State<_UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<_UpdateDialog> {
  bool _downloading = false;
  int _progress = 0;
  String? _error;
  String? _downloadedFilePath;

  void _startDownload() async {
    setState(() {
      _downloading = true;
      _progress = 0;
      _error = null;
      _downloadedFilePath = null;
    });

    try {
      // 获取下载目录
      String savePath;

      if (Platform.isAndroid) {
        final directory = await getExternalStorageDirectory();
        if (directory != null) {
          savePath = directory.path;
        }
        else {
          // 备用方案：使用应用文档目录
          final appDir = await getApplicationDocumentsDirectory();
          savePath = appDir.path;
        }
      }
      else {
        final appDir = await getApplicationDocumentsDirectory();
        savePath = appDir.path;
      }

      final fileName = 'app_update_${widget.version}.apk';
      final filePath = '$savePath/$fileName';

      print('下载路径: $filePath');
      print('下载URL: ${widget.url}');

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

      print('下载完成: $filePath');
      setState(() {
        _downloading = false;
        _downloadedFilePath = filePath;
      });
      
      // 下载完成后自动安装
      await _installApk(filePath);
      
    }
    catch (e) {
      print('开始下载失败: $e');
      setState(() {
        _downloading = false;
        _error = '下载启动失败: $e';
      });
    }
  }

  Future<void> _installApk(String filePath) async {
    try {
      print('开始安装APK: $filePath');
      
      // 检查文件是否存在
      final file = File(filePath);
      if (!await file.exists()) {
        ToastUtil.showError('APK文件不存在');
        return;
      }

      // 调用安装插件
      final success = await InstallApkPlugin.installApk(filePath);
      
      if (success) {
        print('APK安装启动成功');
        ToastUtil.showSuccess('正在安装新版本...');
        // 关闭对话框
        Navigator.of(context).pop();
      }
      else {
        print('APK安装启动失败');
        ToastUtil.showError('安装启动失败，请手动安装');
        // 显示手动安装提示
        _showManualInstallDialog(filePath);
      }
    }
    catch (e) {
      print('安装APK异常: $e');
      ToastUtil.showError('安装失败: $e');
      _showManualInstallDialog(filePath);
    }
  }

  void _showManualInstallDialog(String filePath) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('安装提示'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('自动安装失败，请手动安装：'),
            const SizedBox(height: 8),
            Text('文件路径: $filePath', style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 8),
            const Text('请前往文件管理器找到此文件并手动安装。'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !widget.force,
      child: AlertDialog(
        title: Text('发现新版本 v${widget.version}'),
        content: _downloading ? Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LinearProgressIndicator(
              value: _progress / 100,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            SizedBox(height: 12),
            Text('下载中... $_progress%', style: TextStyle(fontSize: 16)),
            if (_error != null) ...[
              SizedBox(height: 8),
              Text(_error!, style: TextStyle(color: Colors.red)),
            ]
          ],
        ) : Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.changeLogs.isNotEmpty) ...[
              Text('更新内容：'),
              SizedBox(height: 4),
              Text(widget.changeLogs, style: TextStyle(fontSize: 14)),
              SizedBox(height: 12),
            ],
            Text(widget.force ? '本次更新为强制更新，必须升级后才能继续使用。' : '检测到新版本，是否立即更新？'),
          ],
        ),
        actions: _downloading ? null : <Widget>[
          if (!widget.force)
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('以后再说'),
            ),
          TextButton(
            onPressed: _startDownload,
            child: Text('立即更新'),
          ),
        ],
      ),
    );
  }
}