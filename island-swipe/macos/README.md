# Activity Monitor.app

这是一个可本地打包、可安装的 macOS SwiftUI app。

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
