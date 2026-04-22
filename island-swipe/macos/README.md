# Activity Monitor.app

这是一个可本地打包、可安装的 macOS SwiftUI app。

当前有两条打包链路：

- 本地使用：`adhoc` 签名，适合自己机器安装
- 对外分发：`Developer ID Application` + `hardened runtime` + `notarization`

## 生成可安装 app

```bash
cd /Users/m1/projects/front-simple-screen-monitor/island-swipe/macos
./script/package_app.sh
```

产物：

- `dist/Activity Monitor.app`
- `dist/Activity-Monitor-macOS.zip`

## 本地安装

安装到当前用户目录：

```bash
./script/install_app.sh --user
```

安装到系统应用目录：

```bash
./script/install_app.sh --system
```

## 调试运行

```bash
./script/build_and_run.sh
```

## 验证交互逻辑

```bash
./script/self_check.sh
```

说明：

- 当前产物使用 ad-hoc signing，适合本机本地安装与运行。
- 还没有 Developer ID 签名与 notarization，因此不属于可对外分发的正式发行包。

## 对外分发前提

你需要这两个外部前提：

1. 本机钥匙串里有 `Developer ID Application` 证书
2. 已经通过 `notarytool store-credentials` 存过一个 keychain profile

检查证书：

```bash
security find-identity -v -p codesigning
```

当前脚本会优先读取：

- `APPLE_SIGN_IDENTITY`
- `APPLE_NOTARY_PROFILE`

如果 `APPLE_SIGN_IDENTITY` 没填，脚本会尝试自动发现唯一一个 `Developer ID Application` 证书。

## 生成 Developer ID 签名包

```bash
./script/package_distribution.sh
```

产物：

- `dist/Activity Monitor.app`
- `dist/Activity-Monitor-macOS-signed.zip`

这一步会：

- 用 `Developer ID Application` 签名
- 开启 `hardened runtime`
- 生成可提交 notarization 的 zip

## 提交 notarization 并生成最终发行包

先准备 notary profile 名称，例如：

```bash
export APPLE_NOTARY_PROFILE="my-notary-profile"
```

然后执行：

```bash
./script/notarize_app.sh
```

产物：

- `dist/Activity-Monitor-macOS-signed.zip`
- `dist/Activity-Monitor-macOS-notarized.zip`

这一步会：

- 提交到 Apple notary service
- 等待结果
- 对 `.app` 执行 `staple`
- 重新打出最终可分发 zip

## 验证分发包

```bash
./script/verify_distribution.sh
```

会检查：

- `codesign`
- `Gatekeeper`
- `stapler`

## 凭据准备

`notarytool` 凭据需要你自己手动创建并保存到 Keychain。典型命令是：

```bash
xcrun notarytool store-credentials "<profile-name>"
```

这一步会涉及你的 Apple 分发凭据，不建议把它自动写进项目脚本里。
