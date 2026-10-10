# Compositor 简体中文版

[Compositor](https://github.com/robbietilton/Compositor) 的非官方简体中文构建，基于 **v1.4.9（44）**，尽量沿用 Photoshop 的中文术语。

这是独立的社区汉化版本，原作者为 **Robbie Tilton**。本仓库不代表原项目或 Adobe 的官方发布；原始源代码遵循 [MIT 许可](LICENSE)。

## 下载与安装

从 [Releases](https://github.com/91godlike/compositor-zh-cn/releases) 下载 `Compositor-1.4.9-zhcn.1-macos-arm64.zip`，解压后将 **Compositor 中文版.app** 放到 Mac 的“应用程序”中。

- 本次发布为 **Apple Silicon / arm64** 构建，最低部署目标为 **macOS 26.0**；已在 macOS 27.0.1 的 Apple Silicon Mac 上启动验证。
- 使用本地 ad hoc 签名，没有 Apple 开发者公证。其他 Mac 的系统验证结果尚未测试。
- 与英文原版使用不同应用名和标识，可以并存。通过“文件 → 打开项目”载入已有 `.comp` 文件。
- 中文版移除官方自动更新组件，避免更新后恢复英文；新版本需重新整合汉化。

## 汉化内容

共 **1186 条翻译词条**，包括菜单、工具提示、图层、调整、滤镜、Camera Raw、快捷键设置、导入导出和常见错误信息。词条数量包含动态提示模板，不等于界面数量。

采用“图层蒙版、剪贴蒙版、正片叠底、滤色、色阶、曲线、自然饱和度、颜色分级、混色器、减少杂色”等常用名称。字体名、项目名、已有用户图层名、品牌名和技术标识保持原样。

只在显示边界翻译；存储格式、枚举原始值和快捷键标识保持上游定义。混合模式下拉框使用单独保存的英文原始值，中文标题不会写入枚举标识。

[翻译对照表](translations.csv) · [验证结果与限制](VERIFICATION.md)

## 构建

需要 Apple Silicon Mac、Python 3、Apple Command Line Tools，以及 **macOS 26.5 SDK**。本次使用 Swift 6.4；其他 SDK/编译器组合未验证。

```sh
python3 build.py
```

也可指定 SDK：

```sh
python3 build.py --sdk /path/to/MacOSX26.5.sdk
```

输出为 `build/Compositor 中文版.app`。仓库包含构建所需的 Swift/C/H 源文件、预编译资源和沙盒权限，无需 Sparkle 或单独的 Metal 编译工具。资源取自匹配版本的官方应用；Metal 着色器沿用运行时编译方式。

`Compositor/ChineseUI.swift` 与 `Resources/ChineseUI.json` 为显示翻译入口。修改资源后必须重新签名。上游完整 XCTest 套件需要完整 Xcode，本次未运行。

## 验证范围

已完成本机新建画布、填充、撤销、存储后重新打开、色阶调整、Camera Raw 中文面板检查、中文混合模式选择、PNG/JPEG 导出。未逐项实测所有滤镜、所有 PSD 文件和所有快捷键，详情见 [验证说明](VERIFICATION.md)。

## 上游与术语参考

- 上游版本：[v1.4.9](https://github.com/robbietilton/Compositor/tree/v1.4.9)
- 固定提交：`0ab3ff58a3dcf3d52a455fe3ab0336ac95923edd`
- [Adobe 混合模式说明](https://helpx.adobe.com/cn/photoshop/desktop/repair-retouch/adjust-light-tone/blending-mode-descriptions.html)
- [Adobe Camera Raw 简介](https://helpx.adobe.com/cn/camera-raw/desktop/get-started/overview-and-setup/introduction-camera-raw.html)

保留 Compositor 品牌名与原始 MIT 许可。问题反馈应提交到本汉化仓库；本版本不代表上游官方发布。
