import 'package:canknow_aggregate_app/apis/interest/InterestApis.dart';
import 'package:canknow_aggregate_app/apis/user/UserInterestApis.dart';
import 'package:canknow_aggregate_app/routes/appRoutes.dart';
import 'package:canknow_aggregate_app/utils/ToastUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/SessionStore.dart';

class InterestSettingPage extends ConsumerStatefulWidget {
  const InterestSettingPage({super.key});

  @override
  ConsumerState<InterestSettingPage> createState() => _InterestSettingPageState();
}

class _InterestSettingPageState extends ConsumerState<InterestSettingPage> {
  List<Map<String, dynamic>> _interests = [];
  Set<int> _selectedInterestIds = {};
  bool _loading = true;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _loading = true;
      _errorMsg = null;
    });
    try {
      // 获取所有兴趣
      final interestRes = await InterestApis.instance.getAll(null);
      final interestItems = (interestRes['items'] ?? []) as List;
      _interests = interestItems.map<Map<String, dynamic>>((e) => {
        'id': e['id'],
        'name': e['name'],
        'icon': e['icon'],
      }).toList();
      // 获取用户已选兴趣
      final userInterestRes = await UserInterestApis.instance.getAll(null);
      final userInterestItems = (userInterestRes['items'] ?? []) as List;
      _selectedInterestIds = userInterestItems.map<int>((e) => e['interestId'] as int).toSet();
    }
    catch (e) {
      setState(() {
        _errorMsg = '加载兴趣数据失败: $e';
      });
    }
    finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _toggleInterest(int interestId) {
    setState(() {
      if (_selectedInterestIds.contains(interestId)) {
        _selectedInterestIds.remove(interestId);
      }
      else {
        _selectedInterestIds.add(interestId);
      }
    });
  }

  bool get _canComplete => _selectedInterestIds.length >= 3;

  Future<void> _onComplete() async {
    if (!_canComplete) {
      ToastUtil.showWarning('请至少选择 3 项兴趣。');
      return;
    }
    try {
      await UserInterestApis.instance.create({
        'interestIds': _selectedInterestIds.toList(),
      });
      ToastUtil.showSuccess('保存成功！');

      ref.read(sessionStore.notifier).setUserDataInitialized();
      GoRouter.of(context).replace(AppRoutes.home);
    }
    catch (e) {
      ToastUtil.showError('保存失败: $e');
    }
  }

  void _onSkip() {
    GoRouter.of(context).go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMsg != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_errorMsg != null) {
          ToastUtil.showError(_errorMsg!);
          setState(() {
            _errorMsg = null;
          });
        }
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('选择您的兴趣'),
        actions: [
          TextButton(
            onPressed: _onSkip,
            child: Text('跳过', style: TextStyle(color: Theme.of(context).primaryColor,),),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '告诉我们您喜欢什么?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '选择您感兴趣的领域，我们会为您推荐更合适的任务。(可多选, 至少选3项)',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5,
                ),
                itemCount: _interests.length,
                itemBuilder: (context, index) {
                  final interest = _interests[index];
                  final isSelected = _selectedInterestIds.contains(interest['id']);
                  return GestureDetector(
                    onTap: () => _toggleInterest(interest['id']),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).dividerTheme.color!,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          interest['icon'] != null && interest['icon'].toString().isNotEmpty ? Image.network(
                            interest['icon'],
                            width: 40,
                            height: 40,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 32, color: Colors.grey),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const SizedBox(
                                width: 40,
                                height: 40,
                                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                              );
                            },
                          ) : const Icon(Icons.image, size: 32, color: Colors.grey),
                          const SizedBox(height: 8),
                          Text(interest['name'] ?? '', style: Theme.of(context).textTheme.bodyMedium,),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ElevatedButton(
            onPressed: _canComplete ? _onComplete : null,
            child: Text(
              _canComplete ? '完成' : '请至少选择 3 项',
            ),
          ),
        ),
      ),
    );
  }
}