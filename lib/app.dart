import 'package:canknow_aggregate_app/providers/SessionStore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'theme/AppTheme.dart';
import 'providers/ThemeStore.dart';
import 'routes/appRoutes.dart';
import 'utils/ToastUtil.dart';

class MyApp extends ConsumerStatefulWidget {
  final Locale? locale;
  const MyApp({Key? key, this.locale}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late GoRouter _router;

  @override
  void initState() {
    super.initState();
    _createRouter();
  }

  void _createRouter() {
    _router = GoRouter(
      initialLocation: AppRoutes.splash,
      routes: AppRoutes.getRoutes(),
      redirect: (context, state) {
        final sessionState = ref.read(sessionStore);
        final isLoggedIn = sessionState.isLoggedIn;
        final currentPath = state.uri.toString();
        
        // 如果正在加载，不进行重定向
        if (sessionState.isLoading) return null;
        
        // 如果未登录且访问需要登录的页面，重定向到登录页
        if (!isLoggedIn && !AppRoutes.isPublicRoute(currentPath)) {
          return AppRoutes.login;
        }
        
        // 如果已登录且访问登录页，重定向到主页
        if (isLoggedIn && AppRoutes.isLoginRoute(currentPath)) {
          return AppRoutes.home;
        }
        
        return null;
      },
    );
  }

  @override
  void dispose() {
    // 在这里可以添加清理逻辑
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeStore);
    
    return MaterialApp.router(
      title: '蜗牛打卡',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: widget.locale ?? context.locale,
      routerConfig: _router,
      builder: (context, child) {
        // 初始化ToastUtil
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ToastUtil.init(context);
        });
        return child!;
      },
    );
  }
} 