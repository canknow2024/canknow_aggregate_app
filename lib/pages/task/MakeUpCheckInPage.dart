import 'package:flutter/material.dart';
import 'package:canknow_aggregate_app/apis/task/UserTaskApis.dart';
import 'package:intl/intl.dart';

class MakeUpCheckInPage extends StatefulWidget {
  const MakeUpCheckInPage({Key? key}) : super(key: key);

  @override
  State<MakeUpCheckInPage> createState() => _MakeUpCheckInPageState();
}

class _MakeUpCheckInPageState extends State<MakeUpCheckInPage> {
  bool _loading = true;
  bool _error = false;
  List<dynamic> _items = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _loading = true;
      _error = false;
    });
    try {
      final res = await UserTaskApis.instance.getMakeUpCheckInUserTasks();
      setState(() {
        _items = res['items'] ?? [];
        _loading = false;
      });
    }
    catch (e) {
      setState(() {
        _error = true;
        _loading = false;
      });
    }
  }

  Future<void> _makeUpCheckIn(int userTaskId, String date) async {
    try {
      await UserTaskApis.instance.makeUpCheckIn({
        'userTaskId': userTaskId,
        'date': date,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('补卡成功')),
      );
      _fetchData();
    }
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('补卡失败: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('任务补卡'),
      ),
      body: SafeArea(
        child: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('加载失败'),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _fetchData,
                        child: const Text('重试'),
                      ),
                    ],
                  ),
                )
              : _items.isEmpty
                  ? const Center(child: Text('暂无待补卡任务'))
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Text(
                                '哎呀，有任务漏卡了！',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8),
                              Text(
                                '别担心，可以通过以下方式进行补卡。',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        ..._items.map((item) {
                          final task = item['task'] ?? {};
                          final userTaskId = item['userTaskId'];
                          final date = item['date'];
                          final adMakeUpRemain = item['adMakeUpRemain'] ?? 0;
                          final taskName = task['name'] ?? '未知任务';
                          final dateStr = date != null ? DateFormat('yyyy-MM-dd').format(DateTime.parse(date)) : '';
                          final canMakeUp = adMakeUpRemain > 0;
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(taskName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  const SizedBox(height: 8),
                                  Text('漏卡日期: $dateStr', style: const TextStyle(color: Colors.orange)),
                                  const SizedBox(height: 8),
                                  Text('今日广告补卡机会剩余: $adMakeUpRemain'),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: canMakeUp
                                              ? () => _makeUpCheckIn(userTaskId, date)
                                              : null,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: canMakeUp ? Theme.of(context).primaryColor : Colors.grey,
                                          ),
                                          child: Text(canMakeUp ? '通过广告补卡' : '今日广告次数已用完'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
      ),
    );
  }
}
