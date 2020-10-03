//
//  DetailTableViewCell.swift
//  Weather
//
//  Created by Daniil G on 02.10.2020.
//  Copyright © 2020 Daniil G. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
        }
    }
    
    // MARK: - Properties
    var cityDate = [String]()
    var cityTemp = [Int]()

    func configure(date: [String], temp: [Int]) {
        self.cityDate = date
        self.cityTemp = temp
    }
    
}

// MARK: - Extension UICollectionView
extension DetailTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cityDate.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CustomCollectionViewCell
        cell.dataCity.text = cityDate[indexPath.row]
        cell.temp.text = "\(cityTemp[indexPath.row]) °С"
        return cell
    }
    
}

