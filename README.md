# 虚空终端 Linux 桌面版（VoidTerminal-Linux）

虚空终端（聊天网站 buer.kdns.fr）的 Linux 原生桌面客户端，基于 Flutter 构建，原生渲染（非 WebView 套壳），连接 buer.kdns.fr。

## 功能

- 登录 / 注册
- 全局大厅聊天
- 好友私聊、群聊
- 好友管理（加好友、好友申请）
- 群聊搜索、申请加入、创建群
- 朋友圈（发布、点赞、评论）
- 深色主题
- 管理员功能（公告、清空大厅）

## 技术栈

- Flutter（Dart）
- http、web_socket_channel、provider

## 构建

```bash
# 安装 Flutter SDK 与 Linux 桌面依赖（Debian）
sudo apt-get install -y clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev
# 获取 Flutter：https://docs.flutter.dev/get-started/install/linux

flutter pub get
flutter build linux
```

产物在 `build/linux/x64/release/bundle/void_terminal_linux`。

## 相关项目

- 网页版：https://buer.kdns.fr
- iOS 客户端：https://github.com/Zhou-Yujing114514/VoidTerminal-iOS
- 小说下载站：https://morax.kdns.fr
