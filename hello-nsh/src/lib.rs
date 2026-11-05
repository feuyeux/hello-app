//! Hello NSH —— 纯 Rust + 平台原生视图的跨平台应用示例。
//!
//! 与 hello-gpui 展示同一件事（问候 + 当前时间），区别在于渲染层：
//! NSH 不自己画像素，而是把元素树映射到各平台**原生视图**——
//! Linux 走 GTK 4 + Pango，macOS 走 AppKit，Windows 走 Win32/Direct2D，
//! 同一份代码还能产出 HTML（web）与 GPUI 后端。
//!
//! 三个要点：
//!   1. `#[component]` 标记一个函数为组件，返回元素树；
//!   2. `signal()` 是响应式状态，`.set()` 自动让读到它的视图重建；
//!   3. `dynamic()` 包住的区域随信号重新求值 —— 元素树只装配一次。

use chrono::{Local, Timelike};
use nsh_core::prelude::*;
use std::time::Duration;

/// 本地时间（时, 分, 秒）。
fn local_hms() -> (u32, u32, u32) {
    let t = Local::now();
    (t.hour(), t.minute(), t.second())
}

/// 注册给 TSX 侧使用的原生组件（`import { App } from "hello-nsh/native"`）。
#[native_module("hello-nsh/native")]
fn native(registry: &mut Registry) {
    registry.register::<App>();
}

/// 应用根组件。
#[component]
pub fn App() -> impl IntoElement {
    // 响应式状态：时钟与问候计数
    let now = signal(local_hms());
    let count = signal(0_u32);

    // 每秒一拍；只更新信号，视图自动重建
    let now_tick = now.clone();
    set_interval(Duration::from_secs(1), move || {
        now_tick.set(local_hms());
    });

    let count_click = count.clone();
    let count_show = count.clone();
    let now_clock = now.clone();
    let now_secs = now.clone();

    view()
        .flex_1()
        .flex_col()
        .items_center()
        .justify_center()
        .gap(px(18.0))
        .bg(rgb(0x1B1B1F))
        .text_color(rgb(0xE8E6E3))
        // 标题
        .child(
            text("Hello from NSH 👋")
                .text_size(px(26.0))
                .font_weight(FontWeight::BOLD),
        )
        .child(
            text("纯 Rust · GTK 4 / AppKit / Win32 原生视图")
                .text_size(px(12.0))
                .text_color(rgb(0x8A8A93)),
        )
        // 时钟：等宽字体 + 冒号做成两个实心方块
        .child(
            view()
                .flex()
                .items_center()
                .font_family("monospace")
                .font_weight(FontWeight::BOLD)
                .text_size(px(64.0))
                .child(text(move || format!("{:02}", now_clock.get().0)))
                .child(
                    view()
                        .flex_col()
                        .gap(px(10.0))
                        .mx(px(6.0))
                        .child(view().size(px(6.0)).bg(rgb(0xE8E6E3)))
                        .child(view().size(px(6.0)).bg(rgb(0xE8E6E3))),
                )
                .child(text(move || format!("{:02}", now_clock.get().1)))
                .child(
                    text(move || format!("{:02}", now_secs.get().2))
                        .text_size(px(18.0))
                        .font_weight(FontWeight::NORMAL)
                        .text_color(rgb(0x8A8A93))
                        .ml(px(8.0)),
                ),
        )
        // 问候按钮
        .child(
            view()
                .px(px(18.0))
                .py(px(8.0))
                .rounded(px(3.0))
                .bg(rgb(0xE8E6E3))
                .child(
                    text("Greet")
                        .text_size(px(13.0))
                        .font_weight(FontWeight::BOLD)
                        .text_color(rgb(0x1B1B1F)),
                )
                .on_press(move || {
                    count_click.set(count_click.get() + 1);
                }),
        )
        // 问候结果：只有这块随计数重建
        .child(dynamic(move || {
            let n = count_show.get();
            let msg = if n == 0 {
                "点一下 Greet 试试".to_string()
            } else {
                format!("Hello! You've been greeted {n} time(s) from NSH!")
            };
            text(msg).text_size(px(14.0)).text_color(rgb(0xB9C6D8)).into_elements()
        }))
}
