//! Hello GPUI —— 纯 Rust + GPU 自绘的桌面应用示例。
//!
//! 与其它 hello-* 一样展示「问候 + 当前时间」，但这里没有 WebView、没有 HTML：
//! 每一帧都由 GPUI 的渲染管线直接画到 GPU（Linux 走 Vulkan）。
//!
//! 三个要点：
//!   1. `impl Render` 把整个窗口描述成一棵元素树；
//!   2. `cx.notify()` 触发重绘 —— GPUI 没有虚拟 DOM diff，状态变了自己重画；
//!   3. `cx.spawn` + `smol::Timer` 驱动每秒走时。

use chrono::Local;
use gpui_kit::*;

/// 应用的全部状态：当前时刻、问候结果、已问候次数。
struct HelloGpui {
    now: (u32, u32, u32),
    greeting: String,
    count: u32,
}

impl HelloGpui {
    fn greet(&mut self) {
        self.count += 1;
        self.greeting = format!("Hello! You've been greeted {} time(s) from GPUI!", self.count);
    }
}

impl Render for HelloGpui {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let (h, m, s) = self.now;

        div()
            .id("root")
            .size_full()
            .flex()
            .flex_col()
            .items_center()
            .justify_center()
            .gap(px(18.0))
            .bg(rgb(0x1B1B1F))
            .text_color(rgb(0xE8E6E3))
            .font_family("Noto Sans CJK SC")
            // 标题
            .child(
                div()
                    .text_size(px(26.0))
                    .font_weight(FontWeight::BOLD)
                    .child("Hello from GPUI 👋"),
            )
            .child(
                div()
                    .text_size(px(12.0))
                    .text_color(rgb(0x8A8A93))
                    .child("纯 Rust · GPU 自绘 · 无 WebView"),
            )
            // 时钟：等宽字体 + 冒号做成两个实心方块（电子表的方硬感）
            .child(
                div()
                    .id("clock")
                    .flex()
                    .items_center()
                    .font_family("DejaVu Sans Mono")
                    .font_weight(FontWeight::BOLD)
                    .text_size(px(64.0))
                    .child(format!("{h:02}"))
                    .child(
                        div()
                            .flex()
                            .flex_col()
                            .gap(px(10.0))
                            .mx(px(6.0))
                            .child(div().size(px(6.0)).bg(rgb(0xE8E6E3)).rounded(px(1.0)))
                            .child(div().size(px(6.0)).bg(rgb(0xE8E6E3)).rounded(px(1.0))),
                    )
                    .child(format!("{m:02}"))
                    .child(
                        div()
                            .text_size(px(18.0))
                            .font_weight(FontWeight::NORMAL)
                            .text_color(rgb(0x8A8A93))
                            .ml(px(8.0))
                            .child(format!("{s:02}")),
                    ),
            )
            // 问候按钮
            .child(
                div()
                    .id("greet-btn")
                    .px(px(18.0))
                    .py(px(8.0))
                    .rounded(px(3.0))
                    .bg(rgb(0xE8E6E3))
                    .text_color(rgb(0x1B1B1F))
                    .text_size(px(13.0))
                    .font_weight(FontWeight::BOLD)
                    .child("Greet")
                    .on_click(cx.listener(|this: &mut HelloGpui, _, _, cx| {
                        this.greet();
                        cx.notify();
                    })),
            )
            // 问候结果
            .child(
                div()
                    .text_size(px(14.0))
                    .text_color(rgb(0xB9C6D8))
                    .child(self.greeting.clone()),
            )
    }
}

fn main() {
    application().run(|cx| {
        gpui_kit::init(cx);

        let now = local_hms();
        let options = WindowOptions {
            window_bounds: Some(WindowBounds::centered(size(px(720.0), px(480.0)), cx)),
            ..Default::default()
        };

        open_window(options, cx, |_, cx| {
            cx.new(|cx| {
                // 每秒一拍：只更新时间并请求重绘
                cx.spawn(async move |this, cx| {
                    loop {
                        smol::Timer::after(std::time::Duration::from_secs(1)).await;
                        if this
                            .update(cx, |app: &mut HelloGpui, cx| {
                                app.now = local_hms();
                                cx.notify();
                            })
                            .is_err()
                        {
                            break;
                        }
                    }
                })
                .detach();

                HelloGpui {
                    now,
                    greeting: "点一下 Greet 试试".to_string(),
                    count: 0,
                }
            })
        })
        .expect("failed to open window");
    });
}

/// 本地时间（时, 分, 秒）。
fn local_hms() -> (u32, u32, u32) {
    use chrono::Timelike;
    let t = Local::now();
    (t.hour(), t.minute(), t.second())
}
