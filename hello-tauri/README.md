# hello tauri

## next.js

[Guides-Getting Started-Quick Start-Next.js](https://tauri.app/v1/guides/getting-started/setup/next-js/)

```sh
# yarn tauri命令行
yarn add @tauri-apps/api
ls -l "node_modules/.bin/tauri"
```

```sh
yarn create next-app --use-yarn

yarn tauri init

yarn tauri dev
```

### add feature to rust code

```sh
cd src-tauri
cargo add local-ip-address
```

## mobile

```sh
# cargo mobile命令行
cargo install --git https://github.com/tauri-apps/tauri-mobile
ls -l "$HOME/.cargo/bin/cargo-android"
ls -l "$HOME/.cargo/bin/cargo-apple"
ls -l "$HOME/.cargo/bin/cargo-mobile"
```

```sh
# cargo tauri命令行
cargo install tauri-cli --version "^2.0.0-alpha"
ls -l "$HOME/.cargo/bin/cargo-tauri"
```

Additionally, all projects need to update the core Cargo dependencies, by running the following in the src-tauri folder:

```sh
cargo add tauri@2.0.0-alpha.0
cargo add tauri-build@2.0.0-alpha.0 --build
```

```sh
yarn add -D internal-ip
```

```sh
cargo mobile update
```

```sh
export ANDROID_HOME="$HOME/AppData/Local/Android/Sdk"
# https://developer.android.com/ndk/downloads
export NDK_HOME="/d/coding/android-ndk-r26b"

$ cargo mobile init
Project name (hello-tauri):
Stylized name (Hello Tauri):
Domain (example.com):
Detected template packs:
  [0] bevy
  [1] bevy-demo
  [2] egui
  [3] wgpu
  [4] winit
  [5] wry
  Enter an index for a template pack above.
Template pack (0): 5
Generating base project...
...
victory: Project generated successfully!
    Make cool apps! 🌻 🐕 🎉
```

```sh
cargo android run
```
