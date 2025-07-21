import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PrivacyPolicyDialog extends StatelessWidget {
  final VoidCallback onAgree;
  final VoidCallback onDisagree;

  const PrivacyPolicyDialog({
    Key? key,
    required this.onAgree,
    required this.onDisagree,
  }) : super(key: key);

  void _navigateToUserAgreement(BuildContext context) {
    Navigator.of(context).pop(); // 先关闭弹框
    context.push('/user-agreement');
  }

  void _navigateToPrivacyPolicy(BuildContext context) {
    Navigator.of(context).pop(); // 先关闭弹框
    context.push('/privacy-policy');
  }

  @override
  Widget build(BuildContext context) {
    final Color mainColor = Theme.of(context).primaryColor;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '服务协议和隐私政策',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  TextSpan(text: '在使用平台前，请你仔细阅读《'),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () => _navigateToUserAgreement(context),
                      child: Text(
                        '平台用户服务协议',
                        style: TextStyle(
                          color: mainColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  TextSpan(text: '》和《'),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () => _navigateToPrivacyPolicy(context),
                      child: Text(
                        '平台隐私政策',
                        style: TextStyle(
                          color: mainColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  TextSpan(text: '》。我们将严格按照你同意的各项条款使用你的个人信息，为你提供更好的服务。'),
                ],
              ),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onDisagree,
                    child: Text(
                      '不同意',
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAgree,
                    child: Text('同意并继续'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 