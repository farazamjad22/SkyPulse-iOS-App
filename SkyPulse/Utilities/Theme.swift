//
//  IsDarkModeKey.swift
//  SkyPulse
//
//  Created by Faraz Amjad on 22.02.26.
//

import SwiftUI

// MARK: - Environment Key for Dark Mode

struct IsDarkModeKey: EnvironmentKey {
    static let defaultValue = true
}

extension EnvironmentValues {
    var isDarkMode: Bool {
        get { self[IsDarkModeKey.self] }
        set { self[IsDarkModeKey.self] = newValue }
    }
}

// MARK: - Color Extension for Hex

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Theme

enum Theme {

    // MARK: Card Color

    static func cardColor(isDark: Bool) -> Color {
        isDark ? Color(hex: "1E2D45") : Color.white
    }

    // MARK: Accent Color

    static func accentColor(isDark: Bool) -> Color {
        isDark ? Color(hex: "4FC3F7") : Color(hex: "0288D1")
    }

    // MARK: Text Colors

    static func primaryTextColor(isDark: Bool) -> Color {
        isDark ? .white : Color(hex: "1A1A2E")
    }

    static func secondaryTextColor(isDark: Bool) -> Color {
        isDark ? Color(hex: "8EACC8") : Color(hex: "5A7A94")
    }

    // MARK: Card Shadow

    static func cardShadowColor(isDark: Bool) -> Color {
        isDark ? Color.black.opacity(0.3) : Color.black.opacity(0.08)
    }

    // MARK: Background Gradient (weather-adaptive)

    static func backgroundGradient(for weatherCode: Int, isDark: Bool) -> LinearGradient {
        let colors: [Color]

        if isDark {
            switch weatherCode {
            case 0, 1: // Clear / Mainly Clear — subtle warm tint
                colors = [Color(hex: "0F1B30"), Color(hex: "1E3050")]
            case 2, 3: // Partly Cloudy / Overcast
                colors = [Color(hex: "0B1426"), Color(hex: "1B2A4A")]
            case 45, 48: // Fog
                colors = [Color(hex: "1A2030"), Color(hex: "2A3040")]
            case 51...67: // Drizzle & Rain
                colors = [Color(hex: "081020"), Color(hex: "152035")]
            case 71...77: // Snow
                colors = [Color(hex: "152535"), Color(hex: "253545")]
            case 80...86: // Showers
                colors = [Color(hex: "0A1225"), Color(hex: "162238")]
            case 95...99: // Thunderstorm
                colors = [Color(hex: "050810"), Color(hex: "0D1520")]
            default:
                colors = [Color(hex: "0B1426"), Color(hex: "1B2A4A")]
            }
        } else {
            switch weatherCode {
            case 0, 1: // Clear — warm sky
                colors = [Color(hex: "FFF8E1"), Color(hex: "BBDEFB")]
            case 2, 3: // Cloudy
                colors = [Color(hex: "E8F4FD"), Color(hex: "C9E8F5")]
            case 45, 48: // Fog
                colors = [Color(hex: "E0E8EE"), Color(hex: "C8D4DC")]
            case 51...67: // Rain
                colors = [Color(hex: "D0E4F0"), Color(hex: "B0C8D8")]
            case 71...77: // Snow
                colors = [Color(hex: "ECEFF1"), Color(hex: "CFD8DC")]
            case 80...86: // Showers
                colors = [Color(hex: "D5E5F0"), Color(hex: "B5C8D5")]
            case 95...99: // Storm
                colors = [Color(hex: "B0BEC5"), Color(hex: "90A4AE")]
            default:
                colors = [Color(hex: "E8F4FD"), Color(hex: "C9E8F5")]
            }
        }

        return LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom)
    }

    // MARK: Default Background (no weather data)

    static func defaultBackground(isDark: Bool) -> LinearGradient {
        let colors: [Color] = isDark
            ? [Color(hex: "0B1426"), Color(hex: "1B2A4A")]
            : [Color(hex: "E8F4FD"), Color(hex: "C9E8F5")]
        return LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom)
    }
}
