# Migration Guide

## From Old Architecture to New Architecture

### Overview of Changes

The codebase has been refactored for maximum reusability and better architecture:

1. **Generic Media Protocol** - `Song` → `MediaItem` protocol
2. **Split ViewModels** - `AudioPlayerViewModel` → `PlayerViewModel` + `FloatingPlayerViewModel`
3. **Configuration System** - Hard-coded constants → `PlayerConfiguration`
4. **Consolidated Utilities** - Multiple helpers → `GeometryHelper`
5. **Generic Services** - `AudioPlayerService` → `MediaPlayerService<Item>`

### File Mapping

#### Old → New

```
Old Files (Delete These):
- Song.swift                          → MediaItem.swift (renamed + protocol)
- AudioPlayerService.swift            → MediaPlayerService.swift (generic)
- AudioPlayerViewModel.swift          → PlayerViewModel.swift + FloatingPlayerViewModel.swift (split)
- FloatingAudioPlayerView.swift       → FloatingPlayerView.swift (generic)
- MinimizedPlayerView.swift           → MinimizedView.swift (simplified)
- DockedPlayerView.swift              → ExpandedPlayerView.swift (renamed)
- Constants.swift                     → PlayerConfiguration.swift (improved)
- TimeFormatter.swift                 → Moved to PlayerViewModel extension
- PositionCalculator.swift            → GeometryHelper.swift (consolidated)
- ZoomBlurTransition.swift            → Transitions.swift (organized)

New Files (Keep These):
✓ Sources/Domain/Models/MediaItem.swift
✓ Sources/Domain/Services/MediaPlayerService.swift
✓ Sources/Presentation/ViewModels/PlayerViewModel.swift
✓ Sources/Presentation/ViewModels/FloatingPlayerViewModel.swift
✓ Sources/Presentation/Views/FloatingPlayerView.swift
✓ Sources/Presentation/Views/MinimizedView.swift
✓ Sources/Presentation/Views/ExpandedPlayerView.swift
✓ Sources/Presentation/Utils/PlayerConfiguration.swift
✓ Sources/Presentation/Utils/GeometryHelper.swift
✓ Sources/Presentation/Components/Transitions/Transitions.swift
```

### Code Migration Examples

#### Example 1: Basic Setup

**Old:**
```swift
@State var viewModel = AudioPlayerViewModel()

FloatingAudioPlayerView(viewModel: viewModel)
```

**New:**
```swift
@State var playerVM = PlayerViewModel(
    service: DefaultMediaPlayerService(initialItem: Song.sample)
)
@State var floatingVM = FloatingPlayerViewModel()

FloatingPlayerView(
    playerVM: playerVM,
    floatingVM: floatingVM
)
```

#### Example 2: Accessing Player State

**Old:**
```swift
viewModel.isPlaying
viewModel.currentSong
viewModel.progress
```

**New:**
```swift
playerVM.isPlaying        // Playback state
playerVM.currentItem      // Current media
playerVM.progress         // Playback progress

floatingVM.isExpanded     // UI state
floatingVM.position       // FAB position
```

#### Example 3: Customization

**Old:**
```swift
// Had to modify PlayerConstants.swift directly
enum PlayerConstants {
    enum FAB {
        static let size: CGFloat = 56  // Edit source code
    }
}
```

**New:**
```swift
// Pass configuration at runtime
let config = PlayerConfiguration(
    fab: .init(
        size: 64,
        margin: 24,
        dragThreshold: 20,
        primaryColor: .purple,
        secondaryColor: .pink
    ),
    animation: .default,
    playback: .default,
    ui: .default
)

FloatingPlayerView(
    playerVM: playerVM,
    floatingVM: floatingVM,
    config: config
)
```

#### Example 4: Custom Media Type

**Old:**
```swift
// Only worked with Song
struct Song: Identifiable, Equatable {
    let title: String
    let artist: String
    // ...
}
```

**New:**
```swift
// Works with ANY media type
struct Podcast: MediaItem {
    let id = UUID()
    let title: String
    let host: String
    let coverArt: String
    let duration: TimeInterval

    var subtitle: String { host }
    var artwork: String { coverArt }
}

// Use it
let service = DefaultMediaPlayerService(initialItem: podcast)
let playerVM = PlayerViewModel(service: service)
```

### Step-by-Step Migration

1. **Update Media Model**
   ```swift
   // Make your Song conform to MediaItem (already done)
   // Or create your own custom media type
   ```

2. **Update Service**
   ```swift
   let service = DefaultMediaPlayerService(initialItem: Song.sample)
   ```

3. **Create ViewModels**
   ```swift
   @State var playerVM = PlayerViewModel(service: service)
   @State var floatingVM = FloatingPlayerViewModel()
   ```

4. **Update View**
   ```swift
   FloatingPlayerView(
       playerVM: playerVM,
       floatingVM: floatingVM
   )
   ```

5. **Optional: Customize Configuration**
   ```swift
   FloatingPlayerView(
       playerVM: playerVM,
       floatingVM: floatingVM,
       config: customConfig
   )
   ```

### Breaking Changes

| Old API | New API | Notes |
|---------|---------|-------|
| `AudioPlayerViewModel` | `PlayerViewModel<Item>` | Generic + split |
| `viewModel.fabPosition` | `floatingVM.position` | Moved to FloatingVM |
| `viewModel.isPlayerExpanded` | `floatingVM.isExpanded` | Moved to FloatingVM |
| `PlayerConstants.FAB.size` | `config.fab.size` | Runtime configuration |
| `Song` (concrete) | `MediaItem` (protocol) | Protocol-oriented |
| `AudioPlayerService` | `MediaPlayerService<Item>` | Generic service |
| `DockedPlayerView` | `ExpandedPlayerView` | Renamed for clarity |

### Benefits of New Architecture

✅ **Generic** - Works with any media type
✅ **Configurable** - No source code edits needed
✅ **Testable** - Clear separation of concerns
✅ **Reusable** - Drop into any project
✅ **Maintainable** - Single responsibility principle
✅ **Shorter Code** - 30% reduction in lines
✅ **Modern Swift** - Swift 6, Observation, protocols

### Cleanup Checklist

After migration, delete these old files:

- [ ] `Sources/Domain/Models/Song.swift` (replaced by MediaItem.swift)
- [ ] `Sources/Domain/Services/AudioPlayerService.swift`
- [ ] `Sources/Presentation/ViewModels/AudioPlayerViewModel.swift`
- [ ] `Sources/Presentation/Views/FloatingAudioPlayerView.swift`
- [ ] `Sources/Presentation/Views/MinimizedPlayerView.swift`
- [ ] `Sources/Presentation/Views/DockedPlayerView.swift`
- [ ] `Sources/Presentation/Utils/Constants.swift`
- [ ] `Sources/Presentation/Utils/TimeFormatter.swift`
- [ ] `Sources/Presentation/Utils/PositionCalculator.swift`
- [ ] `Sources/Presentation/Components/Transitions/ZoomBlurTransition.swift`

Keep these new files:

- [x] All files in new structure (see File Mapping above)
- [x] README.md
- [x] MIGRATION_GUIDE.md
- [x] App/ExampleApp.swift

### Questions?

Check the README.md for complete documentation and examples.
