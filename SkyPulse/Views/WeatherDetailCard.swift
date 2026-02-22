//
//  WeatherDetailCard.swift
//  SkyPulse
//
//  Created by Faraz Amjad on 22.02.26.
//

import SwiftUI

struct WeatherDetailCard: View {
    let title: String
    let value: String
    let icon: String

    @Environment(\.isDarkMode) private var isDarkMode

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(Theme.accentColor(isDark: isDarkMode))

            Text(title)
                .font(.caption)
                .foregroundStyle(Theme.secondaryTextColor(isDark: isDarkMode))

            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(Theme.primaryTextColor(isDark: isDarkMode))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Theme.cardColor(isDark: isDarkMode))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Theme.cardShadowColor(isDark: isDarkMode), radius: 4, x: 0, y: 2)
    }
}
