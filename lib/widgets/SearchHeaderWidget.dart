import 'package:flutter/material.dart';

class SearchHeaderWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final String hintText;
  const SearchHeaderWidget({Key? key, this.onTap, this.hintText = '大家都在搜：如何坚持晨跑'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      color: Theme.of(context).cardTheme.color,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).inputDecorationTheme.fillColor,
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Theme.of(context).iconTheme.color, size: 22),
                    const SizedBox(width: 8),
                    Text(hintText, style: Theme.of(context).inputDecorationTheme.hintStyle),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 