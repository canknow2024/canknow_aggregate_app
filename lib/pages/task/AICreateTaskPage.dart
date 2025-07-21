import 'package:flutter/material.dart';
import 'package:canknow_aggregate_app/apis/task/TaskApis.dart';
import '../../utils/ToastUtil.dart';

class AICreateTaskPage extends StatefulWidget {
  const AICreateTaskPage({Key? key}) : super(key: key);

  @override
  State<AICreateTaskPage> createState() => _AICreateTaskPageState();
}

class _AICreateTaskPageState extends State<AICreateTaskPage> {
  final TextEditingController _promoteController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _promoteController.dispose();
    super.dispose();
  }

  Future<void> _createTaskByAI() async {
    final promote = _promoteController.text.trim();
    if (promote.isEmpty) {
      ToastUtil.show('请输入promote内容');
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      await TaskApis.instance.createByAI({'promote': promote});
      ToastUtil.show('AI创建成功');
      Navigator.of(context).pop(true);
    } catch (e) {
      ToastUtil.show('AI创建失败: $e');
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
        title: const Text('AI创建任务'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('请输入你的任务描述（promote）：', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            TextField(
              controller: _promoteController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '例如：帮我生成一个每天背10个单词的任务',
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _createTaskByAI,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('AI创建'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 