import 'package:flutter/material.dart';
import '../../apis/task/UserTaskApis.dart';
import '../../theme/AppTheme.dart';

class DoTaskCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback? onCheckInSuccess;
  const DoTaskCard({Key? key, required this.item, this.onCheckInSuccess}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final task = item['task'] ?? {};

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF6FC3FF), Color(0xFFA6E3FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(task['name'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: AppTheme.componentSpan),
            Text('已连续坚持 ${item['checkInCount']} 天', style: const TextStyle(fontSize: AppTheme.fontSizeMedium, color: Colors.white70)),
            const SizedBox(height: 24),
            item['hasCheckInToday'] ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Text('今日已打卡', style: TextStyle(color: Color(0xFF3B82F6), fontWeight: FontWeight.bold)),
                  ) : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF3B82F6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: AppTheme.fontSizeLarge),
                    ),
                    onPressed: () async {
                      await UserTaskApis.instance.checkIn(item['id']);
                      if (onCheckInSuccess != null) onCheckInSuccess!();
                    },
                    child: const Text('去打卡'),
                  ),
          ],
        ),
      ),
    );
  }
} 