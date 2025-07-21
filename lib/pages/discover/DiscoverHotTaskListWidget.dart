import 'package:canknow_aggregate_app/theme/AppTheme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../apis/task/TaskApis.dart';

final hotTaskListProvider = FutureProvider.autoDispose((ref) async {
  final result = await TaskApis.instance.getAllByPage({
    'sort': 'participantCount,desc',
    'page': 0,
    'size': 5,
  });
  return result['items'] as List<dynamic>? ?? [];
});

class DiscoverHotTaskListWidget extends ConsumerStatefulWidget {
  const DiscoverHotTaskListWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<DiscoverHotTaskListWidget> createState() => _DiscoverHotTaskListWidgetState();
}

class _DiscoverHotTaskListWidgetState extends ConsumerState<DiscoverHotTaskListWidget> {
  List<dynamic> tasks = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final asyncHotTasks = ref.watch(hotTaskListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('热门任务榜', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        asyncHotTasks.when(
          data: (tasks) {
            if (tasks.isEmpty) {
              return Center(child: Text('no hot tasks'.tr()));
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return _buildHotTaskCard(context, task, index);
              },
            );
          },
          loading: () => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: List.generate(3, (index) => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 16,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: 80,
                                height: 12,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: 120,
                                height: 12,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
            ),
          ),
          error: (e, _) => Center(child: Text('load failed'.tr() + ': $e')),
        ),
      ],
    );
  }

  Widget _buildHotTaskCard(BuildContext context, Map<String, dynamic> task, int index) {
    final Map<String, dynamic>? taskCategory = task['taskCategory'];
    final String categoryIcon = taskCategory != null && taskCategory['icon'] != null ? taskCategory['icon'] : '';
    final String category = taskCategory != null && taskCategory['name'] != null ? taskCategory['name'] : '';
    final int participantCount = task['participantCount'] ?? 0;

    return Card(
      margin: const EdgeInsets.only(left: AppTheme.contentPadding, right: AppTheme.contentPadding, bottom: AppTheme.componentSpan),
      child: InkWell(
        onTap: () {
          context.push('/task/detail/' + task['id'].toString());
        },
        borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.contentPadding),
          child: Row(
            children: [
              // 排名号
              Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[800],
                ),
              ),
              const SizedBox(width: AppTheme.componentSpan),
              // 左侧分类icon（图片）
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: categoryIcon.isNotEmpty ? Image.network(
                    categoryIcon,
                    width: 36,
                    height: 36,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 36, color: Colors.grey),
                  ) : const Icon(Icons.image, size: 36, color: Colors.grey),
                ),
              ),
              const SizedBox(width: AppTheme.componentSpan),
              // 右侧内容
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        task['name'],
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          category,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '·',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          'participants'.tr(namedArgs: {'count': participantCount.toString()}),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 