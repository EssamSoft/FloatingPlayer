# Generic Floating Player for SwiftUI

A highly reusable, protocol-oriented floating media player for SwiftUI with drag-to-reposition, snap-to-corner, and smooth animations.

## Features

- **Generic & Reusable**: Works with any media type conforming to `MediaItem`
- **Drag & Drop**: Draggable floating button with snap-to-corner behavior
- **Dual UI States**: Minimized (floating) and expanded (docked) modes
- **Configurable**: Easy customization via `PlayerConfiguration`
- **Clean Architecture**: Separation of concerns (Player logic vs UI state)
- **Modern SwiftUI**: Uses Swift 6, Observation framework, and modern patterns

## Architecture

```
┌─────────────────────────────────────┐
│         Domain Layer                │
├─────────────────────────────────────┤
│ MediaItem Protocol                  │ ← Generic media abstraction
│ MediaPlayerService                  │ ← Playback logic
└─────────────────────────────────────┘
           ↓
┌─────────────────────────────────────┐
│      Presentation Layer             │
├─────────────────────────────────────┤
│ PlayerViewModel                     │ ← Playback state & controls
│ FloatingPlayerViewModel             │ ← UI state & positioning
│ FloatingPlayerView                  │ ← Container view
│ MinimizedView / ExpandedPlayerView  │ ← UI states
└─────────────────────────────────────┘
```

## Quick Start

### 1. Define Your Media Type

```swift
struct Song: MediaItem {
    let id = UUID()
    let title: String
    let artist: String
    let albumArt: String
    let duration: TimeInterval

    var subtitle: String { artist }
    var artwork: String { albumArt }
}
```

### 2. Create ViewModels

```swift
// Player service (handles playback)
let service = DefaultMediaPlayerService(initialItem: Song.sample)

// ViewModels
let playerVM = PlayerViewModel(service: service)
let floatingVM = FloatingPlayerViewModel()
```

### 3. Use in Your View

```swift
struct ContentView: View {
    @State private var playerVM = PlayerViewModel(
        service: DefaultMediaPlayerService(initialItem: Song.sample)
    )
    @State private var floatingVM = FloatingPlayerViewModel()

    var body: some View {
        ZStack {
            YourMainContent()

            FloatingPlayerView(
                playerVM: playerVM,
                floatingVM: floatingVM
            )
        }
    }
}
```

## Customization

### Custom Configuration

```swift
let customConfig = PlayerConfiguration(
    fab: .init(
        size: 64,
        margin: 24,
        dragThreshold: 20,
        primaryColor: .purple,
        secondaryColor: .pink
    ),
    animation: .init(
        springResponse: 0.5,
        springDamping: 0.85,
        snapResponse: 0.4,
        snapDamping: 0.8
    ),
    playback: .init(skipInterval: 30),
    ui: .init(
        cornerRadius: 20,
        shadowRadius: 10,
        progressBarHeight: 3
    )
)

FloatingPlayerView(
    playerVM: playerVM,
    floatingVM: floatingVM,
    config: customConfig
)
```

### Custom Media Type

```swift
struct Podcast: MediaItem {
    let id = UUID()
    let title: String
    let host: String
    let coverArt: String
    let duration: TimeInterval

    var subtitle: String { host }
    var artwork: String { coverArt }
}
```

### Custom Player Service

Implement `MediaPlayerService` for custom playback logic:

```swift
final class AVAudioPlayerService: MediaPlayerService {
    var currentItem: Song?
    var isPlaying = false
    var currentTime: TimeInterval = 0

    // Implement actual AVAudioPlayer integration
    func play() { /* ... */ }
    func pause() { /* ... */ }
    // ...
}
```

## Components

### Core Types

- **`MediaItem`**: Protocol for any playable media
- **`MediaPlayerService`**: Generic playback service protocol
- **`PlayerViewModel`**: Manages playback state and controls
- **`FloatingPlayerViewModel`**: Manages UI state and positioning

### Views

- **`FloatingPlayerView`**: Main container switching between states
- **`MinimizedView`**: Floating action button with drag support
- **`ExpandedPlayerView`**: Full docked player UI

### Utilities

- **`PlayerConfiguration`**: Centralized configuration
- **`GeometryHelper`**: Corner detection and positioning
- **`Transitions`**: Custom view transitions

## Integration into Existing Projects

1. **Copy the entire `Sources` folder** into your project
2. **Define your media type** conforming to `MediaItem`
3. **Create or use** `DefaultMediaPlayerService` (or implement custom)
4. **Initialize ViewModels** and add `FloatingPlayerView` to your UI
5. **Customize** via `PlayerConfiguration` as needed

## File Structure

```
Sources/
├── Domain/
│   ├── Models/
│   │   └── MediaItem.swift          ← Generic media protocol + Song
│   └── Services/
│       └── MediaPlayerService.swift ← Generic player service
└── Presentation/
    ├── ViewModels/
    │   ├── PlayerViewModel.swift           ← Playback logic
    │   └── FloatingPlayerViewModel.swift   ← UI state
    ├── Views/
    │   ├── FloatingPlayerView.swift        ← Main container
    │   ├── MinimizedView.swift             ← Floating button
    │   └── ExpandedPlayerView.swift        ← Docked player
    ├── Utils/
    │   ├── PlayerConfiguration.swift       ← Configuration
    │   └── GeometryHelper.swift            ← Positioning logic
    └── Components/
        └── Transitions/
            └── Transitions.swift           ← Custom transitions
```

## Requirements

- iOS 17.0+
- Swift 6.0+
- SwiftUI

## License

MIT License - Feel free to use in your projects!

## Example Projects

Check the `App/` folder for a complete working example demonstrating:
- Basic usage with Song media type
- Custom configuration
- Integration with navigation
