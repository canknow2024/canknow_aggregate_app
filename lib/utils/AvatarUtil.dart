import 'package:flutter/material.dart';

class AvatarUtil {
  /// 默认头像路径
  static const String defaultAvatarPath = 'assets/images/defaultAvatar.png';
  
  /// 获取头像图片提供者
  /// [avatarUrl] 用户头像URL，如果为null或空字符串则使用默认头像
  static ImageProvider? getAvatarImage(String? avatarUrl) {
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      return NetworkImage(avatarUrl);
    }
    return const AssetImage(defaultAvatarPath);
  }
  
  /// 创建头像组件
  /// [avatarUrl] 用户头像URL
  /// [radius] 头像半径
  /// [onTap] 点击回调
  static Widget buildAvatar({
    String? avatarUrl,
    double radius = 35,
    VoidCallback? onTap,
  }) {
    final avatar = CircleAvatar(
      radius: radius,
      backgroundImage: getAvatarImage(avatarUrl),
    );
    
    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: avatar,
      );
    }
    
    return avatar;
  }
  
  /// 创建带头像图标的头像组件（当网络图片加载失败时显示图标）
  /// [avatarUrl] 用户头像URL
  /// [radius] 头像半径
  /// [iconSize] 图标大小
  /// [onTap] 点击回调
  static Widget buildAvatarWithFallback({
    String? avatarUrl,
    double radius = 35,
    double iconSize = 35,
    VoidCallback? onTap,
  }) {
    final avatar = CircleAvatar(
      radius: radius,
      backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty 
          ? NetworkImage(avatarUrl) 
          : null,
      child: avatarUrl == null || avatarUrl.isEmpty
          ? Icon(Icons.person, size: iconSize, color: Colors.grey)
          : null,
    );
    
    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: avatar,
      );
    }
    
    return avatar;
  }
} 