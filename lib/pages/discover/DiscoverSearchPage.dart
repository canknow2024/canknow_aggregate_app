import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../apis/system/HotSearchApis.dart';

final hotSearchProvider = FutureProvider.autoDispose<List<String>>((ref) async {
  final result = await HotSearchApis.instance.getAll(null);
  final items = result['items'] as List<dynamic>? ?? [];
  return items.map((e) => e['title']?.toString() ?? '').where((e) => e.isNotEmpty).toList();
});

class DiscoverSearchPage extends ConsumerStatefulWidget {
  const DiscoverSearchPage({Key? key}) : super(key: key);

  @override
  ConsumerState<DiscoverSearchPage> createState() => _DiscoverSearchPageState();
}

class _DiscoverSearchPageState extends ConsumerState<DiscoverSearchPage> {
  @override
  Widget build(BuildContext context) {
    final asyncHotTags = ref.watch(hotSearchProvider);
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(''),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: '搜索任务、专题或用户',
                        hintStyle: TextStyle(color: Colors.grey),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      style: const TextStyle(fontSize: 16),
                      onSubmitted: (value) {
                        final keyword = value.trim();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'hot search'.tr() + ':',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: asyncHotTags.when(
              data: (hotTags) => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: hotTags.map((tag) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ActionChip(
                      label: Text(tag),
                      backgroundColor: Colors.white,
                      labelStyle: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
                      onPressed: () {
                      },
                    ),
                  )).toList(),
                ),
              ),
              loading: () => const SizedBox(
                height: 32,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
              error: (e, _) => Text('load failed'.tr() + ': $e'),
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.emoji_objects, color: Colors.amber, size: 48),
                  SizedBox(height: 16),
                  Text(
                    'search input tip'.tr(),
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 