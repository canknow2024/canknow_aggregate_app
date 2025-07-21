import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../apis/task/TaskTopicApis.dart';
import '../../routes/appRoutes.dart';

class DiscoverTopicListWidget extends ConsumerStatefulWidget {
  const DiscoverTopicListWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<DiscoverTopicListWidget> createState() => _DiscoverTopicListWidgetState();
}

class _DiscoverTopicListWidgetState extends ConsumerState<DiscoverTopicListWidget> {
  List<dynamic> taskTopics = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final result = await TaskTopicApis.instance.getAll({"featured": true});
    setState(() {
      taskTopics = result['items'] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('精选专题', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () {
                  GoRouter.of(context).push(AppRoutes.taskTopic, extra: {'recommend': true});
                },
                child: Text('全部 >', style: TextStyle(fontSize: 14, color: Colors.grey)),
              ),
            ],
          ),
        ),
        Container(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: taskTopics.length,
            itemBuilder: (context, index) {
              final taskTopic = taskTopics[index];
              final String cover = taskTopic['cover'] ?? '';
              final int taskCount = taskTopic['taskCount'] ?? 0;
              final String name = taskTopic['name'] ?? '';

              return Container(
                width: 140,
                margin: EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: cover.isNotEmpty
                              ? Image.network(
                                  cover,
                                  width: 140,
                                  height: 110,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 140,
                                  height: 110,
                                  color: Colors.grey[200],
                                ),
                        ),
                        Positioned(
                          right: 8,
                          bottom: 8,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${taskCount}个任务',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
} 