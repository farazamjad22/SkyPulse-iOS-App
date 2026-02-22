//
//  GeocodingResponse.swift
//  SkyPulse
//
//  Created by Faraz Amjad on 22.02.26.
//

import Foundation

struct GeocodingResponse: Codable, Sendable {
    let results: [GeocodingResult]?
}

struct GeocodingResult: Codable, Identifiable, Sendable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let country: String?
    let admin1: String?
}
