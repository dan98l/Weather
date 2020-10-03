//
//  CustomHeaderView.swift
//  WeatherApp
//
//  Created by Daniil G on 27.09.2020.
//  Copyright © 2020 Daniil G. All rights reserved.
//

import UIKit
class CustomHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - IBOutlets
    @IBOutlet weak var headerLabel: UILabel!
    
    class var customView : CustomHeaderView {
        let cell = Bundle.main.loadNibNamed("CustomHeaderView", owner: self, options: nil)?.last
        return cell as! CustomHeaderView
    }
    
   override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.white
    }
}
