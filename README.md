# Lark2Pad

Lark2Pad is a standalone macOS utility to convert飛书 (Lark) rich text clipboard documents into clean Markdown and sync them directly to your company's Etherpad server or WordPress media libraries.

## Features
- **One-click Clipboard Parsing**: Paste copied Lark Cloud Document rich text HTML directly to convert it to clean Markdown.
- **Local Markdown File Support**: Drag and drop `.md` or `.markdown` files to parse local image references and sync them.
- **Image Auto-Upload**: Automatically uploads document images to your company's private image hosting server.
- **Synchronize to Etherpad**: Easily sync the converted document directly to your company's Etherpad pad.
- **Premium Glassmorphic Design**: Clean macOS SwiftUI layout with native window-level visual effects.
- **Sparkle Auto-Updates**: In-app automatic updates and manual update verification via the system menu.

## Build Prerequisites
- **macOS**: 15.6+
- **Xcode**: 16.0+
- **Homebrew**: For building styled DMG releases.

## Compiling locally
To compile the debug version of the app:
```bash
xcodebuild -project "Lark2Pad.xcodeproj" -scheme "Lark2Pad" -configuration Debug build
```

## Creating Releases
1. Build the Release archive and generate the DMG package:
   ```bash
   ./scripts/build.sh release
   ```
2. Generate the Sparkle appcast update signatures and release on GitHub:
   ```bash
   ./scripts/release.sh <version>
   ```
