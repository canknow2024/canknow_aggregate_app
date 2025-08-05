# iOS 签名故障排除指南

## 常见错误及解决方案

### 1. "No signing certificate 'iOS Distribution' found"

**错误原因**: 证书未正确导入或证书类型不匹配

**解决方案**:
1. 确保 `ios_distribution.p12` 文件存在且有效
2. 检查证书是否为 iOS Distribution 类型
3. 验证 GitHub Secrets 中的 `P12_PASSWORD` 是否正确
4. 确保证书包含私钥

**验证步骤**:
```bash
# 检查证书文件
ls -la ios/signing/ios_distribution.p12

# 验证证书内容（需要密码）
openssl pkcs12 -info -in ios/signing/ios_distribution.p12 -noout
```

### 2. "No profile for team '323LXQXZ6R' matching 'canknow-ad-hoc' found"

**错误原因**: Provisioning profile 未正确安装或名称不匹配

**解决方案**:
1. 确保 `AdHoc.mobileprovision` 文件存在
2. 检查描述文件是否包含正确的 Bundle ID: `com.canknow.canknowAggregateApp`
3. 验证描述文件是否包含正确的 Team ID: `323LXQXZ6R`

**验证步骤**:
```bash
# 检查描述文件内容
security cms -D -i ios/signing/AdHoc.mobileprovision | grep -A 10 "TeamIdentifier"
```

### 3. "security: SecKeychainItemImport: The specified item already exists in the keychain"

**错误原因**: 证书已存在于钥匙串中

**解决方案**: 这是警告信息，可以忽略，不会影响构建

### 4. 构建过程中证书验证失败

**错误原因**: 证书信任设置不正确

**解决方案**:
1. 确保证书已正确导入到钥匙串
2. 设置证书信任
3. 验证证书是否可用于代码签名

**验证步骤**:
```bash
# 检查可用证书
security find-identity -v -p codesigning build.keychain

# 应该看到类似输出:
# 1) XXXXXXXX "iPhone Distribution: Your Team Name (323LXQXZ6R)"
```

## 调试步骤

### 步骤 1: 检查签名文件
```bash
ls -la ios/signing/
```

应该看到:
- `ios_distribution.p12` (iOS 发行证书)
- `AdHoc.mobileprovision` (AdHoc 描述文件)
- `ExportOptions.plist` (导出配置)

### 步骤 2: 验证证书
```bash
# 检查证书文件大小（应该 > 1KB）
ls -lh ios/signing/ios_distribution.p12

# 验证证书格式
file ios/signing/ios_distribution.p12
```

### 步骤 3: 验证描述文件
```bash
# 检查描述文件内容
security cms -D -i ios/signing/AdHoc.mobileprovision | grep -E "(TeamIdentifier|AppIDName|BundleID)"
```

### 步骤 4: 测试证书导入
```bash
# 创建测试钥匙串
security create-keychain -p "" test.keychain
security list-keychains -s test.keychain
security default-keychain -s test.keychain
security unlock-keychain -p "" test.keychain

# 导入证书
security import ios/signing/ios_distribution.p12 -k test.keychain -P "YOUR_PASSWORD" -T /usr/bin/codesign

# 验证证书
security find-identity -v -p codesigning test.keychain
```

## 获取正确证书的步骤

### 1. 获取 iOS Distribution 证书
1. 登录 [Apple Developer](https://developer.apple.com/account/)
2. 进入 Certificates, Identifiers & Profiles > Certificates
3. 点击 "+" 创建新证书
4. 选择 "iOS Distribution (App Store and Ad Hoc)"
5. 按照向导创建证书
6. 下载证书文件 (.cer)

### 2. 导出为 .p12 格式
1. 双击下载的 .cer 文件安装到 Keychain Access
2. 打开 Keychain Access
3. 找到刚安装的证书
4. 右键点击证书 > Export
5. 选择格式为 "Personal Information Exchange (.p12)"
6. 设置密码并保存为 `ios_distribution.p12`

### 3. 创建 AdHoc 描述文件
1. 在 Apple Developer 网站进入 Profiles
2. 点击 "+" 创建新描述文件
3. 选择 "Ad Hoc"
4. 选择正确的 App ID
5. 选择刚创建的 iOS Distribution 证书
6. 添加需要安装 App 的设备 UDID
7. 下载描述文件并重命名为 `AdHoc.mobileprovision`

## GitHub Actions 配置检查

### 1. 检查 Secrets
在 GitHub 仓库的 Settings > Secrets and variables > Actions 中确保有:
- `P12_PASSWORD`: iOS 发行证书的密码

### 2. 检查工作流文件
确保 `.github/workflows/ios_build.yml` 包含正确的步骤顺序:
1. 检查签名文件
2. 设置钥匙串
3. 导入证书
4. 复制描述文件
5. 构建应用

### 3. 检查 Xcode 项目配置
确保 `ios/Runner.xcodeproj/project.pbxproj` 中的签名设置正确:
- `CODE_SIGN_IDENTITY = "iPhone Distribution"`
- `CODE_SIGN_STYLE = Manual`
- `PROVISIONING_PROFILE_SPECIFIER[sdk=iphoneos*] = "canknow-ad-hoc"`

## 测试工作流

运行测试工作流来验证签名设置:
1. 在 GitHub 仓库的 Actions 页面
2. 选择 "Test iOS Signing" 工作流
3. 点击 "Run workflow"
4. 查看输出日志，确认所有步骤都成功

## 联系支持

如果问题仍然存在，请提供以下信息:
1. GitHub Actions 构建日志
2. 错误信息截图
3. 签名文件检查结果
4. 证书和描述文件的获取日期 