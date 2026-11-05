//! 在机器自身的原生后端上直接运行 Rust 根组件。
//!
//! Linux → GTK 4，macOS → AppKit，Windows → Win32。
//! iOS / Android 请用 `nsh run --target ios|android`（走 TSX 入口）。

#![cfg_attr(target_os = "windows", windows_subsystem = "windows")]

#[cfg(target_os = "linux")]
use nsh_platform_linux as platform;
#[cfg(target_os = "macos")]
use nsh_platform_macos as platform;
#[cfg(target_os = "windows")]
use nsh_platform_windows as platform;

#[cfg(any(target_os = "linux", target_os = "macos", target_os = "windows"))]
fn main() -> impl std::process::Termination {
    env_logger::init();
    platform::run_app(
        platform::AppSource::Rust(platform::Root::of::<hello_nsh::App>()),
        platform::AppOptions {
            title: "Hello NSH".to_owned(),
            #[cfg(any(target_os = "linux", target_os = "windows"))]
            app_id: "org.feuyeux.nsh.hello".to_owned(),
            size: (720, 480),
            ..Default::default()
        },
    )
}

#[cfg(not(any(target_os = "linux", target_os = "macos", target_os = "windows")))]
compile_error!(
    "在 macOS / Windows / Linux 上运行本二进制；iOS 与 Android 请用 TSX 入口配合 `nsh run`。"
);
