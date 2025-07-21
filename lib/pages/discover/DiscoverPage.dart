import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../routes/appRoutes.dart';
import 'DiscoverBannerWidget.dart';
import 'DiscoverTopicListWidget.dart';
import 'DiscoverStoryListWidget.dart';
import 'DiscoverHotTaskListWidget.dart';
import '../../widgets/SearchHeaderWidget.dart';

class DiscoverPage extends ConsumerStatefulWidget {
  const DiscoverPage({Key? key}) : super(key: key);
  @override
  ConsumerState<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends ConsumerState<DiscoverPage> {
  List<dynamic> advertisements = [];
  List<dynamic> topics = [];
  List<dynamic> stories = [];
  List<dynamic> tasks = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('发现'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          SearchHeaderWidget(
            onTap: () {
              GoRouter.of(context).push(AppRoutes.discoverSearch, extra: {'recommend': true});
            },
            hintText: '搜索任务、专题或用户',
          ),
          DiscoverBannerWidget(),
          DiscoverTopicListWidget(),
          DiscoverStoryListWidget(),
          DiscoverHotTaskListWidget(),
        ],
      ),
    );
  }
} 