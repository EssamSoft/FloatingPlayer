//
//  ZoomBlurTransition.swift
//  FloatingPlayer
//
//  Created by Essam Salah on 21/12/2025.
//

import SwiftUI

extension AnyTransition {
    static var zoomBlur: AnyTransition {
        .asymmetric(
            insertion: .scale(scale: 1.2).combined(with: .opacity).combined(with: .blur),
            removal: .scale(scale: 1.2).combined(with: .opacity).combined(with: .blur)
        )
    }

    private static var blur: AnyTransition {
        .modifier(
            active: BlurModifier(radius: 10),
            identity: BlurModifier(radius: 0)
        )
    }
}

private struct BlurModifier: ViewModifier {
    let radius: CGFloat

    func body(content: Content) -> some View {
        content.blur(radius: radius)
    }
}
