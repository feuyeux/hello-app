import { invoke } from "@tauri-apps/api/core";

let greetInputEl: HTMLInputElement | null;
let greetMsgEl: HTMLElement | null;
let timeDisplayEl: HTMLElement | null;
let timeInterval: number;

async function greet() {
  if (greetMsgEl && greetInputEl) {
    // Learn more about Tauri commands at https://tauri.app/develop/calling-rust/
    greetMsgEl.textContent = await invoke("greet", {
      name: greetInputEl.value,
    });
  }
}

async function updateTime() {
  if (timeDisplayEl) {
    timeDisplayEl.textContent = await invoke("get_current_time");
  }
}

window.addEventListener("DOMContentLoaded", () => {
  greetInputEl = document.querySelector("#greet-input");
  greetMsgEl = document.querySelector("#greet-msg");
  timeDisplayEl = document.querySelector("#time-display");
  
  document.querySelector("#greet-form")?.addEventListener("submit", (e) => {
    e.preventDefault();
    greet();
  });

  // Initialize time display
  updateTime();
  timeInterval = window.setInterval(updateTime, 1000);
});

// Clean up interval when window unloads
window.addEventListener("beforeunload", () => {
  if (timeInterval) {
    clearInterval(timeInterval);
  }
});
