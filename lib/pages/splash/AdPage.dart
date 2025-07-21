import 'dart:async';
import 'package:canknow_aggregate_app/routes/appRoutes.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:canknow_aggregate_app/apis/system/AdvertisementApis.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/AppConfig.dart';
import '../../providers/SessionStore.dart';
import '../../config/ApplicationConstant.dart';
import '../../utils/LocalStorage.dart';

class AdPage extends ConsumerStatefulWidget {
  const AdPage({Key? key,}) : super(key: key);

  @override
  ConsumerState<AdPage> createState() => _AdPageState();
}

class _AdPageState extends ConsumerState<AdPage> {
  String? _adImageUrl;
  int _countdown = 3;
  Timer? _timer;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  Future<void> _loadAd() async {
    try {
      final result = await AdvertisementApis.instance.find(
        clientId: AppConfig.clientId,
        scene: 'splash',
      );
      if (mounted) {
        setState(() {
          _adImageUrl = result['cover'];
          _loading = false;
        });
        _startCountdown();
      }
    }
    catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
        });
        _startCountdown();
      }
    }
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown <= 1) {
        _timer?.cancel();
        _navigateToNextPage();
      }
      else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  void _skip() {
    _timer?.cancel();
    _navigateToNextPage();
  }

  void _navigateToNextPage() async {
    try {
      // 设置今日已显示广告的缓存
      final today = DateTime.now();
      LocalStorage.setString(ApplicationConstant.adShowDateKey, today.toIso8601String());
      
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
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _loading
              ? Container(color: Colors.grey[200])
              : (_adImageUrl != null && _adImageUrl!.isNotEmpty)
                  ? CachedNetworkImage(
                      imageUrl: _adImageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: Colors.grey[200]),
                      errorWidget: (context, url, error) => Container(color: Colors.grey[200]),
                    )
                  : Container(color: Colors.grey[200]),
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: GestureDetector(
              onTap: _skip,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '跳过 ${_countdown}s',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 