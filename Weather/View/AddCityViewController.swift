//
//  AddCityViewController.swift
//  Weather
//
//  Created by Daniil G on 01.10.2020.
//  Copyright © 2020 Daniil G. All rights reserved.
//

import UIKit

final class AddCityViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var infoAboutCity: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Properties
    private let weather = FetchWeather()
    private let coreData = CoreDataController()
    var completion: ((Weather) -> ())?
    private var city: [Weather] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    @IBAction func backPresser(sender: UIButton) {
        guard let citySearch = city.last else { return }
        completion?(citySearch)
        self.coreData.saveMyCity(name: citySearch.city!.name, temp: Int((citySearch.list?.last?.main.temp)!)-273, latitude: (citySearch.city?.coord.lat)!, longitude: (citySearch.city?.coord.lon)!)
        navigationController?.popViewController(animated: true)
    }
}

extension AddCityViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.weather.fetchWeatherDataName(name: "\(searchText)") { city in
            guard let citySearch = city.last?.list?.last?.main.temp else {return}
            DispatchQueue.main.async {
                self.infoAboutCity.text = "\(searchText) \n \(Int(citySearch - 273)) °С"
                self.city = city
            }
        }
    }
}
