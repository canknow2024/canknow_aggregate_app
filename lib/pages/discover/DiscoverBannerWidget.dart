import 'package:canknow_aggregate_app/config/AppConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../apis/system/AdvertisementApis.dart';

class DiscoverBannerWidget extends ConsumerStatefulWidget {
  const DiscoverBannerWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<DiscoverBannerWidget> createState() => _DiscoverBannerWidgetState();
}

class _DiscoverBannerWidgetState extends ConsumerState<DiscoverBannerWidget> {
  List<dynamic> advertisements = [];
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    final result = await AdvertisementApis.instance.getAll(clientId: AppConfig.clientId, scene: 'discover');
    setState(() {
      advertisements = result['items'] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 300,
          alignment: Alignment.center,
          child: advertisements.isEmpty
              ? Text('轮播图 Banner')
              : Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: PageView.builder(
                          itemCount: advertisements.length,
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            final advertisement = advertisements[index];
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                advertisement['cover'] ?? '',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[400],
                                    alignment: Alignment.center,
                                    child: Icon(Icons.broken_image, size: 48, color: Colors.white70),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(advertisements.length, (index) {
                        return Container(
                          width: 8,
                          height: 8,
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index ? Theme.of(context).colorScheme.primary : Colors.grey[400],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
} 