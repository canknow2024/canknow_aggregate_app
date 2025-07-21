import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../apis/task/TaskApis.dart';
import '../../routes/appRoutes.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:ui';

final hotTasksProvider = FutureProvider.autoDispose((ref) async {
  final result = await TaskApis.instance.getAllByPage({
    'sort': 'participantCount,desc',
    'page': 0,
    'size': 10,
  });
  return result['items'] as List<dynamic>? ?? [];
});

class HotRecommendWidget extends ConsumerStatefulWidget {
  const HotRecommendWidget({super.key});

  @override
  ConsumerState<HotRecommendWidget> createState() => _HotRecommendWidgetState();
}

class _HotRecommendWidgetState extends ConsumerState<HotRecommendWidget> {
  int _currentIndex = 0;

  void _nextCard(int total) {
    setState(() {
      _currentIndex = (_currentIndex + 1) % total;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double cardWidth = MediaQuery.of(context).size.width - 32;
    final double cardHeight = 180;
    final asyncTasks = ref.watch(hotTasksProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'hot recommend'.tr(), style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: cardHeight + 60,
            child: asyncTasks.when(
              data: (tasks) {
                if (tasks.isEmpty) {
                  return _buildPlaceholderCard(cardWidth, cardHeight, showText: true);
                }
                final int total = tasks.length;
                final int showCount = total < 4 ? total : 4;
                List<Widget> stackCards = [];

                for (int i = showCount - 1; i >= 0; i--) {
                  int dataIndex = (_currentIndex + i) % total;
                  double scale = 1 - i * 0.06;
                  double offset = i * 18.0;
                  double opacity = 1 - i * 0.18;
                  stackCards.add(
                    Positioned(
                      top: offset + 12,
                      child: Opacity(
                        opacity: opacity,
                        child: Transform.scale(
                          scale: scale,
                          alignment: Alignment.topCenter,
                          child: _buildHotTaskCard(
                            context,
                            tasks[dataIndex],
                            cardWidth,
                            cardHeight,
                            isPreview: i != 0,
                            onNext: i == 0 ? () => _nextCard(total) : null,
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return Stack(
                  alignment: Alignment.center,
                  children: stackCards,
                );
              },
              loading: () => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: _buildPlaceholderCard(cardWidth, cardHeight, showText: true),
              ),
              error: (e, _) => _buildPlaceholderCard(cardWidth, cardHeight, showText: true),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotTaskCard(
    BuildContext context,
    Map<String, dynamic> task,
    double width,
    double height, {
    bool isPreview = false,
    VoidCallback? onNext,
  }) {
    final String? imageUrl = task['covers'];
    final String title = task['name'] ?? '';
    final String subtitle = task['description'] ?? '';
    final String taskId = task['id'].toString();

    return GestureDetector(
      onTap: isPreview ? null : () {
        context.push('/task/detail/$taskId');
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isPreview ? 20 : 24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isPreview ? 0.08 : 0.12),
              blurRadius: isPreview ? 10 : 18,
              offset: const Offset(0, 8),
            ),
          ],
          color: Colors.white,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // 背景图片
            if (imageUrl != null && imageUrl.isNotEmpty)
              Positioned.fill(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  color: isPreview ? Colors.white.withOpacity(0.7) : null,
                  colorBlendMode: isPreview ? BlendMode.lighten : null,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                  ),
                ),
              ) else Positioned.fill(
                child: Container(color: Colors.grey[200]),
              ),
            // 渐变遮罩
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(isPreview ? 0.2 : 0.5),
                    ],
                  ),
                ),
              ),
            ),
            // 左下角标题和副标题
            Positioned(
              left: 20,
              bottom: 24,
              right: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isPreview ? 15 : 18,
                      fontWeight: FontWeight.bold,
                      shadows: const [
                        Shadow(color: Colors.black54, blurRadius: 4),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isPreview ? 11 : 13,
                      fontWeight: FontWeight.normal,
                      shadows: const [
                        Shadow(color: Colors.black38, blurRadius: 2),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // 右下角按钮（主卡片才有）
            if (!isPreview && onNext != null)
              Positioned(
                right: 20,
                bottom: 20,
                child: GestureDetector(
                  onTap: onNext,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.3), width: 0.5),
                        ),
                        child: Row(
                          children: const [
                            Text(
                              '点击切换',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                shadows: [Shadow(color: Colors.black26, blurRadius: 2)],
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.sync, size: 18, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderCard(double width, double height, {bool showText = false}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(width < height ? 20 : 24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: showText ? Center(
        child: Text(
          '暂无推荐',
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ) : null,
    );
  }
}