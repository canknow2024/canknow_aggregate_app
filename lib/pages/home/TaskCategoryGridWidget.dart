import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../apis/task/TaskCategoryApis.dart';
import 'package:go_router/go_router.dart';
import '../../routes/appRoutes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shimmer/shimmer.dart';

final taskCategoryListProvider = FutureProvider.autoDispose((ref) async {
  Map<String, dynamic>? queryParameters = {
    'pageIndex': 0,
    'size': 7,
  };
  final response = await TaskCategoryApis.instance.getAllByPage(queryParameters);
  return response['items'] as List<dynamic>? ?? [];
});

class TaskCategoryGridWidget extends ConsumerWidget {
  const TaskCategoryGridWidget({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCategories = ref.watch(taskCategoryListProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('task categories'.tr(), style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),),
          const SizedBox(height: 16),
          asyncCategories.when(
            data: (taskCategories) {
              if (taskCategories.isEmpty) {
                return Center(child: Text('no task categories'.tr()));
              }
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                itemCount: taskCategories.length + 1, // 多一个“更多”按钮
                itemBuilder: (context, index) {
                  if (index < taskCategories.length) {
                    if (taskCategories[index] is Map) {
                      final taskCategory = Map<String, dynamic>.from(taskCategories[index]);
                      return _buildCategoryCard(context, taskCategory);
                    }
                    return const SizedBox.shrink();
                  }
                  else {
                    // 最后一个为“更多”按钮
                    return _buildMoreCard(context);
                  }
                },
              );
            },
            loading: () => GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: 8,
              itemBuilder: (context, index) => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            error: (e, _) => Center(child: Text('load failed'.tr() + ': $e')),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, Map<dynamic, dynamic> taskCategory) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          GoRouter.of(context).push(
            AppRoutes.taskList,
            extra: {
              'title': taskCategory['name'] ?? 'task list'.tr(),
              'filterParams': {'taskCategoryId': taskCategory['id']},
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                taskCategory['icon'],
                width: 44,
                height: 44,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.category,
                  size: 44,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                taskCategory['name'] ?? '', style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoreCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          GoRouter.of(context).push('/task-category-all');
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/home/taskCategory/more.png',
                width: 44,
                height: 44,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 12),
              Text(
                '更多',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 