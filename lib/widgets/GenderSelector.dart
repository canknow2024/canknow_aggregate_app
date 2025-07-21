import 'package:flutter/material.dart';

/// 性别选择组件，0-未知 1-女 2-男
class GenderSelector extends StatelessWidget {
  final int? value;
  final ValueChanged<int> onChanged;
  final String title;
  final bool showUnknown;

  const GenderSelector({
    Key? key,
    required this.value,
    required this.onChanged,
    this.title = '选择性别',
    this.showUnknown = true,
  }) : super(key: key);

  Color _getIconColor(int gender, bool selected) {
    if (gender == 1) return selected ? Color(0xFFE573B7) : Color(0xFFF48FB1); // 女-粉色
    if (gender == 2) return selected ? Color(0xFF42A5F5) : Color(0xFF90CAF9); // 男-蓝色
    return selected ? Colors.grey : Colors.grey[400]!; // 未知-灰色
  }

  IconData _getIcon(int gender) {
    if (gender == 1) return Icons.female;
    if (gender == 2) return Icons.male;
    return Icons.help_outline;
  }

  @override
  Widget build(BuildContext context) {
    // 用于底部弹出选择
    final List<_GenderOption> options = [
      if (showUnknown) _GenderOption(0, '未知', Icons.help),
      _GenderOption(1, '女', Icons.female),
      _GenderOption(2, '男', Icons.male),
    ];
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: options.map((option) {
                  final bool selected = value == option.value;
                  return GestureDetector(
                    onTap: () => onChanged(option.value),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 28),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected ? Theme.of(context).colorScheme.primary : Theme.of(context).dividerTheme.color!,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_getIcon(option.value), size: 36, color: _getIconColor(option.value, selected)),
                          const SizedBox(height: 8),
                          Text(option.label, style: Theme.of(context).textTheme.bodyMedium,),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// 静态方法，底部弹出选择并返回选中的int值
  static Future<int?> show(BuildContext context, {int? value, String title = '选择性别', bool showUnknown = true}) async {
    final result = await showModalBottomSheet<int>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => GenderSelector(
        value: value,
        onChanged: (v) => Navigator.pop(context, v),
        title: title,
        showUnknown: showUnknown,
      ),
    );
    return result;
  }
}

class _GenderOption {
  final int value;
  final String label;
  final IconData icon;
  const _GenderOption(this.value, this.label, this.icon);
} 