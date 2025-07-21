import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../routes/appRoutes.dart';
import 'TaskCategorySelector.dart';
import 'TaskCardStack.dart';
import 'NewWorldSection.dart';

class DoPage extends ConsumerStatefulWidget {
  const DoPage({super.key});

  @override
  ConsumerState<DoPage> createState() => _DoPageState();
}

class _DoPageState extends ConsumerState<DoPage> {
  int? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('开干啦!'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateTaskOptions(context);
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 分类选择器
            TaskCategorySelector(
              selectedCategoryId: _selectedCategoryId,
              onCategorySelected: (cat) {
                setState(() {
                  _selectedCategoryId = cat['id'];
                });
              },
            ),
            SizedBox(height: 20,),
            TaskCardStack(taskCategoryId: _selectedCategoryId),
            SizedBox(height: 60,),
            // 打卡新世界静态区
            NewWorldSection(),
          ],
        ),
      ),
    );
  }

  void _showCreateTaskOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'choose create method'.tr(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildCreateOption(
                  context,
                  icon: Icons.dashboard_outlined,
                  title: 'create from template'.tr(),
                  subtitle: 'choose from preset templates'.tr(),
                  onTap: () async {
                    Navigator.pop(context);
                    await GoRouter.of(context).push(AppRoutes.templateSelect);
                    ref.invalidate(userTaskListProvider);
                  },
                ),
                const SizedBox(height: 12),
                _buildCreateOption(
                  context,
                  icon: Icons.edit_outlined,
                  title: 'create directly'.tr(),
                  subtitle: 'custom create new task'.tr(),
                  onTap: () async {
                    Navigator.pop(context);
                    await GoRouter.of(context).push(AppRoutes.createTask);
                    ref.invalidate(userTaskListProvider);
                  },
                ),
                const SizedBox(height: 12),
                _buildCreateOption(
                  context,
                  icon: Icons.auto_awesome,
                  title: 'ai create'.tr(),
                  subtitle: 'ai generate task'.tr(),
                  onTap: () async {
                    Navigator.pop(context);
                    await GoRouter.of(context).push(AppRoutes.createTaskByAI);
                    ref.invalidate(userTaskListProvider);
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreateOption(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Theme.of(context).unselectedWidgetColor,),
            ],
          ),
        ),
      ),
    );
  }
}
