import 'package:flutter/material.dart';
import '../../theme/AppTheme.dart';

class NewWorldSection extends StatelessWidget {
  const NewWorldSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('打卡新世界', style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          )),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppTheme.componentSpan,
            crossAxisSpacing: AppTheme.componentSpan,
            childAspectRatio: 2.2,
            children: const [
              _NewWorldCard(icon: Icons.emoji_events, title: '夺金挑战', subtitle: '组队赢奖金'),
              _NewWorldCard(icon: Icons.sports_martial_arts, title: '好友约战', subtitle: '看看谁更强'),
              _NewWorldCard(icon: Icons.map, title: '冒险之旅', subtitle: '解锁新成就'),
              _NewWorldCard(icon: Icons.family_restroom, title: '亲密互动', subtitle: '爱需要陪伴'),
            ],
          ),
        ],
      ),
    );
  }
}

class _NewWorldCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _NewWorldCard({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius)),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.contentPadding),
        child: Row(
          children: [
            Icon(icon, size: 32, color: Colors.orangeAccent),
            const SizedBox(width: AppTheme.componentSpan),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: Theme.of(context).textTheme.labelSmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 