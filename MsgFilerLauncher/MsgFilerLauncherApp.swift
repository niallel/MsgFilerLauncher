import SwiftUI
import HotKey
import ApplicationServices
import AppKit

@main
struct MsgFilerLauncherApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        // No UI needed
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var hotKey: HotKey?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Register the hotkey for Cmd + 9
        hotKey = HotKey(key: .nine, modifiers: [.command])
        hotKey?.keyDownHandler = {
            self.handleHotKey()
        }
    }
    
    func handleHotKey() {
        let bundleIdentifier = "com.atow.MsgFiler4" // Replace with your app's bundle identifier

        if isAppRunning(bundleIdentifier: bundleIdentifier) {
            bringAppToFront(bundleIdentifier: bundleIdentifier)
        } else {
            launchApp(bundleIdentifier: bundleIdentifier)
        }
    }

    func isAppRunning(bundleIdentifier: String) -> Bool {
        let runningApps = NSWorkspace.shared.runningApplications
        return runningApps.contains { $0.bundleIdentifier == bundleIdentifier }
    }

    func bringAppToFront(bundleIdentifier: String) {
        guard let app = NSRunningApplication.runningApplications(withBundleIdentifier: bundleIdentifier).first else { return }
        app.activate(options: [.activateAllWindows])
        print("msgFiler 4 brought to front")
    }

    func launchApp(bundleIdentifier: String) {
        guard let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleIdentifier) else {
            print("Application with bundle identifier \(bundleIdentifier) not found.")
            return
        }

        let configuration = NSWorkspace.OpenConfiguration()
        configuration.activates = true
        configuration.allowsRunningApplicationSubstitution = false

        NSWorkspace.shared.openApplication(at: appURL, configuration: configuration) { (runningApp, error) in
            if let error = error {
                print("Failed to launch msgFiler 4: \(error.localizedDescription)")
            } else {
                print("msgFiler 4 launched successfully.")
            }
        }
    }

}
