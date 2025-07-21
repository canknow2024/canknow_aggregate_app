import 'package:canknow_aggregate_app/providers/SessionStore.dart';
import 'package:canknow_aggregate_app/theme/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../apis/task/UserTaskApis.dart';
import '../../routes/appRoutes.dart';
import 'TaskItemCard.dart';
import 'AICreateTaskPage.dart';
import 'package:easy_localization/easy_localization.dart';

final userTaskListProvider = FutureProvider.autoDispose((ref) async {
  Map<String, dynamic> params = {};
  final result = await UserTaskApis.instance.getAll(params);
  return result['items'] as List<dynamic>? ?? [];
});

class MyTaskPage extends ConsumerStatefulWidget {
  const MyTaskPage({super.key});

  @override
  ConsumerState<MyTaskPage> createState() => _MyTaskPageState();
}

class _MyTaskPageState extends ConsumerState<MyTaskPage> {
  int _selectedIndex = 0;
  final List<String> _taskFilters = ['today', 'inProgress', 'completed'];

  int _todoCount = 0;
  int _totalCount = 0;
  int _consecutiveCheckInDays = 0;

  @override
  void initState() {
    super.initState();
    _fetchConsecutiveCheckInDays();
  }

  Future<void> _fetchConsecutiveCheckInDays() async {
    try {
      final result = await UserTaskApis.instance.getConsecutiveCheckInDays();
      if (mounted) {
        setState(() {
          _consecutiveCheckInDays = result['count'] ?? 0;
        });
      }
    }
    catch (e) {
      // 可以根据需要处理异常
      if (mounted) {
        setState(() {
          _consecutiveCheckInDays = 0;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncTaskList = ref.watch(userTaskListProvider);
    final session = ref.watch(sessionStore);
    final now = DateTime.now();
    final dayOfWeek = DateFormat('EEEE', 'zh_CN').format(now);
    final date = DateFormat('M月d日').format(now);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateTaskOptions(context);
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildHeader(session, date, dayOfWeek),
              const SizedBox(height: 20),
              asyncTaskList.when(
                data: (tasks) {
                  _totalCount = tasks.length;
                  _todoCount = tasks.where((t) => t['hasCheckInToday'] == false).length;
                  return _buildSummaryCard(_totalCount, _todoCount);
                },
                loading: () => _buildSummaryCard(_totalCount, _todoCount, isLoading: true),
                error: (e, _) => _buildSummaryCard(_totalCount, _todoCount, hasError: true),
              ),
              const SizedBox(height: 20),
              _buildToggleButtons(),
              const SizedBox(height: 10),
              Expanded(
                child: asyncTaskList.when(
                  data: (tasks) {
                    if (tasks.isEmpty) {
                      return Center(child: Text('no tasks'.tr()));
                    }
                    return _buildTaskList(tasks, _taskFilters[_selectedIndex]);
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('load failed'.tr() + ': $e')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(SessionState session, String date, String dayOfWeek) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$date $dayOfWeek', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
            const SizedBox(height: 4),
            Text('today cheer up'.tr(), style: const TextStyle(color: Colors.grey),),
          ],
        )
      ],
    );
  }

  Widget _buildSummaryCard(int total, int todoCount, {bool isLoading = false, bool hasError = false}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text('today todo'.tr()),
                Text('${todoCount}/${total}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.primaries.first),),
                Text('tasks'.tr())
              ],
            ),
            Row(
              children: [
                Text('consecutive check in'.tr()),
                isLoading
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text('$_consecutiveCheckInDays', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orangeAccent)),
                Text('days'.tr()),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ToggleButtons(
          isSelected: [_selectedIndex == 0, _selectedIndex == 1, _selectedIndex == 2],
          onPressed: (int index) {
            if (mounted) {
              setState(() {
                _selectedIndex = index;
              });
            }
          },
          borderRadius: BorderRadius.circular(20),
          selectedColor: Colors.white,
          color: Theme.of(context).primaryColor,
          fillColor: Theme.of(context).primaryColor,
          splashColor: Theme.of(context).primaryColor.withOpacity(0.12),
          hoverColor: Theme.of(context).primaryColor.withOpacity(0.04),
          constraints: const BoxConstraints(minHeight: 40.0, minWidth: 100.0),
          children: [
            Text('today'.tr()),
            Text('in progress'.tr()),
            Text('completed'.tr()),
          ],
        ),
      ],
    );
  }

  Widget _buildTaskList(List<dynamic> tasks, String filter) {
    List<dynamic> filteredTasks;

    if (filter == 'completed') {
      filteredTasks = tasks.where((t) {
        final task = t['task'] ?? {};
        final progress = t['checkInCount'] ?? 0;
        final total = task['targetCount'] ?? 1;
        if (total <= 0) return false; // Avoid division by zero or negative counts
        return progress >= total;
      }).toList();
    }
    else { // 'today' and 'inProgress'
      filteredTasks = tasks.where((t) {
        final task = t['task'] ?? {};
        final progress = t['checkInCount'] ?? 0;
        final total = task['targetCount'] ?? 1;
        if (total <= 0) return true; // Or handle as per logic, maybe show it
        return progress < total;
      }).toList();
    }

    if (filteredTasks.isEmpty) {
      return Center(child: Text('no tasks in this category'.tr()));
    }

    return ListView.builder(
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        final item = filteredTasks[index];
        return TaskItemCard(
          item: item,
          onCheckInSuccess: _fetchConsecutiveCheckInDays,
        );
      },
    );
  }

  void _showCreateTaskOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'choose create method'.tr(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildCreateOption(
                  context,
                  icon: Icons.dashboard_outlined,
                  title: 'create from template'.tr(),
                  subtitle: 'choose from preset templates'.tr(),
                  onTap: () async {
                    Navigator.pop(context);
                    await GoRouter.of(context).push(AppRoutes.templateSelect);
                    ref.invalidate(userTaskListProvider);
                    await _fetchConsecutiveCheckInDays();
                  },
                ),
                const SizedBox(height: 12),
                _buildCreateOption(
                  context,
                  icon: Icons.edit_outlined,
                  title: 'create directly'.tr(),
                  subtitle: 'custom create new task'.tr(),
                  onTap: () async {
                    Navigator.pop(context);
                    await GoRouter.of(context).push(AppRoutes.createTask);
                    ref.invalidate(userTaskListProvider);
                    await _fetchConsecutiveCheckInDays();
                  },
                ),
                const SizedBox(height: 12),
                _buildCreateOption(
                  context,
                  icon: Icons.auto_awesome,
                  title: 'ai create'.tr(),
                  subtitle: 'ai generate task'.tr(),
                  onTap: () async {
                    Navigator.pop(context);
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AICreateTaskPage(),
                      ),
                    );
                    ref.invalidate(userTaskListProvider);
                    await _fetchConsecutiveCheckInDays();
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreateOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Theme.of(context).unselectedWidgetColor,),
            ],
          ),
        ),
      ),
    );
  }
}