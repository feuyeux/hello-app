// Learn more about Tauri commands at https://tauri.app/develop/calling-rust/
#[tauri::command]
fn greet(name: &str) -> String {
    format!("Hello, {}! You've been greeted from Rust!", name)
}

#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    tauri::Builder::default()
        .plugin(tauri_plugin_opener::init())
        .invoke_handler(tauri::generate_handler![greet, get_current_time])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
use chrono::{DateTime, Local};

#[tauri::command]
fn get_current_time() -> String {
    let local_time: DateTime<Local> = Local::now();
    local_time.format("%Y-%m-%d %H:%M:%S").to_string()
}
