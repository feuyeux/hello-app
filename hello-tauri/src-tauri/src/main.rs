#![cfg_attr(
    all(not(debug_assertions), target_os = "windows"),
    windows_subsystem = "windows"
)]

pub fn main() {
    app::AppBuilder::new().run();
}

use local_ip_address::local_ip;
use std::time::{SystemTime, UNIX_EPOCH};

#[tauri::command]
fn greet(name: &str) -> String {
    let local_ip = local_ip().unwrap();

    let current_time = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .unwrap()
        .as_secs();

    let formatted_time = chrono::DateTime::<chrono::Local>::from(
        UNIX_EPOCH + std::time::Duration::from_secs(current_time),
    )
    .format("%Y-%m-%d %H:%M:%S")
    .to_string();

    format!("{}@{}: Hello, {}", local_ip, formatted_time, name)
}

fn main_bk() {
    tauri::Builder::default()
        .invoke_handler(tauri::generate_handler![greet])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
