//
//  DupelyApp.swift
//  Dupely
//
//  Created by Nathaniel Islas on 1/20/26.
//

import SwiftUI

@main
struct DupelyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MainDashboardView()
                .frame(minWidth: 600, minHeight: 400)
        }
        .windowStyle(.hiddenTitleBar)
        
        Settings {
            EmptyView()
        }
    }
}

class DupelyPanel: NSPanel {
    override var canBecomeKey: Bool {
        return true
    }
    
    override var canBecomeMain: Bool {
        return false // Panels usually shouldn't be 'Main' if they are auxiliary, prevents hiding
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    static var shared: AppDelegate!
    var floatingNoteWindow: NSPanel?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        AppDelegate.shared = self
        // Set to .regular so it appears in the Dock and has a main window
        NSApp.setActivationPolicy(.regular)
    }
    
    func toggleHUD() {
        if let window = floatingNoteWindow {
            if window.isVisible {
                window.orderOut(nil)
            } else {
                showHUD()
            }
        } else {
            showHUD()
        }
    }
    
    func showHUD() {
        if floatingNoteWindow == nil {
            let panel = DupelyPanel(
                contentRect: NSRect(x: 100, y: 100, width: 450, height: 350),
                styleMask: [.borderless, .resizable, .nonactivatingPanel, .hudWindow],
                backing: .buffered,
                defer: false
            )
            
            panel.isOpaque = false
            panel.backgroundColor = .clear
            // .mainMenu level is very safe for overlays usage
            panel.level = .mainMenu
            panel.isMovableByWindowBackground = true
            panel.isReleasedWhenClosed = false
            
            // .canJoinAllSpaces: Follow spaces
            // .fullScreenAuxiliary: Show over full screen apps
            // .stationary: Don't move when exposing/mission control
            panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]
            
            // CRITICAL: prevents the panel from hiding when you click Safari
            panel.hidesOnDeactivate = false
            panel.isFloatingPanel = true
            
            let noteView = NoteView(onClose: { [weak self] in
                self?.floatingNoteWindow?.orderOut(nil)
            })
            
            panel.contentView = NSHostingView(rootView: noteView)
            self.floatingNoteWindow = panel
        }
        
        // orderFront instead of makeKeyAndOrderFront prevents stealing focus aggressively
        // causing main app deactivation issues in some edge cases
        floatingNoteWindow?.orderFront(nil)
    }
}

struct MainDashboardView: View {
    @State private var userName = "Nathaniel Islas"
    @State private var userBio = "Building Dupely - The smart meeting overlay."
    
    var body: some View {
        HStack(spacing: 0) {
            // Sidebar
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 12) {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.blue)
                    
                    VStack(alignment: .leading) {
                        Text(userName)
                            .font(.headline)
                        Text("Pro Member")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.bottom, 20)
                
                DashboardNavButton(icon: "house.fill", title: "Home", isSelected: true)
                DashboardNavButton(icon: "note.text", title: "My Notes", isSelected: false)
                DashboardNavButton(icon: "gearshape.fill", title: "Settings", isSelected: false)
                
                Spacer()
                
                Button(action: { NSApp.terminate(nil) }) {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("Quit Dupely")
                    }
                    .foregroundColor(.red.opacity(0.8))
                }
                .buttonStyle(.plain)
                .padding(.leading, 8)
            }
            .padding(24)
            .frame(width: 200)
            .background(Color(NSColor.windowBackgroundColor))
            
            Divider()
            
            // Main Content
            VStack(alignment: .leading, spacing: 24) {
                Text("Welcome back, \(userName.split(separator: " ").first ?? "")")
                    .font(.system(size: 28, weight: .bold))
                
                Text(userBio)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                // HUD Toggle Button
                Button(action: {
                    AppDelegate.shared.toggleHUD()
                }) {
                    HStack(spacing: 16) {
                        Image(systemName: "macwindow.on.rectangle")
                            .font(.system(size: 24))
                        
                        VStack(alignment: .leading) {
                            Text("Toggle HUD")
                                .font(.headline)
                            Text("Heads-up notes for your meetings")
                                .font(.subheadline)
                                .opacity(0.7)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)
                }
                .buttonStyle(.plain)
                
                Spacer()
            }
            .padding(40)
            .frame(maxWidth: .infinity)
            .background(Color(NSColor.controlBackgroundColor))
        }
    }
}

struct DashboardNavButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 20)
            Text(title)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(isSelected ? Color.blue.opacity(0.1) : Color.clear)
        .foregroundColor(isSelected ? .blue : .primary)
        .cornerRadius(8)
    }
}

struct NoteView: View {
    let onClose: () -> Void
    
    @AppStorage("noteContent_main") private var noteText: String = ""
    @State private var opacity: Double = 0.6
    @State private var fontSize: CGFloat = 18
    @State private var isHovering = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(opacity)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 6)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
                )
            
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "line.3.horizontal")
                        .foregroundColor(.secondary)
                        .font(.system(size: 12, weight: .bold))
                        .opacity(isHovering ? 0.8 : 0.0)
                    Spacer()
                }
                .padding(.top, 8)
                .padding(.horizontal, 16)
                .frame(height: 24)
                
                TextEditor(text: $noteText)
                    .font(.system(size: fontSize, design: .rounded))
                    .foregroundColor(.primary)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                
                if isHovering {
                    HStack(spacing: 16) {
                        HStack(spacing: 6) {
                            Image(systemName: "circle.lefthalf.filled")
                                .font(.caption2)
                            Slider(value: $opacity, in: 0.1...1.0)
                                .frame(width: 80)
                                .controlSize(.small)
                        }
                        .opacity(0.8)
                        
                        HStack(spacing: 4) {
                            Button(action: { fontSize = max(10, fontSize - 2) }) {
                                Image(systemName: "textformat.size.smaller")
                                    .font(.system(size: 12))
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Button(action: { fontSize = min(40, fontSize + 2) }) {
                                Image(systemName: "textformat.size.larger")
                                    .font(.system(size: 14))
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .opacity(0.8)
                        
                        Spacer()
                        
                        Button(action: onClose) {
                            Image(systemName: "minus")
                                .font(.system(size: 10, weight: .bold))
                        }
                        .buttonStyle(GlassButtonStyle())
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
                    .padding(.top, 8)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .onHover { hover in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isHovering = hover
            }
        }
        .frame(minWidth: 300, minHeight: 200)
    }
}

struct GlassButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .background(Color.white.opacity(0.1))
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .foregroundColor(.primary)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}
