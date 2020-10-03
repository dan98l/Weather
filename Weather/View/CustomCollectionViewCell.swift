//
//  CustomCollectionViewCell.swift
//  WeatherApp
//
//  Created by Daniil G on 30.09.2020.
//  Copyright © 2020 Daniil G. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var dataCity: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dataCity.text = nil
        temp.text = nil
    }
}
