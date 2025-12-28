# Hello Expo

这是一个使用 Expo 框架构建的 React Native 应用示例。

## 关于 Expo

Expo 是一个基于 React Native 的开源框架和平台，旨在让移动应用开发变得更快、更简单、更易于访问。它提供了一套完整的工具和服务，让开发者可以专注于应用逻辑而不是复杂的原生配置。

## 特性

- 🚀 快速开发：无需配置原生代码即可开始开发
- 📱 跨平台：一套代码同时支持 iOS 和 Android
- 🌐 Web 支持：同样的代码也可以在 Web 上运行
- 🔧 丰富的 API：内置相机、推送通知、地理位置等功能
- 📦 OTA 更新：支持热更新，无需重新发布应用

## 环境要求

- Node.js (推荐 18.x 或更高版本)
- npm 或 yarn
- Expo CLI
- 移动设备上的 Expo Go 应用（用于测试）

## 安装和运行

### 1. 安装依赖

```bash
cd hello-expo
npm install
```

### 2. 启动开发服务器

```bash
npx expo start
```

### 3. 在设备上运行

- **iOS**: 使用 iPhone 相机扫描二维码，或在 iOS 模拟器中按 `i`
- **Android**: 使用 Expo Go 应用扫描二维码，或在 Android 模拟器中按 `a`
- **Web**: 在浏览器中按 `w`

## 项目结构

```
hello-expo/
├── app/                    # 应用页面
│   ├── (tabs)/            # 标签页导航
│   │   ├── index.tsx      # 首页
│   │   └── explore.tsx    # 探索页
│   ├── +not-found.tsx     # 404 页面
│   └── _layout.tsx        # 根布局
├── assets/                # 静态资源
├── components/            # 可复用组件
├── constants/             # 常量定义
├── hooks/                 # 自定义 Hooks
├── app.json              # Expo 配置
├── package.json          # 项目依赖
└── tsconfig.json         # TypeScript 配置
```

## 开发指南

### 添加新页面

在 `app` 目录下创建新的 `.tsx` 文件即可自动生成路由。

### 使用原生功能

Expo 提供了丰富的 API 来访问设备功能：

```typescript
import { Camera } from 'expo-camera';
import * as Location from 'expo-location';
import * as Notifications from 'expo-notifications';
```

### 自定义配置

编辑 `app.json` 文件来配置应用名称、图标、启动画面等。

## 构建和发布

### 开发构建

```bash
npx expo install --fix
eas build --profile development --platform ios
```

### 生产构建

```bash
eas build --profile production --platform all
```

## 相关链接

- [Expo 官方文档](https://docs.expo.dev/)
- [React Native 文档](https://reactnative.dev/)
- [Expo GitHub](https://github.com/expo/expo)
- [Expo 示例应用](https://github.com/expo/examples)

## 技术栈

- **框架**: Expo (基于 React Native)
- **语言**: TypeScript
- **导航**: Expo Router
- **状态管理**: React Hooks
- **样式**: StyleSheet (React Native)