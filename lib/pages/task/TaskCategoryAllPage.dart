import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../apis/task/TaskCategoryApis.dart';
import 'package:go_router/go_router.dart';
import '../../routes/appRoutes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shimmer/shimmer.dart';

final allTaskCategoryListProvider = FutureProvider.family.autoDispose((ref, int pageIndex) async {
  Map<String, dynamic>? queryParameters = {
    'pageIndex': pageIndex,
    'size': 20,
  };
  final response = await TaskCategoryApis.instance.getAllByPage(queryParameters);
  return response['items'] as List<dynamic>? ?? [];
});

class TaskCategoryAllPage extends ConsumerStatefulWidget {
  const TaskCategoryAllPage({Key? key}) : super(key: key);

  @override
  ConsumerState<TaskCategoryAllPage> createState() => _TaskCategoryAllPageState();
}

class _TaskCategoryAllPageState extends ConsumerState<TaskCategoryAllPage> {
  int _pageIndex = 0;
  List<dynamic> _categories = [];
  bool _isLoading = false;
  bool _hasMore = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100 && !_isLoading && _hasMore) {
        _fetchCategories();
      }
    });
  }

  Future<void> _fetchCategories() async {
    if (_isLoading || !_hasMore) return;
    setState(() { _isLoading = true; });
    final response = await TaskCategoryApis.instance.getAllByPage({
      'pageIndex': _pageIndex,
      'size': 20,
    });
    final items = response['items'] as List<dynamic>? ?? [];
    setState(() {
      _categories.addAll(items);
      _isLoading = false;
      _hasMore = items.length == 20;
      if (_hasMore) _pageIndex++;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('全部分类'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_categories.isEmpty && _isLoading) {
      return _buildLoadingGrid();
    }
    if (_categories.isEmpty) {
      return Center(child: Text('暂无分类'));
    }
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _categories.clear();
          _pageIndex = 0;
          _hasMore = true;
        });
        await _fetchCategories();
      },
      child: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        itemCount: _categories.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < _categories.length) {
            final taskCategory = Map<String, dynamic>.from(_categories[index]);
            return _buildCategoryCard(context, taskCategory);
          } else {
            // 加载更多loading
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
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
                taskCategory['name'] ?? '',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 