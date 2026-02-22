//
//  ContentView.swift
//  SkyPulse
//
//  Created by Faraz Amjad on 22.02.26.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isDarkMode") private var isDarkMode = true
    @State private var viewModel = WeatherViewModel()

    private var weatherInfo: WeatherCodeMapper.WeatherInfo {
        WeatherCodeMapper.info(for: viewModel.weatherCode)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient
                    .ignoresSafeArea()

                Group {
                    if viewModel.isLoading {
                        SkeletonLoadingView()
                    } else if let error = viewModel.errorMessage {
                        ErrorView(message: error) {
                            Task { await viewModel.loadWeather() }
                        }
                    } else {
                        weatherContent
                    }
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("SkyPulse")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Theme.accentColor(isDark: isDarkMode))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    darkModeToggle
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Search city...")
            .searchSuggestions {
                ForEach(viewModel.searchResults) { result in
                    Button {
                        Task { await viewModel.selectCity(result) }
                    } label: {
                        searchSuggestionLabel(for: result)
                    }
                }
            }
            .task(id: viewModel.searchText) {
                guard viewModel.searchText.count >= 2 else {
                    viewModel.searchResults = []
                    return
                }
                try? await Task.sleep(for: .milliseconds(400))
                guard !Task.isCancelled else { return }
                await viewModel.searchCities(query: viewModel.searchText)
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .environment(\.isDarkMode, isDarkMode)
        .task {
            await viewModel.loadWeather()
        }
    }

    // MARK: - Background

    private var backgroundGradient: some View {
        Theme.backgroundGradient(for: viewModel.weatherCode, isDark: isDarkMode)
    }

    // MARK: - Dark Mode Toggle

    private var darkModeToggle: some View {
        HStack(spacing: 6) {
            Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                .font(.subheadline)
                .foregroundStyle(Theme.accentColor(isDark: isDarkMode))

            Toggle("", isOn: $isDarkMode)
                .labelsHidden()
                .tint(Theme.accentColor(isDark: isDarkMode))
                .scaleEffect(0.8)
        }
    }

    // MARK: - Weather Content

    private var weatherContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                headerSection
                temperatureSection
                weatherDetailsGrid
                ForecastSection(forecastDays: viewModel.forecastDays)
            }
            .padding()
            .padding(.bottom, 20)
        }
        .refreshable {
            await viewModel.refresh()
        }
    }

    // MARK: - Header (City + Icon)

    private var headerSection: some View {
        VStack(spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "location.fill")
                    .font(.caption)
                    .foregroundStyle(Theme.accentColor(isDark: isDarkMode))

                Text(viewModel.cityName)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundStyle(Theme.primaryTextColor(isDark: isDarkMode))
            }
            .padding(.top, 8)

            Image(systemName: weatherInfo.sfSymbol)
                .font(.system(size: 64))
                .foregroundStyle(Theme.accentColor(isDark: isDarkMode))
                .symbolRenderingMode(.hierarchical)
                .contentTransition(.symbolEffect(.replace))
        }
    }

    // MARK: - Temperature

    private var temperatureSection: some View {
        VStack(spacing: 4) {
            if let weather = viewModel.currentWeather {
                Text("\(Int(weather.temperature2m.rounded()))°")
                    .font(.system(size: 72, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.primaryTextColor(isDark: isDarkMode))
                    .contentTransition(.numericText())

                Text(weatherInfo.condition)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundStyle(Theme.secondaryTextColor(isDark: isDarkMode))
            }
        }
    }

    // MARK: - Weather Details Grid

    private var weatherDetailsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            if let weather = viewModel.currentWeather {
                WeatherDetailCard(
                    title: "Humidity",
                    value: "\(weather.relativeHumidity2m)%",
                    icon: "humidity.fill"
                )
                WeatherDetailCard(
                    title: "Wind Speed",
                    value: String(format: "%.1f km/h", weather.windSpeed10m),
                    icon: "wind"
                )
                WeatherDetailCard(
                    title: "Feels Like",
                    value: "\(Int(weather.apparentTemperature.rounded()))°",
                    icon: "thermometer.medium"
                )
                WeatherDetailCard(
                    title: "Visibility",
                    value: String(format: "%.0f km", weather.visibility / 1000),
                    icon: "eye.fill"
                )
                WeatherDetailCard(
                    title: "Pressure",
                    value: String(format: "%.0f hPa", weather.surfacePressure),
                    icon: "gauge.with.dots.needle.33percent"
                )
                WeatherDetailCard(
                    title: "Condition",
                    value: weatherInfo.condition,
                    icon: weatherInfo.sfSymbol
                )
            }
        }
    }

    // MARK: - Search Suggestion

    private func searchSuggestionLabel(for result: GeocodingResult) -> some View {
        Label {
            VStack(alignment: .leading, spacing: 2) {
                Text(result.name)
                    .font(.body)
                if let admin = result.admin1, let country = result.country {
                    Text("\(admin), \(country)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else if let country = result.country {
                    Text(country)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        } icon: {
            Image(systemName: "mappin.circle.fill")
                .foregroundStyle(Theme.accentColor(isDark: isDarkMode))
        }
    }
}

#Preview {
    ContentView()
}

