//
//  Weather.swift
//  Weather
//
//  Created by Vinoth Varatharajan on 16/06/19.
//  Copyright © 2019 Vin. All rights reserved.
//

import Foundation

enum WeatherManager {
    
    case getCurrentWeather(_ city : String)
    
    var scheme: String {
        switch self {
        case .getCurrentWeather(_) : return "https"
        }
    }
    
    var host: String {
        switch self {
        case .getCurrentWeather(_) : return "api.openweathermap.org"
        }
    }
    
    var path: String {
        switch self {
        case .getCurrentWeather(_) : return "/data/2.5/weather"
        }
    }
    
    var parameters: [URLQueryItem] {
        switch self {
        case .getCurrentWeather(let city) :
            return [URLQueryItem(name: "q", value: city),
                    URLQueryItem(name: "APPID", value: APPID)]
        }
    }
    
    var method: String {
        switch self {
        case .getCurrentWeather(_): return "GET"
        }
    }
    
}
