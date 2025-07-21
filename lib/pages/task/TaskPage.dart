import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../apis/task/TaskApis.dart';
import '../../utils/ToastUtil.dart';
import 'package:go_router/go_router.dart';
import 'AICreateTaskPage.dart';

final taskListProvider = FutureProvider.autoDispose.family((ref, Map<String, dynamic> params) async {
  final result = await TaskApis.instance.getAllByPage(params);
  return result['items'] as List<dynamic>? ?? [];
});

class TaskPage extends ConsumerStatefulWidget {
  final String? title;
  final Map<String, dynamic>? filterParams;

  const TaskPage({
    super.key,
    this.title = '任务列表',
    this.filterParams,
  });

  @override
  ConsumerState<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends ConsumerState<TaskPage> {
  int _currentPage = 0;
  final int _pageSize = 10;
  List<Map<String, dynamic>> _tasks = [];
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks({bool refresh = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final params = {
        'page': refresh ? 0 : _currentPage,
        'size': _pageSize,
        ...?widget.filterParams,
      };

      final result = await TaskApis.instance.getAllByPage(params);
      final newTasks = (result['items'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();

      setState(() {
        if (refresh) {
          _tasks = newTasks;
          _currentPage = 0;
        } else {
          _tasks.addAll(newTasks);
        }
        _hasMore = newTasks.length >= _pageSize;
        _currentPage++;
      });
    } catch (e) {
      ToastUtil.showError('加载失败: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? '任务列表'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              context.push('/task/search');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _loadTasks(refresh: true),
        child: _tasks.isEmpty && !_isLoading
            ? const Center(child: Text('暂无任务'))
            : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: _tasks.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _tasks.length) {
                    if (_hasMore) {
                      _loadTasks();
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }

                  final task = _tasks[index];
                  return _buildTaskCard(context, task);
                },
              ),
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, Map<String, dynamic> task) {
    final Map<String, dynamic>? taskCategory = task['taskCategory'];
    final String categoryIcon = taskCategory != null && taskCategory['icon'] != null ? taskCategory['icon'] : '';
    final String category = taskCategory != null && taskCategory['name'] != null ? taskCategory['name'] : '';
    final String description = task['description'] ?? '';
    final String deposit = task['deposit'] != null ? '承诺金：${task['deposit']}元' : '';
    final int continuallyDays = task['continuallyDays'] ?? 0;
    final int participantCount = task['participantCount'] ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          context.push('/task/detail/' + task['id'].toString());
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 左侧分类icon（图片）
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: categoryIcon.isNotEmpty
                      ? Image.network(
                          categoryIcon,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 32, color: Colors.grey),
                        )
                      : const Icon(Icons.image, size: 32, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 16),
              // 右侧内容
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        task['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
                          '$participantCount人参与',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (deposit.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              deposit,
                              style: const TextStyle(
                                color: Colors.orange,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (deposit.isNotEmpty) const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '持续$continuallyDays天',
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                            ),
                          ),
                        )
                      ],
                    ),
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