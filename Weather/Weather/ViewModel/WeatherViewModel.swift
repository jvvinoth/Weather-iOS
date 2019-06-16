//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Vinoth Varatharajan on 16/06/19.
//  Copyright © 2019 Vin. All rights reserved.
//

import Foundation

protocol WeatherInfoDelegate {
    func weatherInfoFetchSuccessful(city : City?)
}

class WeatherViewModel {
    
    var delegate: WeatherInfoDelegate?
    
    private var results : City? {
        didSet {
            saveWeather()
        }
    }
    
    var city = "" {
        didSet {
            
            if Reachability.isConnectedToNetwork() {
                getWeatherInfo()
            }
            else {
                if let cityWeather = getWeather(city: city){
                    delegate?.weatherInfoFetchSuccessful(city: cityWeather) //notify
                }
            }
        }
    }
    
    private func getWeatherInfo() {
        WeatherHelper.request(router: WeatherManager.getCurrentWeather(city)) { (result: Result<City, Error>) in
            switch result {
            case .success(let city): self.results = city
            case .failure:
                print(result)
            }
        }
    }
    
    private struct SerializationKeys {
        static let weather = "currentWeather"
    }
    
    func saveWeather() {
        
        if var city = results {
            city.date = getTodayString()
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(city) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: SerializationKeys.weather + "-" + city.name)
                delegate?.weatherInfoFetchSuccessful(city: city)
            }
        }
    }
    
    func getWeather(city : String) -> City? {
        
        let defaults = UserDefaults.standard
        if let savedWeather = defaults.object(forKey: SerializationKeys.weather + "-" + city) as? Data {
            let decoder = JSONDecoder()
            if let loadedWeather = try? decoder.decode(City.self, from: savedWeather) {
                return loadedWeather
            }
        }
        return nil
    }
    
    func getTodayString() -> String{
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, hh:mm a"
        let dayInWeek = dateFormatter.string(from: date)
        
        return dayInWeek
    }
}



