//
//  ViewController.swift
//  Weather
//
//  Created by Daniil G on 01.10.2020.
//  Copyright © 2020 Daniil G. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class ViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var nameMyCityLocation: UILabel!
    @IBOutlet weak var tempMyCityLocation: UILabel!
    @IBOutlet weak var tableAllCity: UITableView!
    
    // MARK: - Properties
    private let locationManager = CLLocationManager()
    private let weather = FetchWeather()
    private let coreData = CoreDataController()
    private var location: (latitude: Double, longitude: Double)? // Моя геолокация
    private var allCity: [MyCity] = [] // Все города, включая город по геолокации
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setupLocation()
        start()
        timer()
        setNavigationController()
    }
    
    private func setTableView() {
        tableAllCity.register(UINib(nibName: "CityCell", bundle: nil), forCellReuseIdentifier: "CityCell")
    }
    
    func setNavigationController() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func updateBeforeAddCity() {
        DispatchQueue.main.async {
            self.coreData.getMyCity() { city in
                self.allCity = city
                self.tableAllCity.reloadData()
            }
            self.tableAllCity.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if case let controller as AddCityViewController = segue.destination, segue.identifier == "segue" {
            controller.completion = { city in
                self.updateBeforeAddCity()
            }
        }
    }
    
    @objc func timer() {
        Timer.scheduledTimer(timeInterval: 600, target: self, selector: #selector(self.timer), userInfo: nil, repeats: true)
        for i in self.allCity {
            self.weather.fetchWeatherDataLocation(latitude: i.latitude, longitude: i.longitude) { city in
                self.coreData.updateTempInCity(newTemp: (Int((city.last?.list?.last?.main.temp!)!) - 273), name: (city.last?.city!.name)!)
            }
        }
        
        self.coreData.getMyCity() { city in
            self.allCity = city
            self.tableAllCity.reloadData()
        }
        self.tableAllCity.reloadData()
    }

}

// MARK: - Extension UITableView
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableAllCity.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CityCell
        cell.cityName.text = allCity[indexPath.row].name
        cell.cityTemp.text = "\(allCity[indexPath.row].temp) °С"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = (storyboard?.instantiateViewController(withIdentifier: "ViewControllerTest") as? DetailWeatherCityViewController)!
        vc.latitude = allCity[indexPath.row].latitude
        vc.longitude = allCity[indexPath.row].longitude
        self.navigationController?.pushViewController(vc, animated: true)
        
        self.tableAllCity.reloadData()
    }
}

// MARK: - Extension CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    
    private func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        guard let lastLocation = locations.last else { return }
        self.location = (Double(lastLocation.coordinate.latitude), Double(lastLocation.coordinate.longitude))
        
        self.weather.fetchWeatherDataLocation(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude) { city in
            self.coreData.getCityLocation() { detCity in
                if detCity.count == 0 {
                    
                    self.nameMyCityLocation.text = "\((city.last?.city!.name)!)"
                    self.tempMyCityLocation.text = "\(Int((city.last?.list?.last?.main.temp!)!) - 273) °С"
                    
                    self.coreData.saveCityLocation(name: (city.last?.city!.name)!, temp: (Int((city.last?.list?.last?.main.temp!)!) - 273), latitude: (city.last?.city?.coord.lat)!, longitude: (city.last?.city?.coord.lon)!)
                    self.coreData.saveMyCity(name: (city.last?.city!.name)!, temp: (Int((city.last?.list?.last?.main.temp!)!) - 273), latitude: (city.last?.city?.coord.lat)!, longitude: (city.last?.city?.coord.lon)!)
                    self.coreData.getMyCity() { city in
                        self.allCity.append(city.last!)
                        self.tableAllCity.reloadData()
                    }
                } else {
                    self.start()
                }
            }
        }
    }
    
    private func start() {
        self.coreData.getCityLocation() { city in
            if city.count != 0 {
                self.nameMyCityLocation.text = "\((city.last?.name)!)"
                self.tempMyCityLocation.text = "\((city.last?.temp)!) °С"
            }
        }
        self.coreData.getMyCity() { city in
        self.allCity = city
        self.tableAllCity.reloadData()
      }
    }
}

