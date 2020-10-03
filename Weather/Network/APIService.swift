//
//  APIService.swift
//  Weather
//
//  Created by Daniil G on 01.10.2020.
//  Copyright © 2020 Daniil G. All rights reserved.
//

import Foundation

final class APIService {
    
    class func getWeatherData(urlString: String, completion: @escaping (Result<Weather, Error>) -> ()) {
        guard let url = URL(string: urlString) else {return}
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    print("DataTask error: \(error.localizedDescription)")
                    return
                }
                guard let data = data else { return }
                do {
                    let jsonData = try JSONDecoder().decode(Weather.self, from: data)
                    completion(.success(jsonData))
                } catch let error {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
}
