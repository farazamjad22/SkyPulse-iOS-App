//
//  ErrorView.swift
//  SkyPulse
//
//  Created by Faraz Amjad on 22.02.26.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    let onRetry: () -> Void

    @Environment(\.isDarkMode) private var isDarkMode

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "exclamationmark.icloud.fill")
                .font(.system(size: 64))
                .foregroundStyle(Theme.secondaryTextColor(isDark: isDarkMode))
                .symbolRenderingMode(.hierarchical)

            Text("Something Went Wrong")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(Theme.primaryTextColor(isDark: isDarkMode))

            Text(message)
                .font(.subheadline)
                .foregroundStyle(Theme.secondaryTextColor(isDark: isDarkMode))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Button(action: onRetry) {
                Label("Try Again", systemImage: "arrow.clockwise")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(Theme.accentColor(isDark: isDarkMode))
                    .clipShape(Capsule())
            }
            .padding(.top, 8)

            Spacer()
        }
    }
}
