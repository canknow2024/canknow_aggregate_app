import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../apis/task/TaskApis.dart';
import '../../utils/ToastUtil.dart';
import 'package:intl/intl.dart';
import '../../apis/task/TaskTemplateApis.dart';

class TaskTemplateSelectPage extends ConsumerStatefulWidget {
  const TaskTemplateSelectPage({Key? key}) : super(key: key);

  @override
  ConsumerState<TaskTemplateSelectPage> createState() => _TaskTemplateSelectPageState();
}

class _TaskTemplateSelectPageState extends ConsumerState<TaskTemplateSelectPage> with SingleTickerProviderStateMixin {
  bool _loading = false;
  int? _pendingTemplateId;
  int _pageIndex = 0;
  int _pageSize = 20;
  List<dynamic> taskTemplates = [];
  int _totalCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchTemplates();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchTemplates() async {
    setState(() { _loading = true; });
    try {
      final res = await TaskTemplateApis.instance.getAllByPage({
        'pageIndex': _pageIndex,
        'pageSize': _pageSize,
      });
      final items = res['items'] as List<dynamic>? ?? [];
      taskTemplates = items;
      _totalCount = res['totalCount'] ?? 0;
    }
    catch (e) {
      ToastUtil.showError('获取模版失败: $e');
    }
    finally {
      setState(() { _loading = false; });
    }
  }

  void _onReuseTap(int taskTemplateId) async {
    _pendingTemplateId = taskTemplateId;

    DateTime? picked = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        DateTime? selectedDate = DateTime.now();
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('请选择开始日期', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(selectedDate == null ? '未选择' : DateFormat('yyyy-MM-dd').format(selectedDate!)),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () async {
                            final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedDate ?? DateTime.now(),
                              firstDate: DateTime.now().subtract(const Duration(days: 30)),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                            );
                            if (pickedDate != null) {
                              setModalState(() {
                                selectedDate = pickedDate;
                              });
                            }
                          },
                          child: const Text('选择日期'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(selectedDate);
                        },
                        child: const Text('确认'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
    if (picked != null) {
      _createTaskFromTemplate(taskTemplateId, picked);
    }
  }

  Future<void> _createTaskFromTemplate(int taskTemplateId, DateTime startDate) async {
    setState(() { _loading = true; });
    try {
      final result = await TaskApis.instance.createFromTemplate({
        'taskTemplateId': taskTemplateId,
        'startDate': DateFormat('yyyy-MM-dd').format(startDate),
      });
      if (mounted) {
        Navigator.of(context).pop(true);
        ToastUtil.showSuccess('创建成功');
      }
    }
    catch (e) {
      ToastUtil.showError('创建失败: $e');
    }
    finally {
      setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('选择任务模版')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: taskTemplates.length,
              itemBuilder: (context, idx) {
                final taskTemplate = taskTemplates[idx];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.network(
                              taskTemplate['taskCategory']['icon'],
                              width: 28,
                              height: 28,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.category, size: 32),
                            ),
                            const SizedBox(width: 8),
                            Text(taskTemplate['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(taskTemplate['description'] ?? '', style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _loading ? null : () => _onReuseTap(taskTemplate['id']),
                            child: const Text('一键复用'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}