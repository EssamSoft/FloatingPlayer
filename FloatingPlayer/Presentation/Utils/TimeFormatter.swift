//
//  TimeFormatter.swift
//  FloatingPlayer
//
//  Created by Essam Salah on 21/12/2025.
//

import Foundation

enum TimeFormatter {
    static func format(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    static func formatRemaining(current: TimeInterval, total: TimeInterval) -> String {
        format(total - current)
    }

    static func progress(current: TimeInterval, total: TimeInterval) -> Double {
        guard total > 0 else { return 0 }
        return current / total
    }
}
