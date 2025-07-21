import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'HomeSearchHeaderWidget.dart';
import 'MyFootprintWidget.dart';
import 'TaskCategoryGridWidget.dart';
import 'HotRecommendWidget.dart';
import 'package:canknow_aggregate_app/utils/UpdateChecker.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UpdateChecker.checkUpdate(context, showNoUpdateToast: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 头部搜索
            const HomeSearchHeaderWidget(),
            
            // 主要内容区域
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    
                    // 我的足迹
                    const MyFootprintWidget(),
                    const SizedBox(height: 16),
                    
                    // 任务分类
                    const TaskCategoryGridWidget(),
                    const SizedBox(height: 16),
                    
                    // 热门推荐
                    const HotRecommendWidget(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 