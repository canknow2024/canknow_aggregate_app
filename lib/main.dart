import 'dart:io';

import 'package:canknow_aggregate_app/plugins/JVerifyPlugin.dart';
import 'package:canknow_aggregate_app/utils/WechatUtil.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'app.dart';
import 'local/localeUtil.dart';
import 'providers/LocaleStore.dart';
import 'utils/LocalStorage.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await FlutterDownloader.initialize(debug: true);
  }
  
  try {
    // 初始化本地存储
    await LocalStorage.getInstance();
    // 初始化国际化
    await EasyLocalization.ensureInitialized();

    if (!kIsWeb) {
      WechatUtil.initialize();
      
      // 初始化jverify插件
      try {
        JverifyPlugin.initialize();
      }
      catch (e) {
        print('JVerify初始化失败: $e');
      }
    }

    GoRouter.optionURLReflectsImperativeAPIs = true;

    runApp(
      ProviderScope(
        child: EasyLocalization(
          supportedLocales: localeUtil.supportedLanguages,
          path: 'assets/translations',
          fallbackLocale: localeUtil.defaultLocale(),
          child: Consumer(builder: (context, ref, _) {
            final locale = ref.watch(localeStore);
            return MyApp(locale: locale);
          }),
        ),
      ),
    );
  }
  catch (e) {
    print('应用初始化错误: $e');
    // 即使初始化失败，也要启动应用
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('应用初始化失败: $e'),
          ),
        ),
      ),
    );
  }
}