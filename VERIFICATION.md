# Compositor 本地简体中文版

已于 2026-10-10 安装并启动 `/Applications/Compositor 中文版.app`，基于官方 1.4.9（44），源代码固定为 v1.4.9 / `0ab3ff58a3dcf3d52a455fe3ab0336ac95923edd`。英文原版 `/Applications/Compositor.app` 保留，其签名验证通过。

## 使用

在“应用程序”里启动 **Compositor 中文版**。菜单、工具提示、画布、图层、调整、滤镜、Camera Raw、快捷键设置、导入导出及常见错误提示已加入中文翻译。翻译词典共 1186 条，包括动态提示模板；这一数字不是 1186 个不同界面。字体名、用户原有图层名/项目名、品牌名和 RGB、PNG 等技术标识保持原样。系统对话框语言由 macOS 决定。

术语尽量沿用 Photoshop，例如“图层蒙版、剪贴蒙版、正片叠底、滤色、颜色减淡、色阶、曲线、自然饱和度、颜色分级、混色器、减少杂色”。参考 [Adobe 混合模式说明](https://helpx.adobe.com/cn/photoshop/desktop/repair-retouch/adjust-light-tone/blending-mode-descriptions.html) 与 [Adobe Camera Raw 简介](https://helpx.adobe.com/cn/camera-raw/desktop/get-started/overview-and-setup/introduction-camera-raw.html)。Compositor 特有功能按实际含义翻译，功能本身保持上游实现。

可以通过“文件 → 打开项目”打开现有 `.comp` 文件。存储后的项目格式仍为上游格式；正常编辑和存储会修改所打开的项目，建议重要项目先保留副本。中文版采用独立应用标识与偏好设置，不自动迁移原版最近打开列表，也没有主动修改用户既有项目。

## 本机验证结果

| 检查 | 实际结果 |
|---|---|
| 构建与启动 | Swift 6.4、macOS 26.5 SDK 优化构建成功；Apple Silicon / macOS 27.0.1 实机启动成功 |
| 签名 | 输出应用和已安装中文版均通过 `codesign --verify --strict`；保留应用沙盒与用户选定文件读写权限 |
| 主界面 | 新建画布、工具提示、图层区中文正常；新建默认图层名称为“图层 1” |
| 新建/填充/撤销 | 创建 64×64 测试画布，填充背景色，最终版撤销后返回新建界面成功 |
| 存储/重新打开 | 新建测试 `.comp` 工程已存储、退出后重新打开成功 |
| 色阶 | 中文命令搜索找到“色阶”；调整中间调至 1.10 并应用成功，撤销标题显示“色阶” |
| Camera Raw | 最终版实际打开，核对“光线、曝光度、高光、阴影、自然饱和度、颜色分级”等；截图检查可见文字和控件正常；预览后取消成功 |
| 混合模式 | 实际选择“正片叠底”并存储，工程内仍为原始 `Multiply`；原有 `Layer 1` 名称未被翻译 |
| 导出 | 实际导出 PNG 与 JPEG 文件，系统图像工具确认两者均为 64×64 |
| 翻译模板 | 1186 条键值的数字占位符集合全部匹配 |
| 文件格式代码 | `ProjectStore.swift`、`PSDDocumentBuilder.swift`、`PSDReader.swift`、`ImageExporter.swift` 与固定上游源代码逐字节一致 |

测试使用新建样本。未逐一实测所有滤镜、所有 PSD 输入和所有快捷键；本机没有完整 Xcode，未运行上游 XCTest 全套。以上结果只对应本机、本版，不代表 Intel Mac、其他系统或未来版本验证。

## 更新、安装包与恢复

- 当前已安装，可直接使用；`Compositor-1.4.9-zhcn.1-macos-arm64.zip` 用于备份和重新安装，解压后将应用放入“应用程序”。
- 本版使用本地 ad hoc 签名，没有官方开发者签名与公证。本机已经启动验证；其他 Mac 的系统验证结果未测试。
- 中文版已移除 Sparkle 官方更新组件，避免自动更新回英文版；原版更新功能不受影响。官方新版本需要重新整合和验证汉化。
- 恢复使用英文版：退出中文版，再启动原来的 **Compositor** 即可。可将独立中文版移到废纸篓，原应用无需恢复。
- `Compositor-1.4.9-zhcn.1-source.zip` 包含构建所需源码、资源、翻译词典、构建脚本和原始 MIT 许可；`translations-zh-CN.csv` 可查看全部译文。
