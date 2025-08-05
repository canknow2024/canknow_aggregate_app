#!/bin/bash

# iOS 签名文件设置脚本
# 用于检查和设置 iOS 构建所需的签名文件

echo "🔍 检查 iOS 签名文件..."

# 检查证书文件
if [ -f "ios_distribution.p12" ]; then
    echo "✅ 找到 ios_distribution.p12 文件"
else
    echo "❌ 缺少 ios_distribution.p12 文件"
    echo ""
    echo "请执行以下步骤获取证书文件："
    echo "1. 登录 https://developer.apple.com/account/"
    echo "2. 进入 Certificates, Identifiers & Profiles"
    echo "3. 创建 iOS Distribution 证书"
    echo "4. 下载证书并安装到 Keychain Access"
    echo "5. 从 Keychain Access 导出为 .p12 格式（包含私钥）"
    echo "6. 设置密码并保存为 ios_distribution.p12"
    echo ""
fi

# 检查描述文件
if [ -f "AdHoc.mobileprovision" ]; then
    echo "✅ 找到 AdHoc.mobileprovision 文件"
else
    echo "❌ 缺少 AdHoc.mobileprovision 文件"
    echo ""
    echo "请执行以下步骤获取描述文件："
    echo "1. 在 Apple Developer 网站创建 AdHoc 类型的 Provisioning Profile"
    echo "2. 选择正确的 App ID 和证书"
    echo "3. 添加需要安装 App 的设备 UDID"
    echo "4. 下载描述文件并重命名为 AdHoc.mobileprovision"
    echo ""
fi

# 检查导出配置文件
if [ -f "ExportOptions.plist" ]; then
    echo "✅ 找到 ExportOptions.plist 文件"
else
    echo "❌ 缺少 ExportOptions.plist 文件"
    echo "请创建此文件或从项目模板复制"
fi

echo ""
echo "📋 检查 GitHub Secrets 配置："
echo "确保在 GitHub 仓库的 Settings > Secrets and variables > Actions 中添加："
echo "- P12_PASSWORD: iOS 发行证书的密码"
echo ""

echo "�� 详细文档请参考：README.md" 