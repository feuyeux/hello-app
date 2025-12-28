<!-- markdownlint-disable MD033 MD045 -->

# Hello App

跨平台应用开发框架示例集合，展示如何使用不同的技术栈开发运行在 **Windows**、**macOS**、**Linux**、**Android** 和 **iOS** 上的应用程序。

## 支持的框架

|Framework|平台支持|语言|引擎|特点|
|:--|:--|:--|:--|:--|
|<img src="https://upload.wikimedia.org/wikipedia/commons/9/91/Electron_Software_Framework_Logo.svg" width="60"/> [Electron](https://github.com/electron/electron)|桌面端 (Win/Mac/Linux)|JavaScript/TypeScript|Chromium + Node.js|Web 技术构建桌面应用|
|<img src="https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png" width="60"/> [Flutter](https://github.com/flutter/flutter)|全平台|Dart|Flutter Engine|Google 出品，高性能 UI|
|<img src="https://images.seeklogo.com/logo-png/43/1/tauri-logo-png_seeklogo-430949.png" width="60"/> [Tauri](https://github.com/tauri-apps/tauri)|桌面端 (Win/Mac/Linux)|Rust + Web|WRY|轻量级，安全性高|
|<img src="https://github.com/expo.png" width="60"/> [Expo](https://github.com/expo/expo)|移动端 + Web|TypeScript/JavaScript|React Native|快速开发，丰富生态|

## 项目结构

```
hello-app/
├── hello-electron/          # Electron 桌面应用示例
│   ├── main.js              # 主进程
│   ├── index.html           # 渲染进程页面
│   └── package.json         # 项目配置
├── hello-flutter/           # Flutter 应用示例
│   ├── flip_clock/          # 翻页时钟应用
│   └── hello_flutter_app/   # 基础 Flutter 应用
├── hello-tauri/             # Tauri 应用示例
│   ├── hello-tauri-react/   # React 前端版本
│   ├── hello-tauri-svelte/  # Svelte 前端版本
│   ├── hello-tauri-vanilla/ # 原生 JS 版本
│   └── hello-tauri-vue/     # Vue 前端版本
└── hello-expo/              # Expo React Native 应用示例
    ├── app/                 # 应用页面 (文件路由)
    ├── components/          # 可复用组件
    ├── constants/           # 常量定义
    └── hooks/               # 自定义 Hooks
```

## 快速开始

### Electron (桌面应用)
```bash
cd hello-electron
npm install
npm start
```

### Flutter (移动/桌面应用)
```bash
cd hello-flutter/hello_flutter_app
flutter pub get
flutter run
```

### Tauri (桌面应用)
```bash
cd hello-tauri/hello-tauri-react
npm install
npm run tauri dev
```

### Expo (移动/Web应用)
```bash
cd hello-expo
npm install
npx expo start
# 使用 Expo Go 应用扫描二维码在手机上运行
```

## 开发环境配置

### Node.js 源配置

```sh
npm config set registry https://registry.npmmirror.com
yarn config set registry https://registry.npmmirror.com
```

### Android 开发环境

> NDK 下载：<https://developer.android.com/ndk/downloads>

```sh
export ANDROID_HOME="$HOME/AppData/Local/Android/Sdk"
export NDK_HOME="/d/coding/android-ndk-r26b"
export PATH="$PATH:$ANDROID_HOME/tools/:$ANDROID_HOME/platform-tools/"
```

### Android 模拟器

查看可用的模拟器：
```sh
$ emulator -list-avds
Medium_Phone_API_31
```

启动模拟器：

```sh
emulator -avd Medium_Phone_API_31
```

![emulator](imgs/2024-01-05 194742.png)
