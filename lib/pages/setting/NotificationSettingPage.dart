import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../theme/AppTheme.dart';

class NotificationSettingPage extends StatefulWidget {
  const NotificationSettingPage({super.key});

  @override
  State<NotificationSettingPage> createState() => _NotificationSettingPageState();
}

class _NotificationSettingPageState extends State<NotificationSettingPage> {
  bool taskNotify = false;
  bool communityNotify = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('通知设置'), centerTitle: true, elevation: 0),
      backgroundColor: const Color(0xFFF7F8FA),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(AppTheme.componentSpan),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
            ),
            child: Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: AppTheme.contentPadding),
                  title: const Text('任务提醒通知'),
                  trailing: CupertinoSwitch(
                    value: taskNotify,
                    onChanged: (v) => setState(() => taskNotify = v),
                  ),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppTheme.cardBorderRadius))),
                  onTap: () => setState(() => taskNotify = !taskNotify),
                ),
                const Divider(height: 1, indent: AppTheme.contentPadding),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: AppTheme.contentPadding),
                  title: const Text('社区互动通知'),
                  trailing: CupertinoSwitch(
                    value: communityNotify,
                    onChanged: (v) => setState(() => communityNotify = v),
                  ),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppTheme.cardBorderRadius))),
                  onTap: () => setState(() => communityNotify = !communityNotify),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 