import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../apis/task/UserTaskApis.dart';
import '../../providers/SessionStore.dart';
import '../../theme/AppTheme.dart';
import '../../utils/ToastUtil.dart';
import 'MyTaskPage.dart' show userTaskListProvider;

class TaskItemCard extends ConsumerWidget {
  final Map<String, dynamic> item;
  final VoidCallback? onCheckInSuccess;

  const TaskItemCard({required this.item, this.onCheckInSuccess});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final task = item['task'] ?? {};
    final title = task['name'] ?? '无标题';
    final progress = item['checkInCount'] ?? 0;
    final total = task['continuallyDays'] ?? 1;
    final bool hasCheckInToday = item['hasCheckInToday'] ?? false;
    final progressValue = total > 0 ? progress / total : 0.0;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius)),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.contentPadding),
        child: Row(
          children: [
            const Icon(Icons.book, size: 30, color: Colors.blue),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('已坚持 $progress/$total 天', style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: progressValue,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            hasCheckInToday ? ActionChip(
              label: const Text('今日已打'),
              backgroundColor: Colors.green,
              labelStyle: const TextStyle(color: Colors.white),
              onPressed: () {},
            ) : ElevatedButton(
              style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(vertical: AppTheme.contentPaddingSmall),
                ),
                textStyle: MaterialStateProperty.all(
                  const TextStyle(fontSize: 14),
                ),
              ),
              child: const Text('打卡'),
              onPressed: () async {
                try {
                  await UserTaskApis.instance.checkIn(item['id']);
                  ref.invalidate(userTaskListProvider);
                  if (onCheckInSuccess != null) onCheckInSuccess!();
                  ToastUtil.showSuccess("打卡成功");
                }
                catch (e) {
                  ToastUtil.showError("打卡失败: $e");
                }
              },
            )
          ],
        ),
      ),
    );
  }
}