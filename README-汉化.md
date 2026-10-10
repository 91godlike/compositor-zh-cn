# Compositor 1.4.9 简体中文本地构建

基于 Robbie Tilton 的 Compositor v1.4.9，提交 `0ab3ff58a3dcf3d52a455fe3ab0336ac95923edd`。原始项目：https://github.com/robbietilton/Compositor 。保留原始 MIT 许可（LICENSE）。

本目录含完整构建所需的 Swift/C/H 源文件、预编译图标与资源、1186 条显示翻译、独立中文版 Info.plist 与沙盒权限。`ChineseUI.swift` 和 `Resources/ChineseUI.json` 提供显示翻译；原始枚举值、快捷键标识和已存在的用户图层名称保持不变。`LocalBuildUpdater` 替代 Sparkle 更新组件，避免中文版被官方英文版本覆盖。

在 Apple Silicon Mac 上，使用 Python 3、Apple Command Line Tools 和 macOS 26.5 SDK：

```sh
python3 build.py
```

输出 `build/Compositor 中文版.app`。SDK 可通过 `--sdk` 显式指定；本次实际构建使用 Swift 6.4 与 macOS 26.5 SDK，未验证其他 SDK。面向 arm64/macOS 26.0；已在当前 Mac 的 macOS 27.0.1 上实机启动并检查。使用本地 ad hoc 签名，没有开发者公证。

本目录的命令行构建不需要 Sparkle、完整 Xcode 或单独 Metal 编译工具；Metal 着色器沿用上游运行时编译方式。资源来自本机官方 1.4.9 应用。附带 docs 用于理解原始项目格式。上游完整测试套件需要完整 Xcode，此构建未运行该套件。

改变翻译 JSON 后须重新签名应用；新增显示词条时仅修改显示边界，不能翻译存储/比较所用的枚举原始值。新版本需按新版源码重新整合并验证。
