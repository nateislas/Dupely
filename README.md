# Dupely

Dupely is a premium macOS application designed to keep your focus during high-stakes meetings. It provides a sleek, transparent **HUD (Heads-Up Display)** for your notes, allowing you to reference talking points without breaking eye contact or losing sight of your screen content.

## ✨ Features

### 🖥️ Main Dashboard
*   **Central Control**: A professional macOS dashboard to manage your user profile and application settings.
*   **Profile Management**: Personalized member sidebar and dashboard welcome experience.
*   **Smart HUD Toggle**: A single, large controller to activate or hide your heads-up notes.

### 🌬️ Transparent HUD (Heads-Up Display)
*   **Persistent Visibility**: Built with native `NSPanel` architecture, the HUD follows you across all macOS Spaces and stays visible even over full-screen browser windows.
*   **Glassmorphism Design**: Beautiful, native macOS blur effect using `.ultraThinMaterial` that adapts to your background.
*   **Meeting-Optimized Controls**:
    *   **Auto-Hide UI**: Controls for opacity and font size only appear when you hover, keeping the interface clean for your meeting.
    *   **Non-Blocking**: Designed to be placed anywhere on screen so it doesn't block the interviewer's face.
    *   **Full Keyboard Support**: Seamlessly type notes while the overlay is in focus.

## 🚀 Getting Started

1.  **Open Project**: Launch `Dupely.xcodeproj` in Xcode.
2.  **Build and Run**: Press **⌘R**.
3.  **Launch the HUD**: Use the **Toggle HUD** button in the main dashboard to bring your notes onto the screen.
4.  **Note Persistence**: Your notes are automatically saved and will be right where you left them when you return.

## 🛠 Architecture

*   **Language**: Swift 6.0
*   **Framework**: SwiftUI
*   **Native Integration**: Custom `NSPanel` subclass for the HUD to handle advanced window levels (`.mainMenu`) and cross-context persistence.

## 🔮 Roadmap: Notion & AI Integration

We are expanding Dupely into an intelligent meeting assistant:
*   **Notion Sync**: Direct integration to pull your meeting agendas and project briefs into the HUD.
*   **AI Context**: Real-time LLM support to summarize notes or provide talking points based on your active Notion content.
*   **Bi-directional Save**: Export your HUD notes back to Notion automatically after the meeting.

---
Built with ☕️ on macOS.
