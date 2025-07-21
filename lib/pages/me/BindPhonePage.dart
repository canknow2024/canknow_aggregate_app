import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import '../../apis/user/UserApis.dart';
import '../../providers/SessionStore.dart';
import '../../utils/ToastUtil.dart';
import '../../routes/appRoutes.dart';
import '../../widgets/PhoneNumberInputField.dart';

class BindPhonePage extends ConsumerStatefulWidget {
  const BindPhonePage({Key? key}) : super(key: key);

  @override
  ConsumerState<BindPhonePage> createState() => _BindPhonePageState();
}

class _BindPhonePageState extends ConsumerState<BindPhonePage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  bool _loading = false;
  bool _sending = false;
  int _seconds = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() { _seconds = 60; });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
      await UserApis.instance.sendSmcCodeForBindPhone({
        'phoneNumber': cleanPhone,
      });

      ToastUtil.showSuccess('验证码已发送');
      _startTimer();
    }
    catch (e) {
      ToastUtil.showError('发送验证码失败');
    }
    finally {
      setState(() { _sending = false; });
    }
  }

  Future<void> _bindPhone() async {
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

    try {
      await UserApis.instance.bindPhone({
        'phoneNumber': cleanPhone,
        'code': _codeController.text.trim(),
      });
      ToastUtil.showSuccess('绑定成功');

      if (mounted) {
        ref.read(sessionStore.notifier).setPhoneNumber(cleanPhone);
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
    catch (e) {
      ToastUtil.showError('绑定失败');
    }
    finally {
      setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('绑定手机号')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 40, 32, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '绑定手机号后可用于账号安全和找回密码',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
                const SizedBox(height: 32),
                PhoneNumberInputField(
                  controller: _phoneController,
                  hintText: '请输入手机号',
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _codeController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          hintText: '请输入验证码',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 120,
                      child: OutlinedButton(
                        onPressed: (_seconds == 0 && !_sending) ? _sendCode : null,
                        child: _sending
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                            : Text(_seconds == 0 ? '获取验证码' : '$_seconds s'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _bindPhone,
                    child: _loading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('绑定'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
