import 'package:canknow_aggregate_app/providers/SessionStore.dart';
import 'package:canknow_aggregate_app/routes/appRoutes.dart';
import 'package:canknow_aggregate_app/utils/AvatarUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MePage extends ConsumerWidget {
  const MePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionState = ref.watch(sessionStore);
    final userInfo = sessionState.userInfo;

    return Scaffold(
      body: SafeArea(
        child: _MePageContent(userInfo: userInfo),
      ),
    );
  }
}

class _MePageContent extends StatefulWidget {
  final dynamic userInfo;
  const _MePageContent({this.userInfo});
  @override
  State<_MePageContent> createState() => _MePageContentState();
}

class _MePageContentState extends State<_MePageContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = widget.userInfo;
    return Container(
      child: Column(
        children: [
          if (userInfo != null) Container(
              color: Theme.of(context).cardTheme.color,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Row(
                children: [
                  AvatarUtil.buildAvatar(
                    avatarUrl: userInfo['avatar'],
                    radius: 35,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text((userInfo['nickName']?.isNotEmpty == true) ? userInfo['nickName'] : (userInfo['userName'] ?? '未设置昵称'), style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No.' + userInfo['number'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () => GoRouter.of(context).push(AppRoutes.editProfile),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),
          Column(
            children: [
              _buildMenuTile(
                context,
                icon: Icons.assignment_late_outlined,
                title: '任务补卡',
                onTap: () => GoRouter.of(context).push(AppRoutes.makeUpCheckIn),
              ),
              const Divider(height: 1, indent: 16),
              _buildMenuTile(
                context,
                icon: Icons.settings_outlined,
                title: '设置',
                onTap: () => GoRouter.of(context).push(AppRoutes.settings),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMenuTile(BuildContext context, { required IconData icon, required String title, required VoidCallback onTap }) {
    return ListTile(
      title: Text(title),
      trailing: Icon(Icons.chevron_right, color: Colors.grey[300]),
      onTap: onTap,
      minVerticalPadding: 0,
      visualDensity: const VisualDensity(vertical: 0),
    );
  }
}