//
//  WeatherServiceError.swift
//  SkyPulse
//
//  Created by Faraz Amjad on 22.02.26.
//

import Foundation

enum WeatherServiceError: Error, LocalizedError {
    case invalidURL
    case networkError(String)
    case decodingError(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid request URL."
        case .networkError(let message):
            return "Network error: \(message)"
        case .decodingError(let message):
            return "Data error: \(message)"
        }
    }
}

enum WeatherService {

    private static let weatherBaseURL = "https://api.open-meteo.com/v1/forecast"
    private static let geocodingBaseURL = "https://geocoding-api.open-meteo.com/v1/search"

    // MARK: - Fetch Weather

    static func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherResponse {
        var components = URLComponents(string: weatherBaseURL)
        components?.queryItems = [
            URLQueryItem(name: "latitude", value: String(latitude)),
            URLQueryItem(name: "longitude", value: String(longitude)),
            URLQueryItem(
                name: "current",
                value: "temperature_2m,weather_code,wind_speed_10m,relative_humidity_2m,apparent_temperature,visibility,surface_pressure"
            ),
            URLQueryItem(
                name: "daily",
                value: "weather_code,temperature_2m_max,temperature_2m_min"
            ),
            URLQueryItem(name: "timezone", value: "auto"),
            URLQueryItem(name: "forecast_days", value: "5"),
        ]

        guard let url = components?.url else {
            throw WeatherServiceError.invalidURL
        }
        print("[WeatherService] Requesting weather: \(url.absoluteString)")

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            if let httpResponse = response as? HTTPURLResponse {
                print("[WeatherService] Weather response status code: \(httpResponse.statusCode)")
            }
            if let jsonString = String(data: data, encoding: .utf8) {
                print("[WeatherService] Weather raw response: \(jsonString)")
            }
            let decoder = JSONDecoder()
            return try decoder.decode(WeatherResponse.self, from: data)
        } catch let error as DecodingError {
            print("[WeatherService] Decoding error: \(error)")
            throw WeatherServiceError.decodingError(error.localizedDescription)
        } catch let error as WeatherServiceError {
            throw error
        } catch {
            print("[WeatherService] Network error: \(error)")
            throw WeatherServiceError.networkError(error.localizedDescription)
        }
    }

    // MARK: - Search Cities

    static func searchCities(query: String) async throws -> [GeocodingResult] {
        guard let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return []
        }

        var components = URLComponents(string: geocodingBaseURL)
        components?.queryItems = [
            URLQueryItem(name: "name", value: encoded),
            URLQueryItem(name: "count", value: "8"),
            URLQueryItem(name: "language", value: "en"),
        ]

        guard let url = components?.url else {
            throw WeatherServiceError.invalidURL
        }
        print("[WeatherService] Requesting geocoding: \(url.absoluteString)")

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            if let httpResponse = response as? HTTPURLResponse {
                print("[WeatherService] Geocoding response status code: \(httpResponse.statusCode)")
            }
            if let jsonString = String(data: data, encoding: .utf8) {
                print("[WeatherService] Geocoding raw response: \(jsonString)")
            }
            let responseData = try JSONDecoder().decode(GeocodingResponse.self, from: data)
            print("[WeatherService] Decoded geocoding results count: \(responseData.results?.count ?? 0)")
            return responseData.results ?? []
        } catch let error as DecodingError {
            print("[WeatherService] Geocoding decoding error: \(error)")
            throw WeatherServiceError.decodingError(error.localizedDescription)
        } catch let error as WeatherServiceError {
            print("[WeatherService] Geocoding service error: \(error)")
            throw error
        } catch {
            print("[WeatherService] Geocoding network error: \(error)")
            throw WeatherServiceError.networkError(error.localizedDescription)
        }
    }
}

