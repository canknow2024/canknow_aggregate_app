import 'package:canknow_aggregate_app/config/JConfig.dart';
import 'package:jverify/jverify.dart';

class JverifyPlugin {
  static final jverify = Jverify();

  static void setCustomUI() {
    final uiConfig = JVUIConfig();

    uiConfig.logoWidth = 80;
    uiConfig.logoHeight = 80;
    uiConfig.logoHidden = true;

    // 手机号
    uiConfig.numberColor = 0xFF222222;
    uiConfig.numberSize = 22;

    // 登录按钮
    uiConfig.logBtnText = "本机号码一键登录";
    uiConfig.logBtnTextColor = 0xFFFFFFFF;
    uiConfig.logBtnHeight = 48;
    uiConfig.logBtnWidth = 240;

    // 协议栏
    uiConfig.privacyOffsetX = 32;
    uiConfig.privacyState = true;
    uiConfig.clauseBaseColor = 0xFF999999; // 普通文字颜色
    uiConfig.clauseColor = 0xFF00BFAE;     // 协议高亮色

    // 关闭按钮

    // 其他可选属性
    // uiConfig.navColor = 0xFFFFFFFF;
    uiConfig.navHidden = true;
    uiConfig.navText = "手机号一键登录";
    uiConfig.navReturnBtnHidden = true;
    // uiConfig.navTextColor = 0xFF222222;

    JverifyPlugin.jverify.setCustomAuthorizationView(false, uiConfig);
  }

  // 只对ios设置有效
  static initialize() {
    jverify.setDebugMode(true);
    jverify.setCollectionAuth(true);
    setCustomUI(); // 新增：初始化时设置自定义UI
    jverify.setup(
        appKey: JConfig.appKey,
        channel: JConfig.channel
    );
  }
}