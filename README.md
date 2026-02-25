# SkyPulse

A modern iOS weather app built with SwiftUI that delivers real-time weather data and 5-day forecasts using the Open-Meteo API — no API key required.

## Features

- **Current Weather** — Temperature, condition, humidity, wind speed, feels like, visibility, and pressure in a card-based 2x3 grid
- **5-Day Forecast** — Horizontal scrollable forecast with daily highs/lows and weather icons
- **Location-Based** — Automatically fetches weather for your current location via CoreLocation
- **City Search** — Search any city worldwide with debounced suggestions from the Open-Meteo Geocoding API
- **Dark / Light Mode** — Toggle between themes with a sun/moon switch, persisted across sessions
- **Weather-Adaptive Background** — Gradient shifts based on current conditions (warm for sunny, dark for storms, cool blue for rain)
- **Pull to Refresh** — Swipe down to refresh weather data
- **Shimmer Loading** — Skeleton placeholder with animated shimmer while data loads
- **Graceful Error Handling** — User-friendly error view with retry
- **WMO Code Mapping** — 30 weather codes mapped to human-readable labels and SF Symbols

## Tech Stack

- **Language:** Swift 6
- **UI Framework:** SwiftUI
- **Minimum Target:** iOS 26.2
- **Networking:** URLSession with async/await
- **Location:** CoreLocation
- **Persistence:** @AppStorage (UserDefaults)

## Architecture

**MVVM (Model-View-ViewModel)**

```
SkyPulse/
├── Models/
│   ├── WeatherModels.swift          # API response models (Codable)
│   └── GeocodingModels.swift        # City search models
├── Views/
│   ├── WeatherDetailCard.swift      # Weather detail tile
│   ├── ForecastSection.swift        # 5-day forecast scroll
│   ├── ShimmerView.swift            # Skeleton loading placeholder
│   └── ErrorView.swift              # Error state with retry
├── ViewModels/
│   └── WeatherViewModel.swift       # Main view model (@Observable)
├── Services/
│   ├── WeatherService.swift         # Open-Meteo API calls
│   └── LocationManager.swift        # CoreLocation wrapper
├── Utilities/
│   ├── WeatherCodeMapper.swift      # WMO code → SF Symbol + label
│   └── Theme.swift                  # Colors, gradients, environment
├── ContentView.swift                # Main app view
└── SkyPulseApp.swift                # App entry point
```

## API

This app uses the **[Open-Meteo API](https://open-meteo.com/)** — completely free and open-source, no API key needed.

- **Weather:** `api.open-meteo.com/v1/forecast`
- **Geocoding:** `geocoding-api.open-meteo.com/v1/search`

## Setup

1. Clone the repository
   ```bash
   git clone https://github.com/farazamjad22/SkyPulse-iOS-App.git
   cd SkyPulse
   ```

2. Open in Xcode
   ```bash
   open SkyPulse.xcodeproj
   ```

3. Select an iPhone simulator (iOS 26.2+) and press **Cmd + R**

4. Allow location access when prompted, or use the search bar to find any city

> No API keys or configuration needed.

## Screenshots
<img width="300" alt="Simulator Screenshot - iPhone 17 Pro - 2026-02-22 at 23 00 40" src="https://github.com/user-attachments/assets/d7582f43-4e27-46d1-8387-36cf4b05db29" />
<img width="300" alt="Simulator Screenshot - iPhone 17 Pro - 2026-02-22 at 23 01 54" src="https://github.com/user-attachments/assets/63dec9f5-0db7-4c27-820b-df4f432c6311" />
<img width="300" alt="Simulator Screenshot - iPhone 17 Pro - 2026-02-22 at 23 02 04" src="https://github.com/user-attachments/assets/6dfc1664-722b-447c-b8cc-24512e4d1f72" />
<img width="300" alt="Simulator Screenshot - iPhone 17 Pro - 2026-02-22 at 23 01 36" src="https://github.com/user-attachments/assets/ff30446e-6323-4a6a-a0e5-0da45ffe3050" />
