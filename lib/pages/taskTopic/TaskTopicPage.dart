import 'package:canknow_aggregate_app/theme/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../apis/task/TaskTopicApis.dart';

class TaskTopicPage extends ConsumerStatefulWidget {
  final bool recommend;
  const TaskTopicPage({Key? key, this.recommend = false}) : super(key: key);

  @override
  ConsumerState<TaskTopicPage> createState() => _TaskTopicPageState();
}

class _TaskTopicPageState extends ConsumerState<TaskTopicPage> {
  List<dynamic> topics = [];
  int page = 1;
  bool isLoading = false;
  bool hasMore = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100 && !isLoading && hasMore) {
        _fetchData();
      }
    });
  }

  Future<void> _fetchData() async {
    setState(() { isLoading = true; });
    final params = {'page': page, 'size': 10};
    if (widget.recommend) params['featured'] = 1;
    final result = await TaskTopicApis.instance.getAllByPage(params);
    final List<dynamic> items = result['items'] ?? [];
    setState(() {
      topics.addAll(items);
      page++;
      isLoading = false;
      hasMore = items.length == 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('专题列表')),
      body: topics.isEmpty && isLoading ? _buildSkeleton() : RefreshIndicator(
              onRefresh: () async {
                setState(() { topics.clear(); page = 1; hasMore = true; });
                await _fetchData();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: topics.length + (hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < topics.length) {
                      final topic = topics[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
                        ),
                        elevation: 0,
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          leading: topic['cover'] != null && topic['cover'].toString().isNotEmpty ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              topic['cover'],
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                            ),
                          ) : Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          title: Text(topic['name'] ?? '', style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            topic['description'] ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (topic['featured'] == true)
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text('精选', style: TextStyle(color: Colors.white, fontSize: 12)),
                                ),
                              SizedBox(height: 4),
                              Text('${topic['taskCount'] ?? 0}个任务', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      );
                    }
                    else {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                  },
                ),
              )
            ),
    );
  }

  Widget _buildSkeleton() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Container(width: 56, height: 56, color: Colors.grey[300]),
          title: Container(height: 16, color: Colors.grey[300], margin: EdgeInsets.symmetric(vertical: 4)),
          subtitle: Container(height: 14, color: Colors.grey[200], margin: EdgeInsets.symmetric(vertical: 2)),
        );
      },
    );
  }
} 