//
//  City.swift
//  Weather
//
//  Created by Vinoth Varatharajan on 16/06/19.
//  Copyright © 2019 Vin. All rights reserved.
//

import Foundation

// MARK: - City
struct City: Codable {
    let weather: [WeatherInfo]
    let main: Main
    let wind: Wind
    let name: String
    var date : String?
}

// MARK: - Main
struct Main: Codable {
    let temp: Double
    let pressure, humidity: Int
    let tempMin, tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

// MARK: - Weather
struct WeatherInfo: Codable {
    let id: Int
    let main, weatherDescription, icon: String
    
    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
}

extension Main {
    
    func tempInCelcius() -> String {
            let celsiusTemp = temp - 273.15
            return String(format: "%.0f℃", celsiusTemp)
    }
}
