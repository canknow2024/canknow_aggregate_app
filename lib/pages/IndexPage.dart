import 'package:canknow_aggregate_app/pages/home/HomePage.dart';
import 'package:canknow_aggregate_app/pages/me/MePage.dart';
import 'package:canknow_aggregate_app/pages/do/DoPage.dart';
import 'package:flutter/material.dart';
import 'discover/DiscoverPage.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int _currentIndex = 0;

  Widget get _currentPage {
    if (_currentIndex == 0) {
      return HomePage();
    }
    else if (_currentIndex == 1) {
      return DiscoverPage();
    }
    else if (_currentIndex == 2) {
      return DoPage();
    }
    else {
      return MePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/bottomNavigation/home.png',
              width: 24,
              height: 24,
            ),
            activeIcon: Image.asset(
              'assets/images/bottomNavigation/home-active.png',
              width: 24,
              height: 24,
            ),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/bottomNavigation/discovery.png',
              width: 24,
              height: 24,
            ),
            activeIcon: Image.asset(
              'assets/images/bottomNavigation/discovery-active.png',
              width: 24,
              height: 24,
            ),
            label: '探索',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/bottomNavigation/do.png',
              width: 24,
              height: 24,
            ),
            activeIcon: Image.asset(
              'assets/images/bottomNavigation/do-active.png',
              width: 24,
              height: 24,
            ),
            label: '开干了',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/bottomNavigation/me.png',
              width: 24,
              height: 24,
            ),
            activeIcon: Image.asset(
              'assets/images/bottomNavigation/me-active.png',
              width: 24,
              height: 24,
            ),
            label: '我的',
          ),
        ],
      ),
    );
  }
} 