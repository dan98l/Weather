//
//  ViewCOntrollerTest.swift
//  WeatherApp
//
//  Created by Daniil G on 29.09.2020.
//  Copyright © 2020 Daniil G. All rights reserved.
//

import UIKit

class DetailWeatherCityViewController:  UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var myTableView: UITableView!
    
    // MARK: - Properties
    private let weather = FetchWeather()
    private var weaterCity:[Weather] = [Weather]()
    private let headerReuseId = "TableHeaderViewReuseId"
    
    private var cityDate: [[String]] = []
    private var cityTemp:[[Int]] = []
    
    var latitude: Double!
    var longitude: Double!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setHeaderCell()
        getWeather()
        
    }
    
    class var customCell : CustomCollectionViewCell {
        let cell = Bundle.main.loadNibNamed("Cell", owner: self, options: nil)?.last
        return cell as! CustomCollectionViewCell
    }
    
    func setHeaderCell() {
        let headerNib = UINib(nibName: "CustomHeaderView", bundle: nil)
        self.myTableView.register(headerNib, forHeaderFooterViewReuseIdentifier: headerReuseId)
    }
    
    func getWeather() {
        weather.fetchWeatherDataLocation(latitude: latitude!, longitude: longitude!) { city  in
            self.weaterCity = city
            self.getData()
            DispatchQueue.main.async() {
                self.myTableView.reloadData()
            }
        }
    }
    
    func getData() {
        var week: [String] = []
        var temp: [Int] = []
        for weather in (self.weaterCity.last?.list)! {
            week.append(weather.dt_txt)
            temp.append(Int(weather.main.temp!) - 273)
        }

        var tempArrayRemp: [Int] = []
        
        var tempArray: [String] = []
        var dayName = week.first!.components(separatedBy: " ").first
        
        for day in 0...week.count - 1 {
            if week[day].components(separatedBy: " ").first == dayName {
                tempArray.append(week[day])
                tempArrayRemp.append(temp[day])
            } else {
                self.cityDate.append(tempArray)
                self.cityTemp.append(tempArrayRemp)
                tempArray = []
                tempArrayRemp = []
                dayName = week[day].components(separatedBy: " ").first
                tempArray.append(week[day])
                tempArrayRemp.append(temp[day])
            }
        }
    }
    
    func dateFromNormal(_ str: String) -> Date? {
        let formatterDate = DateFormatter()
        formatterDate.timeZone = TimeZone(abbreviation: "UTC")
        formatterDate.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatterDate.date(from: str)
    }
   
}
// MARK: - Extension UITableView
extension DetailWeatherCityViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) ->  Int {
        return cityDate.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) ->  CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DetailTableViewCell
        cell.configure(date: cityDate[indexPath.section], temp: cityTemp[indexPath.section])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerReuseId) as? CustomHeaderView
        if view == nil {
            view = CustomHeaderView.customView
        }
        if section == 0 {
            view?.headerLabel.text = "Today"
        } else {
            view?.headerLabel.text = "\((dateFromNormal(cityDate[section].first!)?.week())!)"
        }
        return view
    }
}
