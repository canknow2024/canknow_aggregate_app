import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import '../../apis/system/SettingApis.dart';
import '../../utils/ToastUtil.dart';

class UserAgreementPage extends StatefulWidget {
  @override
  _UserAgreementPageState createState() => _UserAgreementPageState();
}

class _UserAgreementPageState extends State<UserAgreementPage> {
  String _content = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadServiceAgreement();
  }

  Future<void> _loadServiceAgreement() async {
    final response = await SettingApis.instance.getServiceAgreement();
    setState(() {
      _content = response['value'];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('用户协议'),),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(),)
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: HtmlWidget(
                _content,
                textStyle: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                ),
                customStylesBuilder: (element) {
                  if (element.localName == 'p') {
                    return {'margin': '0 0 16px 0'};
                  }
                  if (element.localName == 'h1' || 
                      element.localName == 'h2' || 
                      element.localName == 'h3') {
                    return {
                      'margin': '24px 0 16px 0',
                      'font-weight': 'bold',
                    };
                  }
                  return null;
                },
              ),
            ),
    );
  }
} 