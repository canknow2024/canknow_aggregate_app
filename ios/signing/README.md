# iOS 签名文件准备说明

本目录用于存放 iOS 打包并可直接安装到苹果手机（AdHoc 包）所需的签名相关文件。

## 需要准备的文件

1. **ios_distribution.p12**
   - iOS 发行证书（含私钥），导出时设置密码。
   - 用于 App 签名。

2. **AdHoc.mobileprovision**
   - AdHoc 类型的描述文件。
   - 需在 Apple Developer 网站创建并下载，包1含所有需要安装 App 的设备 UDID。

3. **ExportOptions.plist**
   - 导出 IPA 包的配置文件。
   - `method` 字段需设为 `ad-hoc`。

4. **p12_password.txt**（可选）
   - 如果 p12 文件有密码，可将密码写入此文件，或通过 CI 环境变量传递。

## 目录结构示例

```
ios/signing/
├── ios_distribution.p12
├── AdHoc.mobileprovision
├── ExportOptions.plist
├── p12_password.txt (可选)
└── README.md
```

## CI 脚本文件名对应说明
- 证书文件：`ios_distribution.p12`
- 描述文件：`AdHoc.mobileprovision`
- 导出配置：`ExportOptions.plist`
- 密码文件：`p12_password.txt`（可选）

## 参考
- [Apple 官方文档 - ExportOptionsPlist](https://developer.apple.com/documentation/xcode/creating-an-archive-of-your-app)
- [iOS 证书与描述文件管理](https://developer.apple.com/account/resources/profiles/list) 