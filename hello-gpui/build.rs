//! 无 root 环境的链接路径自愈。
//!
//! GPUI 在 Linux 上链接 `libxkbcommon-x11` / `libvulkan`。若这些库只存在于
//! `~/.local/sysroot`（`tools/ensure-env.sh` 那类免 root 方案解包的位置），
//! 就把该目录加进链接搜索路径；有系统开发包的机器这里是空操作。
fn main() {
    let home = std::env::var("HOME").unwrap_or_default();
    let sysroot = std::path::PathBuf::from(home).join(".local/sysroot/usr/lib/x86_64-linux-gnu");
    if sysroot.is_dir() {
        println!("cargo:rustc-link-search=native={}", sysroot.display());
    }
}