////
////  ViewController.swift
////  Weather
////
////  Created by Daniil G on 01.10.2020.
////  Copyright © 2020 Daniil G. All rights reserved.
////
//
//import UIKit
//import CoreLocation
//import CoreData
//
//class ViewController: UIViewController {
//
//    // MARK: - IBOutlets
//    @IBOutlet weak var nameMyCityLocation: UILabel!
//    @IBOutlet weak var tempMyCityLocation: UILabel!
//    @IBOutlet weak var tableAllCity: UITableView!
//
//    // MARK: - Properties
//    private let locationManager = CLLocationManager()
//    private let weather = FetchWeather()
//    private let coreData = CoreDataController()
//    private var location: (latitude: Double, longitude: Double)? // Моя геолокация
//    private var allCity: [MyCity] = [] // Все города, включая город по геолокации
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setTableView()
//        setupLocation()
//        setNavigationController()
//    }
//
//    private func setTableView() {
//        tableAllCity.register(UINib(nibName: "CityCell", bundle: nil), forCellReuseIdentifier: "CityCell")
//    }
//
//    func setNavigationController() {
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.isTranslucent = true
//    }
//
//    private func updateUI() {
//        tableAllCity.reloadData()
//        guard let name = allCity.first?.name, let temp = (allCity.first?.temp) else { return }
//        self.nameMyCityLocation.text = name
//        self.tempMyCityLocation.text = "\(temp) °С"
//    }
//
//    func updateBeforeAddCity() {
//        DispatchQueue.main.async {
//            self.coreData.getMyCity() { city in
//                self.allCity = city
//                print(self.allCity.count)
//                self.tableAllCity.reloadData()
//            }
//            self.updateUI()
//        }
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if case let controller as AddCityViewController = segue.destination, segue.identifier == "segue" {
//            controller.completion = { city in
//                self.updateBeforeAddCity()
//            }
//        }
//    }
//
//    @objc func timer() {
//        Timer.scheduledTimer(timeInterval: 120, target: self, selector: #selector(self.timer), userInfo: nil, repeats: true)
//
//        for i in self.allCity {
//            self.weather.fetchWeatherDataLocation(latitude: i.latitude, longitude: i.longitude) { city in
//                self.coreData.updateTempInCity(newTemp: (Int((city.last?.list?.last?.main.temp!)!) - 273), name: (city.last?.city!.name)!)
//            }
//        }
//
//        self.coreData.getMyCity() { city in
//            self.allCity = city
//            self.updateUI()
//        }
//        self.updateUI()
//    }
//
//}
//
//// MARK: - Extension UITableView
//extension ViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return allCity.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableAllCity.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CityCell
//        cell.cityName.text = allCity[indexPath.row].name
//        cell.cityTemp.text = "\(allCity[indexPath.row].temp) °С"
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = (storyboard?.instantiateViewController(withIdentifier: "ViewControllerTest") as? DetailWeatherCityViewController)!
//        vc.latitude = allCity[indexPath.row].latitude
//        vc.longitude = allCity[indexPath.row].longitude
//        self.navigationController?.pushViewController(vc, animated: true)
//
//        self.tableAllCity.reloadData()
//    }
//}
//
//// MARK: - Extension CLLocationManagerDelegate
//extension ViewController: CLLocationManagerDelegate {
//
//    private func setupLocation() {
//       locationManager.delegate = self
//       locationManager.requestWhenInUseAuthorization()
//       locationManager.startUpdatingLocation()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        locationManager.stopUpdatingLocation()
//        guard let lastLocation = locations.last else { return }
//        self.location = (Double(lastLocation.coordinate.latitude), Double(lastLocation.coordinate.longitude))
//        self.weather.fetchWeatherDataLocation(latitude:lastLocation.coordinate.latitude, longitude: self.location!.longitude) { city in
//
//        }
//        setLocationCity()
//    }
//
//    // Если в getCityLocation нет записи о городе(по локации), то добавляем его в allCity[MyCity]
//    private func setLocationCity() {
//        self.coreData.getCityLocation() { city in
//            if city.count == 0 {
//                self.weather.fetchWeatherDataLocation(latitude: self.location!.latitude, longitude: self.location!.longitude) { city in
//                    self.coreData.saveMyCity(name: (city.last?.city!.name)!, temp: (Int((city.last?.list?.last?.main.temp!)!) - 273), latitude: (city.last?.city?.coord.lat)!, longitude: (city.last?.city?.coord.lon)!)
//
//                    self.coreData.saveCityLocation(name: (city.last?.city!.name)!, temp: (Int((city.last?.list?.last?.main.temp!)!) - 273), latitude: (city.last?.city?.coord.lat)!, longitude: (city.last?.city?.coord.lon)!)
//
//                    self.coreData.getMyCity() { city in
//                        self.allCity.append(city.first!)
//                        self.updateUI()
//                        self.timer()
//                    }
//                }
//            } else {
//                self.coreData.getMyCity() { city in
//                    self.allCity = city
//                    self.updateUI()
//                    self.timer()
//                }
//            }
//        }
//    }
//}
