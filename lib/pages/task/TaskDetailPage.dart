import 'package:canknow_aggregate_app/utils/WechatUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluwx/fluwx.dart';
import '../../apis/task/TaskApis.dart';
import '../../theme/AppTheme.dart';
import '../../apis/task/TaskSignUpOrderApis.dart';
import '../../config/AppConfig.dart';
import 'package:alipay_kit_new/alipay_kit.dart';
import '../../utils/ToastUtil.dart';

class TaskDetailPage extends ConsumerStatefulWidget {
  final String id;
  TaskDetailPage({required this.id});

  @override
  ConsumerState<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends ConsumerState<TaskDetailPage> {
  Map<String, dynamic>? task;
  bool loading = true;
  String depositInput = '';
  bool isPaying = false;
  String payError = '';
  int selectedPaymentMethod = 0; // 0:微信 1:支付宝 7:钱包

  // 移除页面常驻支付方式选择UI
  // 保留支付方式列表
  // 引入图片资源（假设assets/images/pay/wechat.png、alipay.png已准备好）
  final List<Map<String, dynamic>> paymentMethods = [
    {'code': 0, 'label': '微信支付', 'iconAsset': 'assets/images/pay/wechat.png'},
    {'code': 1, 'label': '支付宝支付', 'iconAsset': 'assets/images/pay/alipay.png'},
    // 7:钱包，后续如需可继续添加
  ];

  // 新增：弹出支付方式选择ActionSheet
  Future<void> _showPaymentSheet(int orderId) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              const Text('选择支付方式', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              ...paymentMethods.map((m) => ListTile(
                leading: Image.asset(
                  m['iconAsset'],
                  width: 32,
                  height: 32,
                  fit: BoxFit.contain,
                ),
                title: Text(m['label'], style: const TextStyle(fontSize: 16)),
                onTap: () {
                  Navigator.of(context).pop();
                  _payOrder(orderId, m['code']);
                },
              )),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  // 新增：实际支付逻辑，按支付方式调用
  Future<void> _payOrder(int orderId, int paymentMethod) async {
    setState(() { payError = ''; isPaying = true; });
    try {
      final payResult = await TaskSignUpOrderApis.instance.pay({
        'id': orderId,
        'clientId': AppConfig.clientId,
        'paymentMethod': paymentMethod,
        'paymentScene': 2, // APP
      });
      if (paymentMethod == 0) {
        // 微信支付逻辑
        Payment payment = new Payment(
          appId: payResult['appId'],
          partnerId: payResult['mchId'],
          prepayId: payResult['prepayId'],
          packageValue: payResult['packageValue'],
          nonceStr: payResult['nonceStr'],
          timestamp: int.parse(payResult['timeStamp']),
          sign: payResult['paySign'],
        );
        try {
          await WechatUtil.pay(payment);
          _showPaySuccess();
        }
        catch (e) {
          setState(() { payError = '微信支付失败(${e})'; });
        }
      }
      else if (paymentMethod == 1) {
        // 支付宝支付逻辑
        try {
          final String orderStr = payResult['orderStr'] ?? '';

          if (orderStr.isEmpty) {
            setState(() { payError = '支付宝支付参数异常'; });
            return;
          }
          await AlipayKitPlatform.instance.pay(orderInfo: orderStr);
          ToastUtil.showSuccess('支付成功');
          _showPaySuccess();
        }
        catch (e) {
          setState(() { payError = '支付宝支付异常(${e.toString()})'; });
        }
      }
      else {
        setState(() { payError = '暂不支持该支付方式'; });
      }
    }
    catch (e) {
      setState(() { payError = '支付失败：' + (e.toString()); });
    }
    finally {
      setState(() { isPaying = false; });
    }
  }

  // 修改：点击支付按钮时先创建订单，成功后弹出ActionSheet
  Future<void> _payAndJoinTask() async {
    setState(() { payError = ''; });
    final amount = double.tryParse(depositInput);
    if (amount == null || amount < 0.01) {
      setState(() { payError = '最小承诺金为0.01元'; });
      return;
    }
    if (isPaying) return;
    setState(() { isPaying = true; });
    try {
      // 1. 创建订单
      final order = await TaskSignUpOrderApis.instance.create({
        'taskId': int.tryParse(widget.id),
        'amount': amount,
      });
      final orderId = order['id'];
      // 2. 弹出支付方式选择
      _showPaymentSheet(orderId);
    }
    catch (e) {
      setState(() { payError = '订单创建失败：' + (e.toString()); });
    }
    finally {
      setState(() { isPaying = false; });
    }
  }

  void _showPaySuccess() {
    if (mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('支付成功'),
          content: Text('已成功支付承诺金并加入任务！'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).maybePop();
              },
              child: Text('确定'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTask();
  }

  Future<void> _fetchTask() async {
    setState(() { loading = true; });
    try {
      final result = await TaskApis.instance.get({'id': widget.id});
      task = result;
      depositInput = (task?['deposit']?.toString() ?? '');
    }
    catch (e) {
    }
    setState(() { loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('任务详情')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (task == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('任务详情')),
        body: const Center(child: Text('未找到任务')), 
      );
    }
    final name = task?['name'] ?? '';
    final cover = task?['covers'] ?? '';
    final category = task?['taskCategoryName'] ?? '';
    final description = task?['description'] ?? '';
    final continuallyDays = task?['continuallyDays']?.toString() ?? '';
    final deposit = task?['deposit']?.toString() ?? '';
    final participantCount = task?['participantCount']?.toString() ?? '';
    final recommend = task?['recommend'] == true;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 24,
          ),
          children: [
            Container(
              width: double.infinity,
              height: 180,
              child: cover.isNotEmpty ? Image.network(
                cover,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover) : const Center(
                child: Icon(Icons.directions_run, size: 48, color: Colors.amber),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(AppTheme.contentPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: AppTheme.componentSpan),
                    child: Text(name, style: Theme.of(context).textTheme.titleLarge),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: AppTheme.componentSpan),
                    child: Text('分类：$category', style: Theme.of(context).textTheme.bodySmall),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: AppTheme.componentSpan),
                    child: Text(description, style: Theme.of(context).textTheme.bodySmall),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppTheme.contentPadding),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2,
                children: [
                  _infoCard('持续周期', '$continuallyDays 天'),
                  _infoCard('打卡频率', task?['openClockInReminder'] == true ? '有提醒' : '无提醒'),
                  _infoCard('承诺金', deposit.isNotEmpty ? '¥ $deposit' : ''),
                  _infoCard('当前参与人数', '$participantCount 人'),
                ],
              ),
            ),
            if (recommend) Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    const Icon(Icons.verified, color: Colors.grey, size: 20),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('由 官方推荐', style: TextStyle(fontSize: 13, color: Colors.grey)),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).dividerTheme.color!,
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('我的承诺金', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('¥', style: TextStyle(fontSize: 20, color: Colors.blue)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: '请输入金额',
                              isDense: true,
                              errorText: payError.isNotEmpty ? payError : null,
                            ),
                            controller: TextEditingController.fromValue(
                              TextEditingValue(
                                text: depositInput,
                                selection: TextSelection.collapsed(offset: depositInput.length),
                              ),
                            ),
                            onChanged: (v) => setState(() => depositInput = v),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // 移除_buildPaymentSelector()调用
                    // _buildPaymentSelector(),
                    const SizedBox(height: 8),
                    Text('投入承诺金，任务成功后将全额返还。若任务失败，承诺金将不予退回。', style: Theme.of(context).textTheme.labelSmall,),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppTheme.componentSpan),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: isPaying ? null : _payAndJoinTask,
              child: isPaying ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('支付承诺金并加入任务'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoCard(String title, String value) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
          border: Border.all(
            color: Theme.of(context).dividerTheme.color!,
            width: 1,
          )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: AppTheme.componentSpan),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}