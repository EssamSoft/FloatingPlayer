//
//  FloatingPlayerTests.swift
//  FloatingPlayer Package Tests
//
//  Created by Essam Salah on 21/12/2025.
//

/*
import Testing
import SwiftUI
@testable import FloatingPlayer

@Suite("FloatingPlayer Package Tests")
struct FloatingPlayerTests {
    
    @Suite("AudioItem Tests")
    struct AudioItemTests {
        
        @Test("DefaultAudioItem initialization")
        func defaultAudioItemInitialization() async throws {
            let item = DefaultAudioItem(
                title: "Test Song",
                artist: "Test Artist",
                duration: 180
            )
            
            #expect(item.title == "Test Song")
            #expect(item.artist == "Test Artist")
            #expect(item.duration == 180)
            #expect(item.artworkURL == nil)
            #expect(item.metadata.isEmpty)
        }
        
        @Test("AudioItem with metadata")
        func audioItemWithMetadata() async throws {
            let metadata = ["album": "Test Album", "year": 2023]
            let item = DefaultAudioItem(
                title: "Test Song",
                artist: "Test Artist", 
                duration: 180,
                metadata: metadata
            )
            
            #expect(item.metadata["album"] as? String == "Test Album")
            #expect(item.metadata["year"] as? Int == 2023)
        }
    }
    
    @Suite("TimeFormatter Tests")
    struct TimeFormatterTests {
        
        @Test("Format seconds to minutes and seconds")
        func formatSecondsToMinutesAndSeconds() async throws {
            #expect(TimeFormatter.format(0) == "0:00")
            #expect(TimeFormatter.format(30) == "0:30")
            #expect(TimeFormatter.format(90) == "1:30")
            #expect(TimeFormatter.format(3661) == "1:01:01")
        }
        
        @Test("Format remaining time")
        func formatRemainingTime() async throws {
            #expect(TimeFormatter.formatRemaining(current: 30, total: 90) == "-1:00")
            #expect(TimeFormatter.formatRemaining(current: 45, total: 90) == "-0:45")
        }
        
        @Test("Calculate progress")
        func calculateProgress() async throws {
            #expect(TimeFormatter.progress(current: 0, total: 100) == 0.0)
            #expect(TimeFormatter.progress(current: 50, total: 100) == 0.5)
            #expect(TimeFormatter.progress(current: 100, total: 100) == 1.0)
            #expect(TimeFormatter.progress(current: 150, total: 100) == 1.0) // Clamped to 1.0
        }
    }
    
    @Suite("FloatingPlayerViewModel Tests")
    struct FloatingPlayerViewModelTests {
        
        @Test("Initial state")
        func initialState() async throws {
            let viewModel = FloatingPlayerViewModel()
            
            #expect(viewModel.isPlayerExpanded == false)
            #expect(viewModel.isFavorite == false)
            #expect(viewModel.fabPosition == .zero)
            #expect(viewModel.isDragging == false)
            #expect(viewModel.currentItem == nil)
        }
        
        @Test("Play audio item")
        func playAudioItem() async throws {
            let viewModel = FloatingPlayerViewModel()
            let testItem = DefaultAudioItem(
                title: "Test Song",
                artist: "Test Artist",
                duration: 180
            )
            
            viewModel.play(item: testItem)
            
            #expect(viewModel.currentItem?.title == "Test Song")
            #expect(viewModel.isPlaying == true)
        }
        
        @Test("Toggle playback")
        func togglePlayback() async throws {
            let viewModel = FloatingPlayerViewModel()
            let testItem = DefaultAudioItem(
                title: "Test Song",
                artist: "Test Artist",
                duration: 180
            )
            
            viewModel.play(item: testItem)
            #expect(viewModel.isPlaying == true)
            
            viewModel.togglePlayback()
            #expect(viewModel.isPlaying == false)
            
            viewModel.togglePlayback()
            #expect(viewModel.isPlaying == true)
        }
        
        @Test("Player expansion state")
        func playerExpansionState() async throws {
            let viewModel = FloatingPlayerViewModel()
            
            #expect(viewModel.isPlayerExpanded == false)
            
            viewModel.showExpandedPlayer()
            #expect(viewModel.isPlayerExpanded == true)
            
            viewModel.hideExpandedPlayer()
            #expect(viewModel.isPlayerExpanded == false)
            
            viewModel.togglePlayerExpansion()
            #expect(viewModel.isPlayerExpanded == true)
        }
    }
    
    @Suite("Configuration Tests")
    struct ConfigurationTests {
        
        @Test("Default configuration")
        func defaultConfiguration() async throws {
            let config = FloatingPlayerConfiguration.default
            
            #expect(config.animation.springResponse == 0.6)
            #expect(config.animation.springDamping == 0.8)
            #expect(config.styling.cornerRadius == 12)
            #expect(config.playback.skipInterval == 15)
            #expect(config.positioning.snapToCorners == true)
        }
        
        @Test("Custom configuration")
        func customConfiguration() async throws {
            let config = FloatingPlayerConfiguration(
                animation: AnimationConfiguration(springResponse: 0.8),
                styling: StylingConfiguration(cornerRadius: 20),
                playback: PlaybackConfiguration(skipInterval: 30)
            )
            
            #expect(config.animation.springResponse == 0.8)
            #expect(config.styling.cornerRadius == 20)
            #expect(config.playback.skipInterval == 30)
        }
    }
    
    @Suite("PositionCalculator Tests")
    struct PositionCalculatorTests {
        
        @Test("Distance calculation")
        func distanceCalculation() async throws {
            let point1 = CGPoint(x: 0, y: 0)
            let point2 = CGPoint(x: 3, y: 4)
            
            let distance = PositionCalculator.distance(from: point1, to: point2)
            #expect(distance == 5.0) // 3-4-5 triangle
        }
        
        @Test("Initial position calculation")
        func initialPositionCalculation() async throws {
            let screenSize = CGSize(width: 400, height: 800)
            let safeAreaInsets = EdgeInsets()
            let edgeInsets = EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
            
            let topLeading = PositionCalculator.initialPosition(
                for: .topLeading,
                screenSize: screenSize,
                safeAreaInsets: safeAreaInsets,
                edgeInsets: edgeInsets
            )
            
            #expect(topLeading.x == 16)
            #expect(topLeading.y == 16)
        }
        
        @Test("Position constraining")
        func positionConstraining() async throws {
            let screenSize = CGSize(width: 400, height: 800)
            let safeAreaInsets = EdgeInsets()
            let edgeInsets = EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
            let elementSize = CGSize(width: 64, height: 64)
            
            // Test position outside bounds
            let outsidePosition = CGPoint(x: -50, y: -50)
            let constrainedPosition = PositionCalculator.constrainPosition(
                outsidePosition,
                within: screenSize,
                safeAreaInsets: safeAreaInsets,
                edgeInsets: edgeInsets,
                elementSize: elementSize
            )
            
            #expect(constrainedPosition.x == 16) // Constrained to min
            #expect(constrainedPosition.y == 16) // Constrained to min
        }
    }
}
*/
