# Dupely

Dupely is an application for focus during meetings. It provides a HUD (Heads-Up Display) for notes. This allows reference to points without breaking contact or losing sight of content.

## Features

### Dashboard
*   **Control**: A dashboard to manage profile and settings.
*   **Profile**: Sidebar and dashboard experience.
*   **HUD Toggle**: Controller to activate or hide notes.

### HUD (Heads-Up Display)
*   **Visibility**: Built with NSPanel architecture, the HUD moves across Spaces and stays in view over windows.
*   **Design**: Effect using .ultraThinMaterial that adapts to background.
*   **Controls**:
    *   **UI**: Controls for opacity and size appear when you hover for meeting.
    *   **Placement**: Designed to be placed on screen so it doesn't block interviewer face.
    *   **Keyboard**: Type notes while HUD has focus.

## Getting Started

1.  **Open**: Launch Dupely.xcodeproj in Xcode.
2.  **Build**: Press ⌘R.
3.  **Launch**: Use the toggle in the dashboard to bring notes onto screen.
4.  **Persistence**: Notes are saved and will be there when you return.

## Architecture

*   **Language**: Swift
*   **Framework**: SwiftUI
*   **Integration**: NSPanel subclass for HUD to handle window levels and context persistence.

## Roadmap: Notion & AI

We are expanding Dupely into a meeting assistant:
*   **Notion**: Integration to pull agendas and briefs into HUD.
*   **AI**: LLM support to summarize notes or provide points based on Notion content.
*   **Save**: Export HUD notes back to Notion after meeting.

---
Built with on macOS.
