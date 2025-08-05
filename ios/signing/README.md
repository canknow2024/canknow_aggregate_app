# iOS 签名文件准备说明

本目录用于存放 iOS 打包并可直接安装到苹果手机（AdHoc 包）所需的签名相关文件。

## 需要准备的文件

1. **ios_distribution.p12**
   - iOS 发行证书（含私钥），导出时设置密码。
   - 用于 App 签名。
   - **重要**: 此文件必须存在，否则 GitHub Actions 构建会失败。

2. **AdHoc.mobileprovision**
   - AdHoc 类型的描述文件。
   - 需在 Apple Developer 网站创建并下载，包含所有需要安装 App 的设备 UDID。

3. **ExportOptions.plist**
   - 导出 IPA 包的配置文件。
   - `method` 字段需设为 `ad-hoc`。

4. **p12_password.txt**（可选）
   - 如果 p12 文件有密码，可将密码写入此文件，或通过 CI 环境变量传递。

## 目录结构示例

```
ios/signing/
├── ios_distribution.p12          # 必需：iOS 发行证书
├── AdHoc.mobileprovision        # 必需：AdHoc 描述文件
├── ExportOptions.plist          # 必需：导出配置
├── p12_password.txt (可选)      # 可选：证书密码
└── README.md
```

## GitHub Actions 配置

### 必需的环境变量
在 GitHub 仓库的 Settings > Secrets and variables > Actions 中添加：

- `P12_PASSWORD`: iOS 发行证书的密码

### 故障排除

#### 错误: "No profile for team '323LXQXZ6R' matching 'canknow-ad-hoc' found"
**原因**: Provisioning profile 未正确安装或名称不匹配
**解决方案**:
1. 确保 `AdHoc.mobileprovision` 文件存在且有效
2. 检查 `ExportOptions.plist` 中的 `provisioningProfiles` 配置
3. 确保描述文件包含正确的 Bundle ID: `com.canknow.canknowAggregateApp`

#### 错误: "security: SecKeychainItemImport: The specified item already exists in the keychain"
**原因**: 证书已存在于钥匙串中
**解决方案**: 这是警告信息，可以忽略，不会影响构建

#### 错误: "缺少 ios_distribution.p12 文件"
**原因**: 缺少 iOS 发行证书文件
**解决方案**:
1. 从 Apple Developer 网站下载 iOS 发行证书
2. 导出为 .p12 格式（包含私钥）
3. 设置密码并记住密码
4. 将文件重命名为 `ios_distribution.p12` 并放入 `ios/signing/` 目录

## CI 脚本文件名对应说明
- 证书文件：`ios_distribution.p12`
- 描述文件：`AdHoc.mobileprovision`
- 导出配置：`ExportOptions.plist`
- 密码文件：`p12_password.txt`（可选）

## 获取证书和描述文件的步骤

### 1. 获取 iOS 发行证书
1. 登录 [Apple Developer](https://developer.apple.com/account/)
2. 进入 Certificates, Identifiers & Profiles
3. 创建 iOS Distribution 证书
4. 下载证书并安装到 Keychain Access
5. 从 Keychain Access 导出为 .p12 格式（包含私钥）
6. 设置密码并保存为 `ios_distribution.p12`

### 2. 创建 AdHoc 描述文件
1. 在 Apple Developer 网站创建 AdHoc 类型的 Provisioning Profile
2. 选择正确的 App ID 和证书
3. 添加需要安装 App 的设备 UDID
4. 下载描述文件并重命名为 `AdHoc.mobileprovision`

## 参考
- [Apple 官方文档 - ExportOptionsPlist](https://developer.apple.com/documentation/xcode/creating-an-archive-of-your-app)
- [iOS 证书与描述文件管理](https://developer.apple.com/account/resources/profiles/list)
- [GitHub Actions 故障排除](https://docs.github.com/en/actions/managing-workflow-runs/debugging-workflow-runs) 