//
//  ForecastSection.swift
//  SkyPulse
//
//  Created by Faraz Amjad on 22.02.26.
//

import SwiftUI

struct ForecastSection: View {
    let forecastDays: [ForecastDay]

    @Environment(\.isDarkMode) private var isDarkMode

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("5-Day Forecast")
                .font(.headline)
                .foregroundStyle(Theme.primaryTextColor(isDark: isDarkMode))
                .padding(.horizontal, 4)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(forecastDays) { day in
                        ForecastDayCard(day: day)
                    }
                }
            }
        }
    }
}

struct ForecastDayCard: View {
    let day: ForecastDay

    @Environment(\.isDarkMode) private var isDarkMode

    private var weatherInfo: WeatherCodeMapper.WeatherInfo {
        WeatherCodeMapper.info(for: day.weatherCode)
    }

    var body: some View {
        VStack(spacing: 10) {
            Text(day.dayName)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(Theme.primaryTextColor(isDark: isDarkMode))

            Image(systemName: weatherInfo.sfSymbol)
                .font(.title2)
                .foregroundStyle(Theme.accentColor(isDark: isDarkMode))
                .symbolRenderingMode(.hierarchical)

            VStack(spacing: 2) {
                Text("\(Int(day.tempMax.rounded()))°")
                    .font(.headline)
                    .foregroundStyle(Theme.primaryTextColor(isDark: isDarkMode))

                Text("\(Int(day.tempMin.rounded()))°")
                    .font(.subheadline)
                    .foregroundStyle(Theme.secondaryTextColor(isDark: isDarkMode))
            }
        }
        .frame(width: 72, height: 130)
        .background(Theme.cardColor(isDark: isDarkMode))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
