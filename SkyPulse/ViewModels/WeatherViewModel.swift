//
//  CoreLocation.swift
//  SkyPulse
//
//  Created by Faraz Amjad on 22.02.26.
//

import CoreLocation
import Foundation

@Observable
class WeatherViewModel {

    // MARK: - Published State

    var currentWeather: CurrentWeather?
    var dailyForecast: DailyForecast?
    var forecastDays: [ForecastDay] = []
    var isLoading = true
    var errorMessage: String?
    var searchResults: [GeocodingResult] = []
    var cityName = "My Location"
    var searchText = ""
    var weatherCode: Int = 3

    // MARK: - Private

    let locationManager = LocationManager()
    private var currentLatitude: Double?
    private var currentLongitude: Double?

    // MARK: - Load Weather (initial)

    func loadWeather() async {
        isLoading = true
        errorMessage = nil

        locationManager.requestLocation()

        // Wait for location (up to ~10 seconds)
        for _ in 0..<20 {
            if let location = locationManager.location {
                currentLatitude = location.coordinate.latitude
                currentLongitude = location.coordinate.longitude
                await reverseGeocode(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                await fetchWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                return
            }
            if locationManager.locationError != nil {
                break
            }
            try? await Task.sleep(for: .milliseconds(500))
        }

        if let error = locationManager.locationError {
            errorMessage = error
        } else {
            errorMessage = "Could not determine your location. Please search for a city."
        }
        isLoading = false
    }

    // MARK: - Fetch Weather by Coordinates

    func fetchWeather(latitude: Double, longitude: Double) async {
        isLoading = true
        errorMessage = nil
        currentLatitude = latitude
        currentLongitude = longitude

        do {
            let response = try await WeatherService.fetchWeather(latitude: latitude, longitude: longitude)
            currentWeather = response.current
            dailyForecast = response.daily
            weatherCode = response.current.weatherCode
            forecastDays = parseForecastDays(from: response.daily)
            isLoading = false
        } catch {
            errorMessage = "Failed to load weather data. Pull to refresh."
            isLoading = false
        }
    }

    // MARK: - Search Cities

    func searchCities(query: String) async {
        guard query.count >= 2 else {
            searchResults = []
            return
        }

        do {
            searchResults = try await WeatherService.searchCities(query: query)
        } catch {
            searchResults = []
        }
    }

    // MARK: - Select City

    func selectCity(_ city: GeocodingResult) async {
        let displayName: String
        if let admin = city.admin1, let country = city.country {
            displayName = "\(city.name), \(admin), \(country)"
        } else if let country = city.country {
            displayName = "\(city.name), \(country)"
        } else {
            displayName = city.name
        }
        cityName = displayName
        searchText = ""
        searchResults = []
        await fetchWeather(latitude: city.latitude, longitude: city.longitude)
    }

    // MARK: - Refresh

    func refresh() async {
        if let lat = currentLatitude, let lon = currentLongitude {
            await fetchWeather(latitude: lat, longitude: lon)
        } else {
            await loadWeather()
        }
    }

    // MARK: - Use Current Location

    func useCurrentLocation() async {
        cityName = "My Location"
        currentLatitude = nil
        currentLongitude = nil
        await loadWeather()
    }

    // MARK: - Helpers

    private func parseForecastDays(from daily: DailyForecast) -> [ForecastDay] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEE"

        var days: [ForecastDay] = []

        for i in 0..<min(daily.time.count, daily.temperature2mMax.count) {
            guard let date = dateFormatter.date(from: daily.time[i]) else { continue }
            let dayName: String
            if i == 0 {
                dayName = "Today"
            } else {
                dayName = dayFormatter.string(from: date)
            }

            days.append(ForecastDay(
                date: date,
                dayName: dayName,
                weatherCode: i < daily.weatherCode.count ? daily.weatherCode[i] : 3,
                tempMax: daily.temperature2mMax[i],
                tempMin: i < daily.temperature2mMin.count ? daily.temperature2mMin[i] : 0
            ))
        }

        return days
    }

    private func reverseGeocode(latitude: Double, longitude: Double) async {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            if let placemark = placemarks.first {
                cityName = placemark.locality ?? placemark.name ?? "My Location"
            }
        } catch {
            cityName = "My Location"
        }
    }
}
