import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../apis/task/UserTaskApis.dart';

class MyFootprintWidget extends StatefulWidget {
  const MyFootprintWidget({super.key});

  @override
  State<MyFootprintWidget> createState() => _MyFootprintWidgetState();
}

class _MyFootprintWidgetState extends State<MyFootprintWidget> {
  int totalTasks = 0;
  int completedTasks = 0;
  int todayCheckInTasks = 0;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchTaskStatistics();
  }

  Future<void> _fetchTaskStatistics() async {
    try {
      setState(() {
        isLoading = true;
        hasError = false;
      });

      final result = await UserTaskApis.instance.getMyTaskStatistic();
      
      if (mounted) {
        setState(() {
          // 根据接口返回的数据结构设置值
          // 如果接口返回的字段名不同，请根据实际情况调整
          totalTasks = result['totalTasks'] ?? 0;
          completedTasks = result['completedTasks'] ?? 0;
          todayCheckInTasks = result['todayCheckInTasks'] ?? 0;
          isLoading = false;
        });
      }
    }
    catch (e) {
      if (mounted) {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<_FootprintItem> items = [
      _FootprintItem(
        icon: Image.asset(
          'assets/images/home/footprint/totalTask.png',
          width: 44,
          height: 44,
        ),
        value: totalTasks,
        label: '蜗牛小屋',
        color: Color(0xFF4CD19D),
        info: '您创建的所有任务总数，是您梦想的家园。',
        isLoading: isLoading,
      ),
      _FootprintItem(
        icon: Image.asset(
          'assets/images/home/footprint/completedTask.png',
          width: 44,
          height: 44,
        ),
        value: completedTasks,
        label: '闪亮贝壳',
        color: Color(0xFFFFB74D),
        info: '已成功完成的任务，是您坚持路上的宝贵勋章。',
        isLoading: isLoading,
      ),
      _FootprintItem(
        icon: Image.asset(
          'assets/images/home/footprint/todayTask.png',
          width: 44,
          height: 44,
        ),
        value: todayCheckInTasks,
        label: '今日征途',
        color: Color(0xFF4FC3F7),
        info: '今天需要完成的打卡任务数量。',
        isLoading: isLoading,
      ),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('my footprint'.tr(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (hasError)
                IconButton(
                  onPressed: _fetchTaskStatistics,
                  icon: Icon(Icons.refresh, color: Colors.red),
                  tooltip: '重新加载',
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(items.length, (index) {
              final item = items[index];
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    left: index == 0 ? 0 : 8,
                    right: index == items.length - 1 ? 0 : 8,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      item.icon,
                      const SizedBox(height: 10),
                      if (item.isLoading)
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(item.color),
                          ),
                        )
                      else
                        Text(
                          item.value.toString(),
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Baseline(
                            baseline: 16,
                            baselineType: TextBaseline.alphabetic,
                            child: Text(
                              item.label,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Baseline(
                            baseline: 16,
                            baselineType: TextBaseline.alphabetic,
                            child: GestureDetector(
                              onTap: () => _showInfoDialog(context, item.label, item.info),
                              child: Icon(Icons.info_outline, size: 14, color: Theme.of(context).iconTheme.color),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context, String title, String info) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(info),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
  }
}

class _FootprintItem {
  final Widget icon;
  final int value;
  final String label;
  final Color color;
  final String info;
  final bool isLoading;

  const _FootprintItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.info,
    this.isLoading = false,
  });
} 