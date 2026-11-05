# Hello GPUI

纯 Rust + GPU 自绘的桌面应用示例，基于 [GPUI Kit](https://gpui-kit.com) 0.9.0。

和本仓库其它 `hello-*` 一样展示「问候 + 当前时间」，但**没有 WebView、没有 HTML/CSS/JS**：
每一帧都由 GPUI 的渲染管线直接画到 GPU —— Linux 走 Vulkan，macOS 走 Metal，Windows 走 DirectX。

## 运行

```sh
cargo run
```

Linux 需要 Vulkan 与 `libxkbcommon-x11` 的开发包；没有 root 时见下方「无 root 环境」。

## 架构要点

| 概念 | 在代码里的位置 | 说明 |
|:--|:--|:--|
| 元素树 | `impl Render for HelloGpui` | 整个窗口一次性描述成一棵树 |
| 状态与重绘 | `cx.notify()` | 没有虚拟 DOM diff，状态变了就整树重画 |
| 时钟心跳 | `cx.spawn` + `smol::Timer` | 协程里每秒更新 `self.now` |
| 事件 | `cx.listener(...)` | 把点击回调绑定到实体（Entity）上 |
| 窗口 | `open_window(WindowOptions { .. })` | 尺寸、位置、标题栏样式 |

`gpui-kit` 是 GPUI 全家桶的门面（facade）crate：`use gpui_kit::*` 就等同于 `use gpui::*`，
另外还带上 `gpui-base`（基础控件行为）与 `gpui-component`（样式化组件库）。

## 无 root 环境

`build.rs` 会在 `~/.local/sysroot` 存在时把它加进链接搜索路径（GPUI 在 Linux 上链接
`libxkbcommon-x11` / `libvulkan`），`.cargo/config.toml` 同步指向那里的 `pkg-config`。
有系统开发包的机器上这两处都是空操作，可以整段删掉：

```sh
sudo apt install libxkbcommon-x11-dev libvulkan-dev vulkan-validationlayers
```

## 参考

- [GPUI Kit](https://gpui-kit.com)
- [GPUI（Zed 的 UI 框架）](https://github.com/zed-industries/zed/tree/main/crates/gpui)
