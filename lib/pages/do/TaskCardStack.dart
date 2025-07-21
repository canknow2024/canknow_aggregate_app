import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import '../../apis/task/UserTaskApis.dart';
import 'DoTaskCard.dart';
import '../../utils/ToastUtil.dart';

final userTaskListProvider = FutureProvider.family.autoDispose((ref, int? taskCategoryId) async {
  Map<String, dynamic> params = {};
  params['ongoing'] = true;
  if (taskCategoryId != null) {
    params['taskCategoryId'] = taskCategoryId;
  }
  final result = await UserTaskApis.instance.getAll(params);
  var items = result['items'] as List<dynamic>? ?? [];
  print(items);
  return items;
});

class TaskCardStack extends ConsumerStatefulWidget {
  final int? taskCategoryId;
  const TaskCardStack({super.key, this.taskCategoryId});

  @override
  ConsumerState<TaskCardStack> createState() => _TaskCardStackState();
}

class _TaskCardStackState extends ConsumerState<TaskCardStack> {
  final SwiperController _swiperController = SwiperController();
  List<dynamic> _userTasks = [];
  int _currentIndex = 0;

  void _onCheckInSuccess(dynamic userTask) {
    setState(() {
      userTask['hasCheckInToday'] = true;
    });
    ToastUtil.showSuccess("打卡成功");
  }

  List<dynamic> get todoUserTasks {
    return _userTasks.where((item) {
      return item['hasCheckInToday'] == false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final double cardWidth = MediaQuery.of(context).size.width - 64;
    final double cardHeight = 180.0;

    final asyncUserTasks = ref.watch(userTaskListProvider(widget.taskCategoryId));
    return asyncUserTasks.when(
      data: (userTasks) {
        // 判断数据是否变化
        if (!const ListEquality().equals(_userTasks, userTasks)) {
          _userTasks = List<dynamic>.from(userTasks);
          if (_currentIndex >= todoUserTasks.length) {
            _currentIndex = 0;
          }
        }
        if (todoUserTasks.isEmpty) {
          return Container(
            color: const Color(0xFFF7F8FA),
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '🤝',
                    style: TextStyle(fontSize: 48),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '暂无团队任务，快去创建一个吧！',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFB0B3B8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
        return Swiper(
          controller: _swiperController,
          itemCount: todoUserTasks.length,
          itemBuilder: (context, index) => Container(
            width: cardWidth,
            height: cardHeight,
            alignment: Alignment.center,
            child: DoTaskCard(
              key: ValueKey(todoUserTasks[index]['id']),
              item: todoUserTasks[index],
              onCheckInSuccess: () => _onCheckInSuccess(todoUserTasks[index]),
            ),
          ),
          layout: SwiperLayout.STACK,
          itemWidth: cardWidth,
          itemHeight: cardHeight,
          viewportFraction: 0.8,
          scale: 0.9,
          onIndexChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          loop: false,
          axisDirection: AxisDirection.right,
          index: _currentIndex,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('加载失败: $e')),
    );
  }
}