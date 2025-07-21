import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../utils/ToastUtil.dart';

class TaskSearchPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<TaskSearchPage> createState() => _TaskSearchPageState();
}

class _TaskSearchPageState extends ConsumerState<TaskSearchPage> {
  final TextEditingController _controller = TextEditingController();

  void _onSearch() {
    final keyword = _controller.text.trim();
    if (keyword.isNotEmpty) {
      context.push('/task/list', extra: {
        'title': '搜索结果',
        'filterParams': {'keyword': keyword},
      });
    } else {
      ToastUtil.showWarning('请输入关键词');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('任务搜索'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: '请输入任务关键词',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _onSearch(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _onSearch,
                  child: const Text('搜索'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}