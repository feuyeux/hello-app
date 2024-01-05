# hello electron

```sh
yarn add --dev electron

yarn start
```



`yarn add --dev electron`失败的解决方案

查看最新包

https://github.com/electron/electron/releases

下载最新包
https://github.com/electron/electron/releases/tag/v28.1.1

在`node_modules/electron/`下创建`dist`目录，然后将下载的文件解压到`dist`目录中
创建 `path.txt` 文件，并写入文本内容为：`electron.exe`

再次执行 `yarn add --dev electron`