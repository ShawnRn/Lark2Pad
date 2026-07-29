//
//  Lark2PadApp.swift
//  Lark2Pad
//
//  Created for standalone Lark2Pad app.
//

import AppKit
import SwiftUI
import UserNotifications

// App Appearance Settings
enum AppAppearance: String, CaseIterable, Identifiable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"
    
    var id: String { self.rawValue }
}

class AppDelegate: NSObject, NSApplicationDelegate, UNUserNotificationCenterDelegate {
    private var didFinishLaunching = false

    func applicationDidFinishLaunching(_ notification: Notification) {
        print("✅ Lark2Pad Standalone App started.")
        didFinishLaunching = true

        // Request user notification permissions
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            }
        }
        UNUserNotificationCenter.current().delegate = self

        // Automatically trigger Zaobao fixer at launch if needed
        Task {
            await AutoZaobaoFixer.fixIfNeeded()
        }
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter, willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true // Exit the application when the main window is closed
    }
}

@main
struct Lark2PadApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("app_appearance") private var appearance: AppAppearance = .system
    @StateObject private var updaterController = UpdaterController()

    var body: some Scene {
        Window("爱范儿排版工具", id: "main") {
            Lark2PadFunctionView()
                .frame(minWidth: 800, minHeight: 650)
                .background(
                    VisualEffectBackground(
                        material: .underWindowBackground, blendingMode: .behindWindow)
                )
                .preferredColorScheme(colorScheme)
                .onAppear {
                    applyTheme(appearance)
                }
                .onChange(of: appearance) { old, newValue in
                    applyTheme(newValue)
                }
        }
        .windowStyle(.hiddenTitleBar)
        .commands {
            // Keep it clean and replace standard app info
            CommandGroup(replacing: .appInfo) {
                Button("关于 爱范儿排版工具") {
                    NSApp.orderFrontStandardAboutPanel(nil)
                }
                
                Button("检查更新...") {
                    updaterController.checkForUpdates()
                }
            }
        }
    }

    var colorScheme: ColorScheme? {
        switch appearance {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }

    private func applyTheme(_ theme: AppAppearance) {
        DispatchQueue.main.async {
            switch theme {
            case .light:
                NSApp.appearance = NSAppearance(named: .aqua)
            case .dark:
                NSApp.appearance = NSAppearance(named: .darkAqua)
            case .system:
                NSApp.appearance = nil
            }
        }
    }
}

// Glassmorphism background wrapper
struct VisualEffectBackground: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        view.autoresizingMask = [.width, .height]
        return view
    }
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}

struct TrafficLightManager: ViewModifier {
    var offset: CGPoint
    func body(content: Content) -> some View {
        content.background(TrafficLightEnforcerRepresentable(offset: offset))
    }
}

struct TrafficLightEnforcerRepresentable: NSViewRepresentable {
    var offset: CGPoint
    func makeNSView(context: Context) -> TrafficLightEnforcerView {
        let view = TrafficLightEnforcerView()
        view.customOffset = offset
        return view
    }
    func updateNSView(_ nsView: TrafficLightEnforcerView, context: Context) {
        nsView.customOffset = offset
        nsView.repositionTrafficLights()
    }
}

class TrafficLightEnforcerView: NSView {
    var customOffset: CGPoint = .zero
    
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        setupWindow()
    }
    
    private func setupWindow() {
        guard let window = self.window else { return }
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        repositionTrafficLights()
    }
    
    override func layout() {
        super.layout()
        repositionTrafficLights()
    }
    
    func repositionTrafficLights() {
        guard let window = self.window,
              let superview = window.standardWindowButton(.closeButton)?.superview else { return }
        
        let buttons: [NSWindow.ButtonType] = [.closeButton, .miniaturizeButton, .zoomButton]
        var currentX = customOffset.x
        
        for type in buttons {
            guard let button = window.standardWindowButton(type) else { continue }
            var frame = button.frame
            frame.origin.y = superview.frame.height - customOffset.y - (frame.height / 2)
            frame.origin.x = currentX
            button.setFrameOrigin(frame.origin)
            currentX += button.frame.width + 8
        }
    }
}
