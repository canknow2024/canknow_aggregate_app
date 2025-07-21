import 'package:canknow_aggregate_app/providers/SessionStore.dart';
import 'package:canknow_aggregate_app/utils/ToastUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/AppConfig.dart';
import '../../utils/TextUtil.dart';
import '../../utils/WechatUtil.dart';
import '../../apis/authorization/AuthorizationApis.dart';
import '../../services/TokenServices.dart';
import '../../routes/appRoutes.dart';

class WechatLoginWidget extends ConsumerStatefulWidget {
  final bool agree;
  final showAgreeDialog;

  const WechatLoginWidget({super.key, required this.agree, required this.showAgreeDialog});

  @override
  ConsumerState<WechatLoginWidget> createState() => _WechatLoginWidgetState();
}

class _WechatLoginWidgetState extends ConsumerState<WechatLoginWidget> {
  bool _wechatLoading = false;

  _handleWechatLogin() async {
    if (!widget.agree) {
      widget.showAgreeDialog(context, pendingAction: () {
        _handleWechatLogin();
      });
      return;
    }

    if (_wechatLoading) {
      return;
    }

    setState(() {
      _wechatLoading = true;
    });

    try {
      final code = await WechatUtil.authorize();
      final data = {
        'code': code,
        'grant_type': 'wechatApp',
        'client_id': AppConfig.clientId,
        'client_secret': AppConfig.clientSecret,
      };
      final result = await AuthorizationApis().token(data);

      TokenServices.setToken(result['access_token']);
      await ref.read(sessionStore.notifier).getCurrentLoginInformation();

      final sessionState = ref.read(sessionStore);
      final userInfo = sessionState.userInfo;

      if (TextUtil.isEmpty(userInfo!['phoneNumber'])) {
        GoRouter.of(context).replace(AppRoutes.bindPhone);
      }
      else if (userInfo!['userDataInitialized'] == true) {
        GoRouter.of(context).replace(AppRoutes.home);
      }
      else {
        GoRouter.of(context).replace(AppRoutes.interestSetting);
      }
    }
    catch (e) {
      ToastUtil.showError('微信登录失败');
      print('微信登录失败: $e');
    }
    finally {
      if (mounted) {
        setState(() {
          _wechatLoading = false;
        });
      }
    }
  }

  Future<void> _login() async {

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleWechatLogin,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: _wechatLoading ? Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ),
        ) : Icon(
          Icons.wechat,
          color: Colors.green,
          size: 32,
        ),
      ),
    );
  }
}