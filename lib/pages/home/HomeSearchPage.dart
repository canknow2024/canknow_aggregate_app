import 'package:canknow_aggregate_app/apis/system/HotSearchApis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

final hotSearchProvider = FutureProvider.autoDispose<List<String>>((ref) async {
  final result = await HotSearchApis.instance.getAll(null);
  final items = result['items'] as List<dynamic>? ?? [];
  return items.map((e) => e['title']?.toString() ?? '').where((e) => e.isNotEmpty).toList();
});

class HomeSearchPage extends ConsumerWidget {
  const HomeSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                        hintText: 'search tasks hint'.tr(),
                        hintStyle: TextStyle(color: Colors.grey),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      style: const TextStyle(fontSize: 16),
                      onSubmitted: (value) {
                        final keyword = value.trim();
                        if (keyword.isNotEmpty) {
                          context.push('/task/list', extra: {
                            'title': 'search results'.tr(),
                            'filterParams': {'keyword': keyword},
                          });
                        }
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
                        context.push('/task/list', extra: {
                          'title': 'search results'.tr(),
                          'filterParams': {'keyword': tag},
                        });
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