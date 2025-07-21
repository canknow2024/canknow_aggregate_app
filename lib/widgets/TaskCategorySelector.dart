import 'package:canknow_aggregate_app/theme/AppTheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../apis/task/TaskCategoryApis.dart';

final taskCategoryProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final response = await TaskCategoryApis.instance.getAll(null);
  return response['items'] as List<dynamic>? ?? [];
});

class TaskCategorySelector extends ConsumerStatefulWidget {
  final Function(dynamic) onCategorySelected;
  final int? initialValue;

  const TaskCategorySelector({
    super.key,
    required this.onCategorySelected,
    this.initialValue,
  });

  @override
  ConsumerState<TaskCategorySelector> createState() => _TaskCategorySelectorState();
}

class _TaskCategorySelectorState extends ConsumerState<TaskCategorySelector> {
  String? _selectedCategoryName;

  @override
  void initState() {
    super.initState();

    if (widget.initialValue != null) {
      Future.microtask(() async {
        final container = ProviderContainer();
        final categoriesAsync = await container.read(taskCategoryProvider.future);
        final match = categoriesAsync.firstWhere(
          (e) => (e as Map<String, dynamic>)['id'] == widget.initialValue,
          orElse: () => null,
        );
        if (match != null) {
          setState(() {
            _selectedCategoryName = (match as Map<String, dynamic>)['name'];
          });
        }
      });
    }
  }

  Future<void> _showCategoryPicker(BuildContext context) async {
    final selectedCategory = await showModalBottomSheet<dynamic>(
      context: context,
      builder: (BuildContext context) {
        return Consumer(
          builder: (context, ref, _) {
            final categories = ref.watch(taskCategoryProvider);
            return categories.when(
              data: (data) {
                if (data.isEmpty) {
                  return const SafeArea(child: Center(child: Text('暂无分类')));
                }
                return SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: data.map((category) {
                      final map = category as Map<String, dynamic>;
                      return ListTile(
                        title: Center(child: Text(map['name'])),
                        onTap: () => Navigator.of(context).pop(map),
                      );
                    }).toList(),
                  ),
                );
              },
              loading: () => const Center(child: CupertinoActivityIndicator()),
              error: (err, stack) => SafeArea(child: Center(child: Text('加载失败: $err'))),
            );
          },
        );
      },
    );

    if (selectedCategory != null) {
      setState(() {
        _selectedCategoryName = selectedCategory['name'];
      });
      widget.onCategorySelected(selectedCategory);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildTappableField(
      text: _selectedCategoryName ?? '请选择分类',
      onTap: () => _showCategoryPicker(context),
      validator: () {
        if (_selectedCategoryName == null) {
          return '请选择任务分类';
        }
        return null;
      },
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
                padding: EdgeInsets.symmetric(vertical: AppTheme.contentPadding, horizontal: AppTheme.contentPadding),
                decoration: BoxDecoration(
                  border: Border.all(color: state.hasError ? Theme.of(context).colorScheme.error : Theme.of(context).inputDecorationTheme.enabledBorder!.borderSide.color),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(text, style: Theme.of(context).inputDecorationTheme.hintStyle),
                    const Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
            ),
            if (state.hasError) Padding(
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
} 