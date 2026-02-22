//
//  WeatherCodeMapper.swift
//  SkyPulse
//
//  Created by Faraz Amjad on 22.02.26.
//

import Foundation

enum WeatherCodeMapper {

    struct WeatherInfo: Sendable {
        let condition: String
        let sfSymbol: String
    }

    static func info(for code: Int) -> WeatherInfo {
        switch code {
        case 0:
            return WeatherInfo(condition: "Clear Sky", sfSymbol: "sun.max.fill")
        case 1:
            return WeatherInfo(condition: "Mainly Clear", sfSymbol: "sun.min.fill")
        case 2:
            return WeatherInfo(condition: "Partly Cloudy", sfSymbol: "cloud.sun.fill")
        case 3:
            return WeatherInfo(condition: "Overcast", sfSymbol: "cloud.fill")
        case 45:
            return WeatherInfo(condition: "Foggy", sfSymbol: "cloud.fog.fill")
        case 48:
            return WeatherInfo(condition: "Rime Fog", sfSymbol: "cloud.fog.fill")
        case 51:
            return WeatherInfo(condition: "Light Drizzle", sfSymbol: "cloud.drizzle.fill")
        case 53:
            return WeatherInfo(condition: "Drizzle", sfSymbol: "cloud.drizzle.fill")
        case 55:
            return WeatherInfo(condition: "Heavy Drizzle", sfSymbol: "cloud.drizzle.fill")
        case 56:
            return WeatherInfo(condition: "Freezing Drizzle", sfSymbol: "cloud.sleet.fill")
        case 57:
            return WeatherInfo(condition: "Freezing Drizzle", sfSymbol: "cloud.sleet.fill")
        case 61:
            return WeatherInfo(condition: "Light Rain", sfSymbol: "cloud.rain.fill")
        case 63:
            return WeatherInfo(condition: "Rain", sfSymbol: "cloud.rain.fill")
        case 65:
            return WeatherInfo(condition: "Heavy Rain", sfSymbol: "cloud.heavyrain.fill")
        case 66:
            return WeatherInfo(condition: "Freezing Rain", sfSymbol: "cloud.sleet.fill")
        case 67:
            return WeatherInfo(condition: "Freezing Rain", sfSymbol: "cloud.sleet.fill")
        case 71:
            return WeatherInfo(condition: "Light Snow", sfSymbol: "cloud.snow.fill")
        case 73:
            return WeatherInfo(condition: "Snow", sfSymbol: "cloud.snow.fill")
        case 75:
            return WeatherInfo(condition: "Heavy Snow", sfSymbol: "cloud.snow.fill")
        case 77:
            return WeatherInfo(condition: "Snow Grains", sfSymbol: "cloud.snow.fill")
        case 80:
            return WeatherInfo(condition: "Light Showers", sfSymbol: "cloud.sun.rain.fill")
        case 81:
            return WeatherInfo(condition: "Showers", sfSymbol: "cloud.rain.fill")
        case 82:
            return WeatherInfo(condition: "Heavy Showers", sfSymbol: "cloud.heavyrain.fill")
        case 85:
            return WeatherInfo(condition: "Light Snow Showers", sfSymbol: "cloud.snow.fill")
        case 86:
            return WeatherInfo(condition: "Heavy Snow Showers", sfSymbol: "cloud.snow.fill")
        case 95:
            return WeatherInfo(condition: "Thunderstorm", sfSymbol: "cloud.bolt.fill")
        case 96:
            return WeatherInfo(condition: "Thunderstorm with Hail", sfSymbol: "cloud.bolt.rain.fill")
        case 99:
            return WeatherInfo(condition: "Severe Thunderstorm", sfSymbol: "cloud.bolt.rain.fill")
        default:
            return WeatherInfo(condition: "Unknown", sfSymbol: "questionmark.circle.fill")
        }
    }
}
