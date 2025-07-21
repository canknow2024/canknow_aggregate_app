import 'package:canknow_aggregate_app/services/TokenServices.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../apis/authorization/AuthorizationApis.dart';
import '../../config/AppConfig.dart';
import '../../plugins/JVerifyPlugin.dart';
import '../../providers/SessionStore.dart';
import '../../routes/appRoutes.dart';
import '../../utils/ToastUtil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

class PhoneOneClickLoginWidget extends ConsumerStatefulWidget {
  final bool agree;
  final showAgreeDialog;
  final VoidCallback onSwitchToSmsLogin;
  const PhoneOneClickLoginWidget({Key? key, required this.agree, required this.showAgreeDialog, required this.onSwitchToSmsLogin}) : super(key: key);

  @override
  ConsumerState<PhoneOneClickLoginWidget> createState() => _PhoneOneClickLoginWidgetState();
}

class _PhoneOneClickLoginWidgetState extends ConsumerState<PhoneOneClickLoginWidget> {
  bool _loading = false;

  Future<void> _oneClickLogin() async {
    if (!widget.agree) {
      widget.showAgreeDialog(context, pendingAction: () {
        _oneClickLogin();
      });
      return;
    }
    setState(() { _loading = true; });

    try {
      final result = await JverifyPlugin.jverify.loginAuth(true);

      if (result['code'] == 6000 && result['message'] != null) {
        await _loginWithToken(result['message']);
      }
      else {
        ToastUtil.showError(_getErrorMessage(result['message']));
      }
    }
    catch (e) {
      ToastUtil.showError('一键登录异常: $e');
    }
    finally {
      if (mounted) setState(() { _loading = false; });
    }
  }

  Future<void> _loginWithToken(String loginToken) async {
    try {
      final data = {
        'grant_type': 'phoneOneClickLogin',
        'client_id': AppConfig.clientId,
        'client_secret': AppConfig.clientSecret,
        'loginToken': loginToken,
      };
      Map<String, dynamic> result = await AuthorizationApis().token(data);
      TokenServices.setToken(result['access_token']);
      await ref.read(sessionStore.notifier).getCurrentLoginInformation();

      final sessionState = ref.read(sessionStore);
      final userInfo = sessionState.userInfo;

      if (userInfo!['userDataInitialized'] == true) {
        GoRouter.of(context).replace(AppRoutes.home);
      }
      else {
        GoRouter.of(context).replace(AppRoutes.interestSetting);
      }
    }
    catch (e) {
      ToastUtil.showError('登录失败: $e');
    }
  }

  String _getErrorMessage(dynamic code) {
    switch (code) {
      case 6000:
        return '成功';
      case 6001:
        return '用户取消登录';
      case 6002:
        return '网络异常';
      case 6003:
        return '未开启数据流量';
      case 6004:
        return '获取token失败';
      case 6005:
        return '预取号失败';
      default:
        return '一键登录失败，错误码: $code';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _loading ? null : _oneClickLogin,
              child: _loading
                  ? SizedBox(child: CircularProgressIndicator(color: Colors.white), width: 16, height: 16)
                  : const Text('本机号码一键登录'),
            ),
          ),
          SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: widget.onSwitchToSmsLogin,
              child: const Text('其他手机号登录'),
            ),
          ),
        ],
      ),
    );
  }
}