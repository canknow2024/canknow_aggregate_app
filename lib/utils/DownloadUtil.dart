import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class DownloadUtil {
  // 语音下载
  static downloadVoice(String downUrl, String fileName, {VoidCallback? callback}) async {
    FlutterDownloader.registerCallback((id, status, progress) {
      print('Download task ($id) is in status ($status) and process ($progress)');

      if (status == DownloadTaskStatus.complete && callback != null) {
        callback();
      }
    });
    final taskId = await FlutterDownloader.enqueue(
      url: downUrl,
      savedDir: await savePath,
      fileName: fileName,
      showNotification: false,
      // show download progress in status bar (for Android)
      openFileFromNotification: false, // click on notification to open downloaded file (for Android)
    );
    final tasks = await FlutterDownloader.loadTasks();
  }

  // 简单的HTTP下载（用于测试）
  static Future<bool> simpleDownload(
    String url,
    String fileName, {
    Function(int progress)? onProgress,
    Function()? onComplete,
    Function(String error)? onError,
  }) async {
    try {
      final dio = Dio();
      final savePath = await _getDownloadPath();
      final filePath = '$savePath/$fileName';
      
      print('开始简单下载: $url');
      print('保存路径: $filePath');

      await dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = (received / total * 100).round();
            print('下载进度: $progress%');
            if (onProgress != null) {
              onProgress(progress);
            }
          }
        },
      );

      print('下载完成: $filePath');
      if (onComplete != null) {
        onComplete();
      }
      return true;
    }
    catch (e) {
      print('简单下载失败: $e');
      if (onError != null) {
        onError('下载失败: $e');
      }
      return false;
    }
  }

  // 获取下载路径
  static Future<String> _getDownloadPath() async {
    if (Platform.isAndroid) {
      try {
        final directory = await getExternalStorageDirectory();
        if (directory != null) {
          return directory.path;
        }
      } catch (e) {
        print('获取外部存储目录失败: $e');
      }
      
      // 备用方案：使用应用文档目录
      final appDir = await getApplicationDocumentsDirectory();
      return appDir.path;
    }
    else {
      final appDir = await getApplicationDocumentsDirectory();
      return appDir.path;
    }
  }

  static Future<String> get savePath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // 取消下载
  static Future<void> cancelDownload(String taskId) async {
    try {
      await FlutterDownloader.cancel(taskId: taskId);
      print('已取消下载任务: $taskId');
    }
    catch (e) {
      print('取消下载失败: $e');
    }
  }

  // 获取下载任务状态
  static Future<List<DownloadTask>?> getDownloadTasks() async {
    try {
      return await FlutterDownloader.loadTasks();
    }
    catch (e) {
      print('获取下载任务失败: $e');
      return null;
    }
  }

  // 检查文件是否存在
  static Future<bool> fileExists(String filePath) async {
    try {
      final file = File(filePath);
      return await file.exists();
    }
    catch (e) {
      print('检查文件存在失败: $e');
      return false;
    }
  }

  // 获取文件大小
  static Future<int> getFileSize(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        return await file.length();
      }
      return 0;
    }
    catch (e) {
      print('获取文件大小失败: $e');
      return 0;
    }
  }
}
