import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/PrivacyPolicyDialog.dart';
import '../../utils/WechatUtil.dart';
import 'PhoneOneClickLoginWidget.dart';
import 'PhoneSmsLoginWidget.dart';
import 'WechatLoginWidget.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool _agree = false;
  bool _showSmsLogin = false;
  VoidCallback? _pendingLoginAction;

  @override
  void dispose() {
    // 清理微信登录资源
    WechatUtil.dispose();
    super.dispose();
  }


  void _onAgreeChanged(bool? value) {
    setState(() {
      _agree = value ?? false;
    });
  }

  void _showAgreeDialog(BuildContext context, {VoidCallback? pendingAction}) {
    _pendingLoginAction = pendingAction;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PrivacyPolicyDialog(
        onAgree: () {
          Navigator.of(context).pop();
          setState(() { _agree = true; });
          if (_pendingLoginAction != null) {
            Future.delayed(Duration(milliseconds: 100), () {
              _pendingLoginAction!();
              _pendingLoginAction = null;
            });
          }
        },
        onDisagree: () {
          setState(() { _agree = false; });
          _pendingLoginAction = null;
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _navigateToUserAgreement() {
    context.push('/user-agreement');
  }

  void _navigateToPrivacyPolicy() {
    context.push('/privacy-policy');
  }

  void _switchToSmsLogin() {
    setState(() {
      _showSmsLogin = true;
    });
  }

  void _switchToOneClickLogin() {
    setState(() {
      _showSmsLogin = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '开启高效打卡生活',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            '记录每一次坚持，见证每一次成长',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 40),
                          _showSmsLogin ? PhoneSmsLoginWidget(
                                  agree: _agree,
                                  showAgreeDialog: (context, {pendingAction}) => _showAgreeDialog(context, pendingAction: pendingAction),
                                  onSwitchToOneClick: _switchToOneClickLogin)
                              : PhoneOneClickLoginWidget(
                                  agree: _agree,
                                  showAgreeDialog: (context, {pendingAction}) => _showAgreeDialog(context, pendingAction: pendingAction),
                                  onSwitchToSmsLogin: _switchToSmsLogin),
                        ],
                      ),
                    ),
                  ),
                  // 协议勾选
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Checkbox(
                            value: _agree,
                            onChanged: _onAgreeChanged,
                            shape: CircleBorder(),
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyMedium,
                              children: [
                                TextSpan(text: '我已阅读并同意'),
                                TextSpan(
                                  text: '《平台用户服务协议》',
                                  style: TextStyle(color: Colors.blue),
                                  recognizer: TapGestureRecognizer()..onTap = _navigateToUserAgreement,
                                ),
                                TextSpan(text: '、'),
                                TextSpan(
                                  text: '《平台隐私政策》',
                                  style: TextStyle(color: Colors.blue),
                                  recognizer: TapGestureRecognizer()..onTap = _navigateToPrivacyPolicy,
                                ),
                                TextSpan(text: '，并授权平台使用该账号信息以便统一管理。'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  // 第三方登录
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text('其他登录方式',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            WechatLoginWidget(
                              agree: _agree,
                              showAgreeDialog: (context, {pendingAction}) => _showAgreeDialog(context, pendingAction: pendingAction),
                            ),
                            SizedBox(width: 24),
                            GestureDetector(
                              onTap: () {
                                if (!_agree) {
                                  _showAgreeDialog(context, pendingAction: () {
                                    // Apple ID 登录逻辑
                                    // TODO: 实现Apple ID登录
                                  });
                                  return;
                                }
                                // Apple ID 登录逻辑
                                // TODO: 实现Apple ID登录
                              },
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.apple,
                                    color: Colors.black,
                                    size: 32,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 