import AppKit

/// Official automatic updates are disabled so they cannot replace the local translation.
@MainActor final class LocalBuildUpdater {
    func start() throws {}
    func checkForUpdates() {
        let alert = NSAlert()
        alert.messageText = "Compositor 简体中文版 1.4.9"
        alert.informativeText = "本地汉化版本，参考 Photoshop 中文术语。为避免汉化被覆盖，此版本已关闭官方自动更新。英文原版可正常更新；新版汉化需要重新制作并验证。"
        alert.addButton(withTitle: "确定")
        alert.runModal()
    }
}
