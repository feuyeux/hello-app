#!/bin/bash

echo "🚀 设置 Expo 开发环境..."

# 检查 Node.js
if ! command -v node &> /dev/null; then
    echo "❌ 请先安装 Node.js (https://nodejs.org/)"
    exit 1
fi

# 检查 npm
if ! command -v npm &> /dev/null; then
    echo "❌ 请先安装 npm"
    exit 1
fi

echo "✅ Node.js 和 npm 已安装"

# 安装依赖
echo "📦 安装项目依赖..."
npm install

# 检查 Expo CLI
if ! command -v expo &> /dev/null; then
    echo "📱 安装 Expo CLI..."
    npm install -g @expo/cli
fi

echo "✅ Expo CLI 已安装"

echo ""
echo "🎉 设置完成！"
echo ""
echo "接下来的步骤："
echo "1. 在手机上安装 Expo Go 应用"
echo "   - iOS: https://apps.apple.com/app/expo-go/id982107779"
echo "   - Android: https://play.google.com/store/apps/details?id=host.exp.exponent"
echo ""
echo "2. 启动开发服务器："
echo "   npx expo start"
echo ""
echo "3. 使用 Expo Go 扫描二维码来在设备上运行应用"
echo ""
echo "更多信息请查看 README.md 文件"