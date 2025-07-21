import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../apis/task/ExpertStoryApis.dart';

class DiscoverStoryListWidget extends ConsumerStatefulWidget {
  const DiscoverStoryListWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<DiscoverStoryListWidget> createState() => _DiscoverStoryListWidgetState();
}

class _DiscoverStoryListWidgetState extends ConsumerState<DiscoverStoryListWidget> {
  List<dynamic> stories = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final storyRes = await ExpertStoryApis.instance.getAll({"recommended": true});
    setState(() {
      stories = storyRes['items'] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('达人故事', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        Container(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: stories.length,
            itemBuilder: (context, index) {
              final story = stories[index];
              final String cover = story['cover'] ?? '';
              final String avatar = story['avatar'] ?? '';
              final String nickName = story['nickName'] ?? '';
              final String title = story['title'] ?? '';
              return Container(
                width: 220,
                margin: EdgeInsets.only(left: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: cover.isNotEmpty
                          ? Image.network(
                              cover,
                              width: 220,
                              height: 180,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 220,
                              height: 180,
                              color: Colors.grey[200],
                            ),
                    ),
                    // 内容块整体垂直居中，水平靠左
                    Positioned(
                      left: 16,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.white,
                                  backgroundImage: avatar.isNotEmpty ? NetworkImage(avatar) : null,
                                  child: avatar.isEmpty ? Icon(Icons.person, color: Colors.grey) : null,
                                ),
                                SizedBox(width: 12),
                                Container(
                                  constraints: BoxConstraints(maxWidth: 120),
                                  child: Text(
                                    nickName,
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white, shadows: [Shadow(color: Colors.black26, blurRadius: 4)]),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: 160,
                              child: Text(
                                title,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold, shadows: [Shadow(color: Colors.black26, blurRadius: 4)]),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
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