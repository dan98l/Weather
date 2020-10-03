//
//  FetchWeather.swift
//  WeatherApp
//
//  Created by Daniil G on 27.09.2020.
//  Copyright © 2020 Daniil G. All rights reserved.
//

import Foundation

class FetchWeather {
    
    var weatherData = [Weather]()
    
    func fetchWeatherDataName(name: String, completion: @escaping ((_ city: [Weather]) -> ())) {
        let url = "http://api.openweathermap.org/data/2.5/forecast?q=\(name)&appid=0e003c04f51355a81ba9205dc640aaa2"
           APIService.getWeatherData(urlString: url) { [weak self] result in
               print("url:", url)
               let queue = DispatchQueue.global(qos: .utility)
               queue.async {
                   switch result {
                   case .success(let weatherList):
                       self?.weatherData = [weatherList]
                       completion(self!.weatherData)
                       case .failure(let error):
                       print("Error json: \(error)")
                   }
               }
        }
    }
    
    func fetchWeatherDataLocation(latitude: Double, longitude: Double, completion: @escaping ((_ city: [Weather]) -> ())) {
        APIService.getWeatherData(urlString: "http://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=0e003c04f51355a81ba9205dc640aaa2") { [weak self] result in
            let queue = DispatchQueue.global(qos: .utility)
            queue.async {
                switch result {
                case .success(let weatherList):
                    self?.weatherData = [weatherList]
                    completion(self!.weatherData)
                    case .failure(let error):
                    print("Error json: \(error)")
                }
            }
            
        }
    }
}

