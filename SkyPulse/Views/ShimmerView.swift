//
//  ShimmerEffect.swift
//  SkyPulse
//
//  Created by Faraz Amjad on 22.02.26.
//

import SwiftUI

// MARK: - Shimmer Effect Modifier

struct ShimmerEffect: ViewModifier {
    @State private var startPoint: UnitPoint = .init(x: -1.8, y: -1.2)
    @State private var endPoint: UnitPoint = .init(x: 0, y: -0.2)

    private let gradientColors = [
        Color.white.opacity(0.0),
        Color.white.opacity(0.12),
        Color.white.opacity(0.0),
    ]

    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(colors: gradientColors, startPoint: startPoint, endPoint: endPoint)
            )
            .onAppear {
                withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: false)) {
                    startPoint = .init(x: 1, y: 1)
                    endPoint = .init(x: 2.5, y: 2.2)
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerEffect())
    }
}

// MARK: - Skeleton Placeholder

struct SkeletonPlaceholder: View {
    var width: CGFloat? = nil
    var height: CGFloat = 20
    var cornerRadius: CGFloat = 8

    @Environment(\.isDarkMode) private var isDarkMode

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(isDarkMode ? Color.white.opacity(0.08) : Color.black.opacity(0.06))
            .frame(width: width, height: height)
            .shimmer()
    }
}

// MARK: - Full Skeleton Loading View

struct SkeletonLoadingView: View {
    @Environment(\.isDarkMode) private var isDarkMode

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // City name
                SkeletonPlaceholder(width: 160, height: 18)
                    .padding(.top, 8)

                // Weather icon
                Circle()
                    .fill(isDarkMode ? Color.white.opacity(0.08) : Color.black.opacity(0.06))
                    .frame(width: 80, height: 80)
                    .shimmer()

                // Temperature
                SkeletonPlaceholder(width: 120, height: 56, cornerRadius: 12)

                // Condition
                SkeletonPlaceholder(width: 100, height: 16)

                // Detail grid (2x3)
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(0..<6, id: \.self) { _ in
                        SkeletonPlaceholder(height: 90, cornerRadius: 16)
                    }
                }
                .padding(.top, 8)

                // Forecast header
                SkeletonPlaceholder(width: 140, height: 16)
                    .frame(maxWidth: .infinity, alignment: .leading)

                // Forecast cards
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(0..<5, id: \.self) { _ in
                            SkeletonPlaceholder(width: 72, height: 120, cornerRadius: 16)
                        }
                    }
                }
            }
            .padding()
        }
    }
}
