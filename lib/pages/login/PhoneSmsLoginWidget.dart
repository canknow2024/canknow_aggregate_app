import 'package:canknow_aggregate_app/apis/authorization/AuthorizationApis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import '../../config/AppConfig.dart';
import '../../providers/SessionStore.dart';
import '../../routes/appRoutes.dart';
import '../../services/TokenServices.dart';
import '../../utils/ToastUtil.dart';
import '../../widgets/PhoneNumberInputField.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PhoneSmsLoginWidget extends ConsumerStatefulWidget {
  final bool agree;
  final showAgreeDialog;
  final onSwitchToOneClick;
  const PhoneSmsLoginWidget({Key? key, required this.agree, required this.showAgreeDialog, required this.onSwitchToOneClick}) : super(key: key);

  @override
  ConsumerState<PhoneSmsLoginWidget> createState() => _PhoneSmsLoginWidgetState();
}

class _PhoneSmsLoginWidgetState extends ConsumerState<PhoneSmsLoginWidget> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  bool _loading = false;
  bool _sending = false;
  int _seconds = 0;
  Timer? _timer;
  bool _isCodeSent = false; // 新增：控制验证码输入界面
  String _sentPhone = '';

  @override
  void dispose() {
    _timer?.cancel();
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (!mounted) return;
    
    setState(() { _seconds = 60; });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      if (_seconds <= 1) {
        timer.cancel();
        setState(() { _seconds = 0; });
      }
      else {
        setState(() { _seconds--; });
      }
    });
  }

  Future<void> _sendCode() async {
    if (!mounted) return;
    
    // 获取纯数字手机号
    final cleanPhone = _phoneController.text.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanPhone.isEmpty) {
      ToastUtil.showWarning('请输入手机号');
      return;
    }
    if (cleanPhone.length != 11) {
      ToastUtil.showWarning('请输入正确的手机号');
      return;
    }
    setState(() { _sending = true; });

    try {
      await AuthorizationApis.instance.send({
        'phoneNumber': cleanPhone,
      });
      if (mounted) {
        ToastUtil.showSuccess('验证码已发送');
        _startTimer();
        setState(() {
          _isCodeSent = true;
          _sentPhone = _phoneController.text;
        });
      }
    }
    catch (e) {
      if (mounted) {
        ToastUtil.showError('发送验证码失败');
      }
    }
    finally {
      if (mounted) {
        setState(() { _sending = false; });
      }
    }
  }

  Future<void> _login() async {
    if (!mounted) return;
    
    if (!widget.agree) {
      widget.showAgreeDialog(context, pendingAction: () {
        _login();
      });
      return;
    }
    // 获取纯数字手机号
    final cleanPhone = _phoneController.text.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanPhone.isEmpty) {
      ToastUtil.showWarning('请输入手机号');
      return;
    }
    if (cleanPhone.length != 11) {
      ToastUtil.showWarning('请输入正确的手机号');
      return;
    }
    if (_codeController.text.trim().isEmpty) {
      ToastUtil.showWarning('请输入验证码');
      return;
    }
    setState(() { _loading = true; });

    final data = {
      'grant_type': 'phoneSms',
      'client_id': AppConfig.clientId,
      'client_secret': AppConfig.clientSecret,
      'phoneNumber': cleanPhone,
      'code': _codeController.text.trim(),
    };
    try {
      Map<String, dynamic> result = await AuthorizationApis().token(data);
      TokenServices.setToken(result['access_token']);
      await ref.read(sessionStore.notifier).getCurrentLoginInformation();

      if (mounted) {
        final sessionState = ref.read(sessionStore);
        final userInfo = sessionState.userInfo;

        if (userInfo!['userDataInitialized'] == true) {
          GoRouter.of(context).replace(AppRoutes.home);
        }
        else {
          GoRouter.of(context).replace(AppRoutes.interestSetting);
        }
      }
    }
    finally {
      if (mounted) {
        setState(() { _loading = false; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: _isCodeSent ? Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 32),
            Text('输入验证码', style: TextStyle(fontSize: 24)),
            SizedBox(height: 16),
            Text('验证码已发送至 $_sentPhone'),
            SizedBox(height: 16),
            PinCodeTextField(
              appContext: context,
              length: 4,
              controller: _codeController,
              keyboardType: TextInputType.number,
              autoFocus: true,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.underline, // 改为底部单边框
                fieldHeight: 48,
                fieldWidth: 40,
                borderRadius: BorderRadius.zero,
                activeColor: Theme.of(context).primaryColor,
                selectedColor: Theme.of(context).primaryColor,
                inactiveColor: Colors.grey,
                activeFillColor: Colors.transparent,
                selectedFillColor: Colors.transparent,
                inactiveFillColor: Colors.transparent,
                borderWidth: 1,
              ),
              onChanged: (value) {},
              onCompleted: (value) {
                _login();
              },
            ),
            SizedBox(height: 16),
            _seconds > 0 ? Text('${_seconds}s后可重新发送') : TextButton(
              onPressed: _sending ? null : _sendCode,
              child: Text('重新发送验证码'),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _login,
                child: _loading ? CircularProgressIndicator(color: Colors.white) : Text('登录'),
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () {
                  if (mounted) {
                    setState(() {
                      _isCodeSent = false;
                      _codeController.clear();
                    });
                  }
                },
                child: Text('返回'),
              ),
            ),
          ],
        )
            : Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 32),
            PhoneNumberInputField(
              controller: _phoneController,
              hintText: '请输入手机号',
              autofocus: true,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '未注册的手机号验证通过后将自动注册',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_seconds == 0 && !_sending) ? _sendCode : null,
                child: _sending ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text(_seconds == 0 ? '获取验证码' : '$_seconds s', style: TextStyle(fontSize: 18)),
              ),
            ),
            SizedBox(height: 24),
            Center(
              child: TextButton(
                onPressed: widget.onSwitchToOneClick,
                child: Text('返回一键登录'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}