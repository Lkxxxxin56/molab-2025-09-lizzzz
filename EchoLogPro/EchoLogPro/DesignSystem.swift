//
//  DesignSystem.swift
//  EchoLog
//
//  Created by Manus AI on 11/8/25.
//

import SwiftUI

// MARK: - Color Theme

struct AppColors {
    // Primary Colors
    static let primaryGreen = Color(hex: "A8C256") ?? Color.green
    static let darkGreen = Color(hex: "8BA84A") ?? Color.green
    static let lightGreen = Color(hex: "C5D98E") ?? Color.green
    
    // Neutral Colors
    static let background = Color(hex: "F5F5F0") ?? Color(white: 0.96)
    static let cardBackground = Color.white
    static let darkCard = Color(hex: "1A1A1A") ?? Color.black
    static let textPrimary = Color(hex: "1A1A1A") ?? Color.black
    static let textSecondary = Color(hex: "666666") ?? Color.gray
    
    // Accent Colors
    static let accentOrange = Color(hex: "FF9F66") ?? Color.orange
    static let accentBlue = Color(hex: "6B9BD1") ?? Color.blue
    static let accentYellow = Color(hex: "FFD166") ?? Color.yellow
}

// MARK: - Typography

struct AppTypography {
    static let largeTitle = Font.system(size: 48, weight: .black, design: .rounded)
    static let title1 = Font.system(size: 32, weight: .bold, design: .rounded)
    static let title2 = Font.system(size: 24, weight: .bold, design: .rounded)
    static let title3 = Font.system(size: 20, weight: .semibold, design: .rounded)
    static let headline = Font.system(size: 17, weight: .semibold, design: .rounded)
    static let body = Font.system(size: 15, weight: .regular, design: .rounded)
    static let caption = Font.system(size: 13, weight: .medium, design: .rounded)
    static let small = Font.system(size: 11, weight: .regular, design: .rounded)
}

// MARK: - Spacing

struct AppSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}

// MARK: - Corner Radius

struct AppRadius {
    static let sm: CGFloat = 12
    static let md: CGFloat = 20
    static let lg: CGFloat = 28
    static let xl: CGFloat = 36
}

// MARK: - Custom View Modifiers

struct CardStyle: ViewModifier {
    var backgroundColor: Color = AppColors.cardBackground
    var cornerRadius: CGFloat = AppRadius.lg
    
    func body(content: Content) -> some View {
        content
            .padding(AppSpacing.md)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
    }
}

struct DarkCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(AppSpacing.md)
            .background(AppColors.darkCard)
            .cornerRadius(AppRadius.lg)
    }
}

struct PillButtonStyle: ViewModifier {
    var backgroundColor: Color = AppColors.darkCard
    var foregroundColor: Color = .white
    
    func body(content: Content) -> some View {
        content
            .font(AppTypography.headline)
            .foregroundColor(foregroundColor)
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.md)
            .background(backgroundColor)
            .cornerRadius(AppRadius.xl)
    }
}

// MARK: - View Extensions

extension View {
    func cardStyle(backgroundColor: Color = AppColors.cardBackground, cornerRadius: CGFloat = AppRadius.lg) -> some View {
        modifier(CardStyle(backgroundColor: backgroundColor, cornerRadius: cornerRadius))
    }
    
    func darkCardStyle() -> some View {
        modifier(DarkCardStyle())
    }
    
    func pillButton(backgroundColor: Color = AppColors.darkCard, foregroundColor: Color = .white) -> some View {
        modifier(PillButtonStyle(backgroundColor: backgroundColor, foregroundColor: foregroundColor))
    }
}

// MARK: - Color Extension for Hex

extension Color {
    init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
