import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/SearchHeaderWidget.dart';

class HomeSearchHeaderWidget extends StatelessWidget {
  const HomeSearchHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SearchHeaderWidget(
      onTap: () {
        context.push('/home-search');
      },
      hintText: '大家都在搜：如何坚持晨跑',
    );
  }
}