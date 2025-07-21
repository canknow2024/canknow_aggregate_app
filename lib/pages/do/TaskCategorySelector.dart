import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../apis/task/TaskCategoryApis.dart';

final taskCategoryListProvider = FutureProvider.autoDispose((ref) async {
  final response = await TaskCategoryApis.instance.getAll(null);
  return response['items'] as List<dynamic>? ?? [];
});

class TaskCategorySelector extends ConsumerWidget {
  final int? selectedCategoryId;
  final ValueChanged<Map> onCategorySelected;
  const TaskCategorySelector({super.key, required this.selectedCategoryId, required this.onCategorySelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCategories = ref.watch(taskCategoryListProvider);
    return Container(
      padding: EdgeInsets.all(16),
      child: SizedBox(
        height: 40,
        child: asyncCategories.when(
          data: (categories) {
            if (categories.isEmpty) {
              return const Center(child: Text('暂无任务分类'));
            }
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = categories[index];
                final bool selected = cat['id'] == selectedCategoryId || (selectedCategoryId == null && index == 0);
                return ChoiceChip(
                  label: Text(cat['name'] ?? ''),
                  selected: selected,
                  showCheckmark: false,
                  avatar: cat['icon'] != null ? Image.network(cat['icon'], width: 20, height: 20, errorBuilder: (_, __, ___) => const Icon(Icons.category, size: 16)) : null,
                  onSelected: (_) => onCategorySelected(cat),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('加载失败: $e')),
        ),
      ),
    );
  }
} 