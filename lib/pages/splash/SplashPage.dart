import 'dart:async';
import 'package:canknow_aggregate_app/config/AppConfig.dart';
import 'package:canknow_aggregate_app/routes/appRoutes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:canknow_aggregate_app/providers/SessionStore.dart';
import 'package:canknow_aggregate_app/utils/LocalStorage.dart';
import 'package:canknow_aggregate_app/theme/AppTheme.dart';

import '../../config/ApplicationConstant.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    bool needShowAd = await _shouldShowAd();
    await Future.delayed(const Duration(milliseconds: 800)); // 品牌页短暂展示

    if (needShowAd) {
      context.go(AppRoutes.ad);
    }
    else {
      _navigateToNextPage();
    }
  }

  _shouldShowAd() {
    final today = DateTime.now();
    final lastShow = LocalStorage.getString(ApplicationConstant.adShowDateKey);

    if (lastShow.isEmpty) return true;

    try {
      final lastDate = DateTime.parse(lastShow);
      return !(lastDate.year == today.year && lastDate.month == today.month && lastDate.day == today.day);
    }
    catch (_) {
      return true;
    }
  }

  void _navigateToNextPage() async {
    try {
      if (mounted) {
        final sessionState = ref.read(sessionStore);

        if (sessionState.isLoggedIn) {
          context.go(AppRoutes.home);
        }
        else {
          context.go(AppRoutes.login);
        }
      }
    }
    catch (e) {
      if (mounted) {
        context.go(AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.white : AppTheme.backgroundColor,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo/logo/light.png',
                  width: 64,
                  height: 64,
                ),
                const SizedBox(height: 24),
                const Text(
                  AppConfig.slogan,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: const Text(
              AppConfig.copyright,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFFB0B0B0),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 