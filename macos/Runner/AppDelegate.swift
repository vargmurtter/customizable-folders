import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }

  override func applicationDidFinishLaunching(_ notification: Notification) {
    // Получаем FlutterViewController из первого окна приложения
    guard let controller = NSApplication.shared.windows.first?.contentViewController as? FlutterViewController else {
      print("Ошибка: Не удалось получить FlutterViewController")
      return
    }

    // Настраиваем платформенный канал, используя engine.binaryMessenger
    let channel = FlutterMethodChannel(name: "com.vargmurtter.customizableFolders/folder_icon", binaryMessenger: controller.engine.binaryMessenger)

    channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "changeFolderIcon" {
        guard let args = call.arguments as? [String: String],
              let folderPath = args["folderPath"],
              let icnsPath = args["icnsPath"] else {
          result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
          return
        }
        
        self.changeFolderIcon(folderPath: folderPath, icnsPath: icnsPath, result: result)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    super.applicationDidFinishLaunching(notification)
  }

  private func changeFolderIcon(folderPath: String, icnsPath: String, result: @escaping FlutterResult) {
    let workspace = NSWorkspace.shared
    let icnsURL = URL(fileURLWithPath: icnsPath)
    let image = NSImage(contentsOf: icnsURL)

    guard let iconImage = image else {
      result(FlutterError(code: "INVALID_IMAGE", message: "Failed to load icon image from \(icnsPath)", details: nil))
      return
    }

    // Устанавливаем иконку для папки
    let success = workspace.setIcon(iconImage, forFile: folderPath, options: [])
    if success {
      result(nil) // Успешное выполнение
    } else {
      result(FlutterError(code: "ICON_SET_FAILED", message: "Failed to set folder icon", details: nil))
    }
  }
}