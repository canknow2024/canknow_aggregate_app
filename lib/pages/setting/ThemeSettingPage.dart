import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/ThemeStore.dart';

class ThemeSettingPage extends ConsumerWidget {
  const ThemeSettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeStore);
    final options = const [
      {'mode': ThemeMode.light, 'label': '浅色主题'},
      {'mode': ThemeMode.dark, 'label': '深色主题'},
      {'mode': ThemeMode.system, 'label': '跟随系统'},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('主题设置')),
      body: Container(
        margin: const EdgeInsets.only(top: 16),
        child: ListView.separated(
          itemCount: options.length,
          separatorBuilder: (context, index) => const Divider(height: 1, indent: 16,),
          itemBuilder: (context, index) {
            final item = options[index];
            final mode = item['mode'] as ThemeMode;
            final label = item['label'] as String;
            final selected = themeMode == mode;
            return ListTile(
              title: Text(label),
              trailing: selected ? const Icon(Icons.check, color: Colors.blue) : null,
              onTap: () {
                ref.read(themeStore.notifier).setTheme(mode);
              },
            );
          },
        ),
      ),
    );
  }
} 