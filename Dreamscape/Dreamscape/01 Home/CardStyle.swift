//
//  CardStyle.swift
//  Dreamscape
//
//  Created by Kexin Liu on 12/4/25.
//

import SwiftUI

struct DreamCardStyle: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(cardBackgroundColor)
            )
            .overlay(
                // Subtle border in dark mode to separate card from background
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(borderColor, lineWidth: colorScheme == .dark ? 1 : 0)
            )
            .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: shadowYOffset)
    }
    
    private var cardBackgroundColor: Color {
        if colorScheme == .dark {
            // Slightly lighter than full background
            return Color(.secondarySystemBackground)
        } else {
            return Color(.systemBackground)
        }
    }
    
    private var borderColor: Color {
        colorScheme == .dark
            ? Color.white.opacity(0.08)   // soft outline in dark mode
            : Color.clear
    }
    
    private var shadowColor: Color {
        colorScheme == .dark
            ? Color.black.opacity(0.4)    // subtle, tighter shadow
            : Color.black.opacity(0.06)
    }
    
    private var shadowRadius: CGFloat {
        colorScheme == .dark ? 4 : 8
    }
    
    private var shadowYOffset: CGFloat {
        colorScheme == .dark ? 2 : 4
    }
}

extension View {
    func dreamCardStyle() -> some View {
        self.modifier(DreamCardStyle())
    }
}
