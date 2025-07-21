class WechatConfig {
  // 微信开放平台应用ID
  static const String appId = 'wx7c5c4ede9d2fd367'; // 替换为您的微信AppID

  // 微信开放平台应用密钥
  static const String appSecret = '7558d35a5fabf99bd0cab02039b8002b'; // 替换为您的微信AppSecret

  // iOS通用链接 - 必须配置
  static const String universalLink = 'https://your.univerallink.com/link/'; // 替换为您的通用链接
  
  // 微信登录授权作用域 - 根据实际需求配置
  // snsapi_base: 静默授权，只能获取openid
  // snsapi_userinfo: 弹出授权页面，可以获取用户信息
  static const String scope = 'snsapi_base'; // 改为snsapi_base避免权限问题
  
  // 微信登录状态参数
  static const String state = 'wechat_login_state';
  
  // 微信分享相关配置
  static const String shareTitle = '蜗牛打卡';
  static const String shareDescription = '发现更多精彩内容';
  static const String shareUrl = 'https://your-app-website.com';
  
  // 微信支付相关配置（如果需要）
  static const String partnerId = 'your_partner_id';
  static const String prepayId = 'your_prepay_id';
  static const String packageValue = 'Sign=WXPay';
  static const String nonceStr = 'your_nonce_str';
  static const String timeStamp = 'your_time_stamp';
  static const String sign = 'your_sign';
  
  // 检查配置是否完整
  static bool get isConfigValid {
    return appId != 'wx7c5c4ede9d2fd367' && 
           universalLink != 'https://your.univerallink.com/link/' && 
           appSecret != '7558d35a5fabf99bd0cab02039b8002b';
  }
  
  // 获取配置错误信息
  static String? get configError {
    if (appId == 'wx7c5c4ede9d2fd367') {
      return '请配置微信AppID';
    }
    if (universalLink == 'https://your.univerallink.com/link/') {
      return '请配置iOS通用链接';
    }
    if (appSecret == '7558d35a5fabf99bd0cab02039b8002b') {
      return '请配置微信AppSecret';
    }
    return null;
  }
  
  // 检查是否为测试配置
  static bool get isTestConfig {
    return appId == 'wx7c5c4ede9d2fd367' || 
           appSecret == '7558d35a5fabf99bd0cab02039b8002b';
  }
} 