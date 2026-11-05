# Hello NSH

纯 Rust + 平台原生视图的跨平台应用示例，基于 [NSH（Native Shell）](https://nsh.dev) 0.4.0。

和 `hello-gpui` 展示同一件事（问候 + 当前时间），区别在渲染层：NSH 不自己画像素，
而是把元素树映射到**各平台原生视图**——Linux 走 GTK 4 + Pango，macOS 走 AppKit，
Windows 走 Win32 + Direct2D，同一份代码还能产出 HTML（web）与 GPUI 后端。

## 运行

```sh
cargo run                      # 本机原生后端
nsh run                        # 或用 NSH CLI（支持热重载）
nsh run --target web           # 浏览器
nsh package --target linux     # 打包
```

`nsh` CLI 安装：

```sh
curl -fsSL https://nsh.dev/install.sh | sh
```

`nsh-*` 依赖版本要与 `nsh` CLI 保持一致（当前同为 0.4.0）。

## 架构要点

| 概念 | 在代码里的位置 | 说明 |
|:--|:--|:--|
| 组件 | `#[component] pub fn App()` | 一个函数就是一棵元素树 |
| 响应式状态 | `signal(...)` / `.set(...)` | 读到该信号的视图自动重建 |
| 局部重建 | `dynamic(move \|\| ...)` | 只有这块随信号重新求值 |
| 时钟心跳 | `set_interval(...)` | 每秒更新 `now` 信号 |
| 事件 | `.on_press(...)` | 直接改信号即可 |
| TSX 互操作 | `#[native_module("hello-nsh/native")]` | 把 Rust 组件导出给 TSX 使用 |

元素树只在装配时构建一次，之后时间、计数都走信号 —— 这是 NSH 与 GPUI「整树重绘」的关键差异。

## 与其它技术栈的对照

| | Tauri | GPUI Kit | NSH |
|:--|:--|:--|:--|
| 渲染 | 系统 WebView | GPU 自绘管线 | 平台原生视图 |
| UI 语言 | HTML/CSS/JS | Rust 元素树 | Rust 元素树（+ TSX） |
| Rust 代码量 | 壳（几十行） | 全量 | 全量 |
| 跨平台 | 桌面 3 平台 + iOS/Android | 桌面 3 平台 + WebAssembly | iOS/Android/macOS/Windows/Linux/Web |

## 参考

- [NSH 文档](https://nsh.dev/docs)
- [NSH 模型可读文档](https://nsh.dev/llms.txt)
