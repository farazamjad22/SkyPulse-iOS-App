//
//  WeatherResponse.swift
//  SkyPulse
//
//  Created by Faraz Amjad on 22.02.26.
//

import Foundation

struct WeatherResponse: Codable, Sendable {
    let current: CurrentWeather
    let daily: DailyForecast
}

struct CurrentWeather: Codable, Sendable {
    let temperature2m: Double
    let weatherCode: Int
    let windSpeed10m: Double
    let relativeHumidity2m: Int
    let apparentTemperature: Double
    let visibility: Double
    let surfacePressure: Double

    enum CodingKeys: String, CodingKey {
        case temperature2m = "temperature_2m"
        case weatherCode = "weather_code"
        case windSpeed10m = "wind_speed_10m"
        case relativeHumidity2m = "relative_humidity_2m"
        case apparentTemperature = "apparent_temperature"
        case visibility
        case surfacePressure = "surface_pressure"
    }
}

struct DailyForecast: Codable, Sendable {
    let time: [String]
    let weatherCode: [Int]
    let temperature2mMax: [Double]
    let temperature2mMin: [Double]

    enum CodingKeys: String, CodingKey {
        case time
        case weatherCode = "weather_code"
        case temperature2mMax = "temperature_2m_max"
        case temperature2mMin = "temperature_2m_min"
    }
}

struct ForecastDay: Identifiable, Sendable {
    let id = UUID()
    let date: Date
    let dayName: String
    let weatherCode: Int
    let tempMax: Double
    let tempMin: Double
}
