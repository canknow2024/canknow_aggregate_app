import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      setState(() {
        _version = 'v' + info.version;
      });
    }
    catch (e) {
      setState(() {
        _version = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('关于我们')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // logo
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/logo/logo/light.png',
                  width: 80,
                  height: 80,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '蜗牛打卡',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(_version, style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 24),
              Text(
                '本应用由Canknow团队开发，致力于为用户提供高效的任务管理与聚合体验。\n\n如有建议或合作意向，欢迎联系我们：\nEmail: support@canknow.com',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}