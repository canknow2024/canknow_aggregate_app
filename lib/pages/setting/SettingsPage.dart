import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../providers/SessionStore.dart';
import '../../routes/appRoutes.dart';
import '../../theme/AppTheme.dart';
import '../../utils/UpdateChecker.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      setState(() {
        _version = info.version;
      });
    } catch (e) {
      setState(() {
        _version = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final divider = const Divider(height: 1, indent: AppTheme.contentPadding);

    return Scaffold(
      appBar: AppBar(
        title: const Text('系统设置'),
      ),
      body: ListView(
        children: [
          // 新增：个人信息与账户与安全分组
          Container(
            margin: EdgeInsets.all(AppTheme.componentSpan),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
            ),
            child: Column(
              children: [
                _buildListTile(
                  context,
                  title: '个人信息',
                  onTap: () => context.push('/me/edit'),
                ),
                divider,
                _buildListTile(
                  context,
                  title: '账户与安全',
                  onTap: () => context.push('/account-security'),
                ),
              ],
            ),
          ),
          // 第一组
          Container(
            margin: EdgeInsets.all(AppTheme.componentSpan),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
            ),
            child: Column(
              children: [
                _buildListTile(
                  context,
                  title: '主题设置',
                  onTap: () => context.push('/theme-setting'),
                ),
                divider,
                _buildListTile(
                  context,
                  title: '语言设置',
                  onTap: () => context.push('/language-setting'),
                ),
                divider,
                _buildListTile(
                  context,
                  title: '通知设置',
                  onTap: () => context.push('/notification-setting'),
                ),
              ],
            ),
          ),
          // 第二组
          Container(
            margin: EdgeInsets.all(AppTheme.componentSpan),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
            ),
            child: Column(
              children: [
                _buildListTile(
                  context,
                  title: '用户协议',
                  onTap: () => context.push('/user-agreement'),
                ),
                divider,
                _buildListTile(
                  context,
                  title: '隐私政策',
                  onTap: () => context.push('/privacy-policy'),
                ),
                divider,
                _buildListTile(
                  context,
                  title: '联系客服',
                  onTap: () => context.push('/contact-service'),
                ),
                divider,
                _buildListTile(
                  context,
                  title: '关于我们',
                  onTap: () => context.push('/about'),
                ),
                divider,
                _buildListTile(
                  context,
                  title: '检查更新',
                  trailing: Text(_version.isNotEmpty ? '版本 $_version' : ''),
                  onTap: () => UpdateChecker.checkUpdate(context, showNoUpdateToast: true),
                ),
              ],
            ),
          ),
          // 退出登录
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.componentSpan),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  side: null,
                ),
                onPressed: () => _showLogoutDialog(context, ref),
                child: const Text('退出登录'),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF7F8FA),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      title: Text(title),
      trailing: trailing ?? Icon(Icons.chevron_right, color: Colors.grey[300]),
      onTap: onTap,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认退出'),
        content: const Text('确定要退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(sessionStore.notifier).logout();
              if (context.mounted) {
                context.go(AppRoutes.login);
              }
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}