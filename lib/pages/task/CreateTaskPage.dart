import 'package:canknow_aggregate_app/apis/task/TaskApis.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../theme/AppTheme.dart';
import '../../utils/ToastUtil.dart';
import '../../widgets/TaskCategorySelector.dart';
import 'AICreateTaskPage.dart';

class CreateTaskPage extends ConsumerStatefulWidget {
  const CreateTaskPage({super.key});

  @override
  ConsumerState<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends ConsumerState<CreateTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _taskNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _depositController = TextEditingController();
  final _continuallyDaysController = TextEditingController();

  int? _taskCategoryId;
  DateTime? _startDate;
  TimeOfDay? _reminderTime;
  bool _openClockInReminder = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _reminderTime = const TimeOfDay(hour: 20, minute: 0);
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _descriptionController.dispose();
    _depositController.dispose();
    _continuallyDaysController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _reminderTime) {
      setState(() {
        _reminderTime = picked;
      });
    }
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final data = {
        'name': _taskNameController.text,
        'description': _descriptionController.text,
        'taskCategoryId': _taskCategoryId,
        'deposit': double.tryParse(_depositController.text) ?? 0.0,
        'startDate': _startDate != null ? DateFormat('yyyy-MM-dd').format(_startDate!) : null,
        'continuallyDays': int.tryParse(_continuallyDaysController.text) ?? 0,
        'openClockInReminder': _openClockInReminder,
        'reminderTime': _reminderTime != null ? '${_reminderTime!.hour.toString().padLeft(2, '0')}:${_reminderTime!.minute.toString().padLeft(2, '0')}' : null,
      };

      if (_openClockInReminder && _reminderTime != null) {
        data['reminderTime'] = '${_reminderTime!.hour.toString().padLeft(2, '0')}:${_reminderTime!.minute.toString().padLeft(2, '0')}';
      }

      try {
        await TaskApis.instance.create(data);
        ToastUtil.show('创建成功');
        Navigator.of(context).pop(true); // Pop with a result to indicate success
      }
      catch (e) {
        ToastUtil.show('创建失败: $e');
      }
      finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        title: const Text('创建新任务'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveTask,
            child: _isLoading
                ? const CupertinoActivityIndicator()
                : const Text('保存', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.smart_toy_outlined),
                    label: const Text('AI创建'),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AICreateTaskPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('任务名称*'),
                TextFormField(
                  controller: _taskNameController,
                  decoration: const InputDecoration(
                    hintText: '例如: 每天学习英语1小时',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入任务名称';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('任务描述'),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: '详细描述一下你的任务吧 (可选)',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('任务分类'),
                TaskCategorySelector(
                  initialValue: _taskCategoryId,
                  onCategorySelected: (category) {
                    setState(() {
                      _taskCategoryId = category['id'];
                    });
                  },
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('承诺金 (元)*'),
                TextFormField(
                  controller: _depositController,
                  decoration: const InputDecoration(
                    hintText: '例如: 10',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入承诺金';
                    }
                    if (double.tryParse(value) == null) {
                      return '请输入有效的数字';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('开始日期*'),
                _buildTappableField(
                  text: _startDate == null ? '请选择' : DateFormat('yyyy-MM-dd').format(_startDate!),
                  onTap: () => _selectDate(context),
                  validator: () {
                    if (_startDate == null) {
                      return '请选择开始日期';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('持续天数*'),
                TextFormField(
                  controller: _continuallyDaysController,
                  decoration: const InputDecoration(
                    hintText: '例如: 30',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入持续天数';
                    }
                    if (int.tryParse(value) == null || int.parse(value) <= 0) {
                      return '请输入有效的天数';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                _buildSwitchTile('开启打卡提醒', _openClockInReminder, (value) {
                  setState(() {
                    _openClockInReminder = value;
                  });
                }),
                if (_openClockInReminder) ...[
                  const SizedBox(height: 24),
                  _buildSectionTitle('提醒时间'),
                  _buildTappableField(
                    text: _reminderTime == null ? '请选择' : _reminderTime!.format(context),
                    onTap: () => _selectTime(context),
                    validator: () {
                      if (_openClockInReminder && _reminderTime == null) {
                        return '请选择提醒时间';
                      }
                      return null;
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _buildTappableField({required String text, required VoidCallback onTap, String? Function()? validator}) {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: AppTheme.contentPadding, horizontal: AppTheme.contentPadding),
                decoration: BoxDecoration(
                  border: Border.all(color: state.hasError ? Theme.of(context).colorScheme.error : Theme.of(context).inputDecorationTheme.enabledBorder!.borderSide.color),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(text, style: Theme.of(context).inputDecorationTheme.hintStyle),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                child: Text(
                  state.errorText!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
                ),
              ),
          ],
        );
      },
      validator: (_) => validator?.call(),
    );
  }

  Widget _buildSwitchTile(String title, bool value, ValueChanged<bool> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.contentPadding, vertical: AppTheme.contentPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        border: Border.all(color: Theme.of(context).inputDecorationTheme.enabledBorder!.borderSide.color)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).inputDecorationTheme.hintStyle),
          SizedBox(
            height: 16,
            child: CupertinoSwitch(
              value: value,
              onChanged: onChanged,
            ),
          )
        ],
      ),
    );
  }
}
